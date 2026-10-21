-- VoidcoreAdvisor: VoidcacheScan
-- Scans the Nebulous Voidcache tooltip for each of the player's loot
-- specializations to determine which items are obtainable per spec per
-- dungeon.  Items the player cannot receive with a given spec are then
-- marked as obtained so they no longer appear in the tracker.
--
-- Scanning sequence (outer = spec, inner = dungeon) ensures the same
-- Voidcache item ID is never read on two consecutive tooltip calls, which
-- avoids the client cache returning stale spec data.
--
-- If a tooltip returns fewer than MIN_LINES lines it is retried in-place
-- with a small delay (up to MAX_RETRIES times) before moving on.  Once
-- MIN_LINES is reached the scan continues retrying until two consecutive
-- reads return the same line count, confirming the tooltip has fully loaded.
local _, VCA = ...

VCA.VoidcacheScan = {}
local Scan = VCA.VoidcacheScan

-- ── Tuning constants ──────────────────────────────────────────────────────────

local MAX_RETRIES = 5 -- per (spec, dungeon) pair before giving up
local RETRY_DELAY = 0.35 -- seconds between retries for the same item
local STEP_DELAY = 0.5 -- seconds between successful scan steps (slowed for readable logs)
local SPEC_CHANGE_DELAY = 1.2 -- seconds to wait after SetLootSpecialization
local MIN_LINES = 7 -- minimum tooltip lines required for a valid read

-- ── Logging ───────────────────────────────────────────────────────────────────

local function Log(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff9090ff[VCA Scan]|r " .. tostring(msg))
end

-- ── Combat-interrupt frame ────────────────────────────────────────────────────

local _combatFrame = CreateFrame("Frame")

-- ── Scan state ────────────────────────────────────────────────────────────────
-- nil when idle, table when a scan is running.

local _state = nil
local _raidState = nil

-- ── Progress callbacks ────────────────────────────────────────────────────────
-- Signature: fn(specIdx, specCount, dungeonIdx, dungeonCount, status)
--   During scan: specIdx/specCount/dungeonIdx/dungeonCount are numbers, status is nil.
--   On finish:   all four numbers are nil, status is "COMPLETE", "ABORTED", or "COMBAT".

local _progressCallback = nil
local _raidProgressCallback = nil

function Scan.SetProgressCallback(fn)
    _progressCallback = fn
end

function Scan.SetRaidProgressCallback(fn)
    _raidProgressCallback = fn
end

local function NotifyProgress(specIdx, specCount, dungeonIdx, dungeonCount, status)
    if _progressCallback then
        _progressCallback(specIdx, specCount, dungeonIdx, dungeonCount, status)
    end
end

local function NotifyRaidProgress(specIdx, specCount, encounterIdx, encounterCount, status)
    if _raidProgressCallback then
        _raidProgressCallback(specIdx, specCount, encounterIdx, encounterCount, status)
    end
end

-- ── Tooltip parsing ───────────────────────────────────────────────────────────

local function StripColorCodes(text)
    return (text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""))
end

-- Reads tooltip data from C_TooltipInfo and collects item names from line 7+.
-- Each item line is prefixed with "- " which is stripped to get the bare name.
-- Returns a { [itemName] = true } set, or nil when the data is missing or thin.
local function ParseVoidcacheTooltip(tooltipData, numLines)
    if numLines < MIN_LINES then
        return nil
    end
    local items = {}
    for i, lineData in ipairs(tooltipData.lines) do
        local text = lineData.leftText
        if text then
            -- Item entries start at line 7, each prefixed with "- "
            if i >= 7 then
                local clean = StripColorCodes(text)
                if clean:sub(1, 2) == "- " then
                    local itemName = clean:sub(3):match("^(.-)%s*$")
                    if itemName and itemName ~= "" then
                        items[itemName] = true
                    end
                end
            end
        end
    end
    return items
end

-- ── Name cache ────────────────────────────────────────────────────────────────

-- Returns { [localizedName] = itemID } for every item a specific spec can get
-- from the dungeon's Voidcache.  Relies on the item cache being warm.
local function BuildDungeonNameCache(instanceID, specID)
    local dungeonData = VCA.SeasonData and VCA.SeasonData.dungeons[instanceID]
    if not dungeonData then
        return {}
    end
    local itemIDs = (dungeonData.bySpec and dungeonData.bySpec[specID]) or {}
    local nameCache = {}
    local missing = 0
    for _, itemID in ipairs(itemIDs) do
        local name = C_Item.GetItemInfo(itemID)
        if name and name ~= "" then
            nameCache[name] = itemID
        else
            missing = missing + 1
        end
    end
    return nameCache
end

-- ── Public: availability check ────────────────────────────────────────────────

-- Returns true (or false, reason) indicating whether a scan can start now.
-- reason is "COMBAT" or "INSTANCE".
function Scan.CanScan()
    if InCombatLockdown() then
        return false, "COMBAT"
    end
    local _, instanceType = IsInInstance()
    if instanceType and instanceType ~= "none" then
        return false, "INSTANCE"
    end
    return true
end

function Scan.IsRunning()
    return _state ~= nil and _state.running == true
end

-- ── Abort ─────────────────────────────────────────────────────────────────────

local function AbortScan(reason)
    if not _state then
        return
    end
    _state.running = false

    -- Unregister guards before restoring loot spec so the restore call
    -- does not re-trigger the PLAYER_LOOT_SPEC_UPDATED handler.
    _combatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
    _combatFrame:UnregisterEvent("PLAYER_LOOT_SPEC_UPDATED")

    -- Restore the player's original loot spec.
    if _state.originalLootSpec ~= nil then
        SetLootSpecialization(_state.originalLootSpec)
    end

    NotifyProgress(nil, nil, nil, nil, reason or "ABORTED")
    _state = nil
end

-- ── Result application ────────────────────────────────────────────────────────

local function FinalizeScan()
    if not _state then
        return
    end

    local results = _state.results -- [specID][instanceID] = { [name]=true }
    local nameCaches = _state.nameCaches -- [specID][instanceID] = { [name]=itemID }
    local specs = _state.specs -- { {specID=N, index=I}, ... }

    local db = _G[VCA.CHAR_DB_NAME]
    if not db then
        AbortScan("NO_DB")
        return
    end

    local diffID = VCA.MythicPlusEJDifficulty
    local contentType = VCA.ContentType.MYTHIC_PLUS

    -- 1. Snapshot existing MYTHIC_PLUS obtained entries before clearing (enables restore).
    db.obtained = db.obtained or {}
    db.obtainedBackup = db.obtainedBackup or {}
    db.obtainedBackup.mythicPlus = {}
    db.obtainedBackup.mythicPlusTime = time()
    for key, val in pairs(db.obtained) do
        if key:sub(1, 12) == "MYTHIC_PLUS:" then
            db.obtainedBackup.mythicPlus[key] = val
        end
    end

    -- Clear all existing MYTHIC_PLUS obtained entries — the scan result is now authoritative.
    for key in pairs(db.obtained) do
        if key:sub(1, 12) == "MYTHIC_PLUS:" then
            db.obtained[key] = nil
        end
    end

    -- 2. Apply scan results for every season dungeon.
    local instanceIDs = VCA.LootPool.GetSeasonDungeonInstanceIDs()

    -- Apply results per-spec so each spec is only judged against its own item pool.
    local markedItemIDs = {}

    for _, specEntry in ipairs(specs) do
        local specID = specEntry.specID
        local specResults = results[specID] or {}
        local specCaches = nameCaches[specID] or {}

        for _, instanceID in ipairs(instanceIDs) do
            local nameCache = specCaches[instanceID] or {}
            local specItems = specResults[instanceID] or {}

            for itemName, itemID in pairs(nameCache) do
                if not specItems[itemName] then
                    -- Item is in this spec's pool but was NOT seen in the scan.
                    markedItemIDs[itemID] = true
                    VCA.Data.SetObtained(contentType, instanceID, diffID, specID, itemID, true)
                end
            end

        end
    end

    local totalMarked = 0
    for _ in pairs(markedItemIDs) do
        totalMarked = totalMarked + 1
    end

    Log(string.format("Scan complete — %d unique item(s) marked as obtained.", totalMarked))

    -- 3. Restore original loot spec.
    _combatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
    _combatFrame:UnregisterEvent("PLAYER_LOOT_SPEC_UPDATED")
    SetLootSpecialization(_state.originalLootSpec or 0)

    NotifyProgress(nil, nil, nil, nil, "COMPLETE")

    -- Refresh any open panels.
    if VCA.DungeonOverview and VCA.DungeonOverview.Refresh then
        VCA.DungeonOverview.Refresh()
    end

    _state = nil
end

-- ── Scan step ─────────────────────────────────────────────────────────────────

local ScanStep -- forward declaration

ScanStep = function()
    if not _state or not _state.running then
        return
    end

    -- All specs done → apply results.
    if _state.specIdx > #_state.specs then
        FinalizeScan()
        return
    end

    local specEntry = _state.specs[_state.specIdx]
    local dungeonEntry = _state.dungeons[_state.dungeonIdx]

    -- Set loot spec at the start of each new spec pass (first dungeon, no retries).
    if _state.dungeonIdx == 1 and _state.retries == 0 then
        if not _state.specSwitchDone then
            -- Request the spec change and wait for it to apply before reading tooltips.
            _state.expectingSpecChange = true
            SetLootSpecialization(specEntry.specID)
            _state.specSwitchDone = true
            C_Timer.After(SPEC_CHANGE_DELAY, ScanStep)
            return
        end
        -- Spec change has been applied; clear flag so the next spec gets its own delay.
        _state.expectingSpecChange = false
        _state.specSwitchDone = false
    end

    -- Read the Voidcache tooltip via C_TooltipInfo (pure data call, no frame needed).
    local tooltipData = C_TooltipInfo.GetItemByID(dungeonEntry.voidcacheID, nil, 16, 10)
    local numLines = (tooltipData and tooltipData.lines) and #tooltipData.lines or 0
    local parsed = ParseVoidcacheTooltip(tooltipData, numLines)

    if not parsed then
        -- Phase 1: tooltip not yet ready (< MIN_LINES) — retry in place.
        _state.retries = _state.retries + 1
        if _state.retries <= MAX_RETRIES then
            C_Timer.After(RETRY_DELAY, ScanStep)
            return
        end
        -- Gave up after MAX_RETRIES — treat as empty result.
        parsed = {}
    else
        -- Phase 2: tooltip has MIN_LINES+ lines — keep reading until two
        -- consecutive reads return the same line count (tooltip is stable).
        if _state.stableLines == nil then
            -- First good read — record baseline and re-read.
            _state.stableLines = numLines
            _state.stableParsed = parsed
            _state.retries = 0
            C_Timer.After(RETRY_DELAY, ScanStep)
            return
        elseif numLines ~= _state.stableLines then
            -- Line count still changing — update baseline and retry.
            _state.stableLines = numLines
            _state.stableParsed = parsed
            _state.retries = _state.retries + 1
            if _state.retries <= MAX_RETRIES then
                C_Timer.After(RETRY_DELAY, ScanStep)
                return
            end
            -- Timed out waiting for stability — use the last good read.
            parsed = _state.stableParsed
        end
        -- else: line count matches previous read — tooltip is stable, proceed.
    end

    -- Store result.
    _state.results[specEntry.specID] = _state.results[specEntry.specID] or {}
    _state.results[specEntry.specID][dungeonEntry.instanceID] = parsed
    _state.retries = 0
    _state.stableLines = nil
    _state.stableParsed = nil

    -- Advance position.
    _state.dungeonIdx = _state.dungeonIdx + 1
    if _state.dungeonIdx > #_state.dungeons then
        _state.dungeonIdx = 1
        _state.specIdx = _state.specIdx + 1
    end

    -- Notify progress (may call into DungeonOverview to update button text).
    NotifyProgress(_state.specIdx, #_state.specs, _state.dungeonIdx, #_state.dungeons, nil)

    C_Timer.After(STEP_DELAY, ScanStep)
end

-- ── Public: start ─────────────────────────────────────────────────────────────

function Scan.Start()
    local canScan, reason = Scan.CanScan()
    if not canScan then
        return false, reason
    end
    if Scan.IsRunning() then
        return false, "RUNNING"
    end
    if not VCA.SeasonData then
        return false, "NO_SEASON_DATA"
    end

    -- Build spec list from the current player's available specializations.
    local numSpecs = GetNumSpecializations()
    local specs = {}
    for i = 1, numSpecs do
        local specID = GetSpecializationInfo(i)
        if specID and specID > 0 then
            specs[#specs + 1] = {
                specID = specID,
                index = i
            }
        end
    end
    if #specs == 0 then
        return false, "NO_SPECS"
    end

    -- Build dungeon list restricted to dungeons that have a known Voidcache ID.
    local instanceIDs = VCA.LootPool.GetSeasonDungeonInstanceIDs()
    local dungeons = {}
    for _, instanceID in ipairs(instanceIDs) do
        local voidcacheID = VCA.DungeonVoidcacheIDs and VCA.DungeonVoidcacheIDs[instanceID]
        if voidcacheID then
            dungeons[#dungeons + 1] = {
                instanceID = instanceID,
                voidcacheID = voidcacheID
            }
        end
    end
    if #dungeons == 0 then
        return false, "NO_DUNGEONS"
    end

    -- Pre-build name caches per spec (requires item cache to be warm).
    Log(string.format("Starting scan: %d spec(s), %d dungeon(s)", #specs, #dungeons))
    local nameCaches = {} -- [specID][instanceID] = { [name]=itemID }
    for _, specEntry in ipairs(specs) do
        nameCaches[specEntry.specID] = {}
        for _, dungeonEntry in ipairs(dungeons) do
            nameCaches[specEntry.specID][dungeonEntry.instanceID] =
                BuildDungeonNameCache(dungeonEntry.instanceID, specEntry.specID)
        end
    end

    -- Initialise state.
    _state = {
        running = true,
        specs = specs,
        dungeons = dungeons,
        specIdx = 1,
        dungeonIdx = 1,
        retries = 0,
        stableLines = nil,
        stableParsed = nil,
        specSwitchDone = false,
        expectingSpecChange = false,
        results = {},
        nameCaches = nameCaches,
        originalLootSpec = GetLootSpecialization()
    }

    -- Register guards.
    _combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
    _combatFrame:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")

    -- Fire initial progress notification, then begin.
    NotifyProgress(1, #specs, 1, #dungeons, nil)
    C_Timer.After(0, ScanStep)

    return true
end

-- ── Combat guard ──────────────────────────────────────────────────────────────

_combatFrame:SetScript("OnEvent", function(self, event)
    if not _state or not _state.running then
        return
    end
    if event == "PLAYER_REGEN_DISABLED" then
        AbortScan("COMBAT")
    elseif event == "PLAYER_LOOT_SPEC_UPDATED" then
        if not _state.expectingSpecChange then
            Log("Scan aborted: loot spec changed manually during scan.")
            AbortScan("ABORTED")
        end
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- RAID SCAN
-- ─────────────────────────────────────────────────────────────────────────────

-- ── Raid name cache ───────────────────────────────────────────────────────────

local function BuildEncounterNameCache(encounterID, specID, diffID)
    local raidData = VCA.SeasonData and VCA.SeasonData.raids[encounterID]
    if not raidData then
        return {}
    end
    local specItems = raidData.bySpec and raidData.bySpec[diffID] and raidData.bySpec[diffID][specID] or {}
    local nameCache = {}
    for _, itemID in ipairs(specItems) do
        local name = C_Item.GetItemInfo(itemID)
        if name and name ~= "" then
            nameCache[name] = itemID
        end
    end
    return nameCache
end

-- ── Raid abort ────────────────────────────────────────────────────────────────

local _raidCombatFrame = CreateFrame("Frame")

local function AbortRaidScan(reason)
    if not _raidState then
        return
    end
    _raidState.running = false
    _raidCombatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
    _raidCombatFrame:UnregisterEvent("PLAYER_LOOT_SPEC_UPDATED")
    if _raidState.originalLootSpec ~= nil then
        SetLootSpecialization(_raidState.originalLootSpec)
    end
    NotifyRaidProgress(nil, nil, nil, nil, reason or "ABORTED")
    _raidState = nil
end

-- ── Raid finalize ─────────────────────────────────────────────────────────────

local function FinalizeRaidScan()
    if not _raidState then
        return
    end
    local results = _raidState.results -- [specID][encounterID] = { [name]=true }
    local nameCaches = _raidState.nameCaches -- [specID][encounterID] = { [name]=itemID }
    local specs = _raidState.specs

    local db = _G[VCA.CHAR_DB_NAME]
    if not db then
        AbortRaidScan("NO_DB")
        return
    end

    local diffID = _raidState.difficultyID
    local contentType = VCA.ContentType.RAID

    -- 1. Snapshot existing RAID obtained entries for this difficulty before clearing (enables restore).
    db.obtained = db.obtained or {}
    db.obtainedBackup = db.obtainedBackup or {}
    db.obtainedBackup.raid = {}
    db.obtainedBackup.raidTime = time()
    db.obtainedBackup.raidDiffID = diffID
    for key, val in pairs(db.obtained) do
        if key:sub(1, 5) == "RAID:" then
            local _, kDiff = key:match("^RAID:%d+:(%d+):")
            if tonumber(kDiff) == diffID then
                db.obtainedBackup.raid[key] = val
            end
        end
    end

    -- Clear all existing obtained entries for this raid difficulty — scan result is authoritative.
    for key in pairs(db.obtained) do
        -- Keys are formatted as "RAID:encounterID:diffID:specID:itemID"
        if key:sub(1, 5) == "RAID:" then
            local _, kDiff = key:match("^RAID:%d+:(%d+):")
            if tonumber(kDiff) == diffID then
                db.obtained[key] = nil
            end
        end
    end

    -- 2. Apply results per-spec.
    local markedItemIDs = {}
    for _, specEntry in ipairs(specs) do
        local specID = specEntry.specID
        local specResults = results[specID] or {}
        local specCaches = nameCaches[specID] or {}

        for encounterID, nameCache in pairs(specCaches) do
            local seenItems = specResults[encounterID] or {}
            for itemName, itemID in pairs(nameCache) do
                if not seenItems[itemName] then
                    markedItemIDs[itemID] = true
                    VCA.Data.SetObtained(contentType, encounterID, diffID, specID, itemID, true)
                end
            end
        end
    end

    local totalMarked = 0
    for _ in pairs(markedItemIDs) do
        totalMarked = totalMarked + 1
    end
    Log(string.format("Raid scan complete — %d unique item(s) marked as obtained.", totalMarked))

    -- 3. Restore original loot spec.
    _raidCombatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
    _raidCombatFrame:UnregisterEvent("PLAYER_LOOT_SPEC_UPDATED")
    SetLootSpecialization(_raidState.originalLootSpec or 0)

    NotifyRaidProgress(nil, nil, nil, nil, "COMPLETE")

    if VCA.RaidOverview and VCA.RaidOverview.Refresh then
        VCA.RaidOverview.Refresh()
    end

    _raidState = nil
end

-- ── Raid scan step ────────────────────────────────────────────────────────────

local RaidScanStep

RaidScanStep = function()
    if not _raidState or not _raidState.running then
        return
    end

    if _raidState.specIdx > #_raidState.specs then
        FinalizeRaidScan()
        return
    end

    local specEntry = _raidState.specs[_raidState.specIdx]
    local encounterEntry = _raidState.encounters[_raidState.encounterIdx]

    -- Spec change at the start of each new spec pass.
    if _raidState.encounterIdx == 1 and _raidState.retries == 0 then
        if not _raidState.specSwitchDone then
            _raidState.expectingSpecChange = true
            SetLootSpecialization(specEntry.specID)
            _raidState.specSwitchDone = true
            C_Timer.After(SPEC_CHANGE_DELAY, RaidScanStep)
            return
        end
        _raidState.expectingSpecChange = false
        _raidState.specSwitchDone = false
    end

    local tooltipData = C_TooltipInfo.GetItemByID(encounterEntry.voidcacheID, nil, 6)
    local numLines = (tooltipData and tooltipData.lines) and #tooltipData.lines or 0
    local parsed = ParseVoidcacheTooltip(tooltipData, numLines)

    if not parsed then
        -- Phase 1: tooltip not yet ready (< MIN_LINES) — retry in place.
        _raidState.retries = _raidState.retries + 1
        if _raidState.retries <= MAX_RETRIES then
            C_Timer.After(RETRY_DELAY, RaidScanStep)
            return
        end
        -- Gave up after MAX_RETRIES — treat as empty result.
        parsed = {}
    else
        -- Phase 2: tooltip has MIN_LINES+ lines — keep reading until two
        -- consecutive reads return the same line count (tooltip is stable).
        if _raidState.stableLines == nil then
            -- First good read — record baseline and re-read.
            _raidState.stableLines = numLines
            _raidState.stableParsed = parsed
            _raidState.retries = 0
            C_Timer.After(RETRY_DELAY, RaidScanStep)
            return
        elseif numLines ~= _raidState.stableLines then
            -- Line count still changing — update baseline and retry.
            _raidState.stableLines = numLines
            _raidState.stableParsed = parsed
            _raidState.retries = _raidState.retries + 1
            if _raidState.retries <= MAX_RETRIES then
                C_Timer.After(RETRY_DELAY, RaidScanStep)
                return
            end
            -- Timed out waiting for stability — use the last good read.
            parsed = _raidState.stableParsed
        end
        -- else: line count matches previous read — tooltip is stable, proceed.
    end

    _raidState.results[specEntry.specID] = _raidState.results[specEntry.specID] or {}
    _raidState.results[specEntry.specID][encounterEntry.encounterID] = parsed
    _raidState.retries = 0
    _raidState.stableLines = nil
    _raidState.stableParsed = nil

    -- Advance.
    _raidState.encounterIdx = _raidState.encounterIdx + 1
    if _raidState.encounterIdx > #_raidState.encounters then
        _raidState.encounterIdx = 1
        _raidState.specIdx = _raidState.specIdx + 1
    end

    NotifyRaidProgress(_raidState.specIdx, #_raidState.specs, _raidState.encounterIdx, #_raidState.encounters, nil)
    C_Timer.After(STEP_DELAY, RaidScanStep)
end

-- ── Public: start raid scan ───────────────────────────────────────────────────

function Scan.IsRaidRunning()
    return _raidState ~= nil and _raidState.running == true
end

function Scan.StartRaid(difficultyID)
    difficultyID = difficultyID or VCA.Difficulty.RAID_MYTHIC
    local canScan, reason = Scan.CanScan()
    if not canScan then
        return false, reason
    end
    if Scan.IsRaidRunning() then
        return false, "RUNNING"
    end
    if not VCA.SeasonData then
        return false, "NO_SEASON_DATA"
    end

    local numSpecs = GetNumSpecializations()
    local specs = {}
    for i = 1, numSpecs do
        local specID = GetSpecializationInfo(i)
        if specID and specID > 0 then
            specs[#specs + 1] = {
                specID = specID,
                index = i
            }
        end
    end
    if #specs == 0 then
        return false, "NO_SPECS"
    end

    -- Build encounter list from RaidEncounterCacheIDs.
    local encounters = {}
    if VCA.RaidEncounterCacheIDs then
        for encounterID, voidcacheID in pairs(VCA.RaidEncounterCacheIDs) do
            encounters[#encounters + 1] = {
                encounterID = encounterID,
                voidcacheID = voidcacheID
            }
        end
    end
    if #encounters == 0 then
        return false, "NO_ENCOUNTERS"
    end
    -- Sort for deterministic order.
    table.sort(encounters, function(a, b)
        return a.encounterID < b.encounterID
    end)

    -- Pre-build name caches.
    Log(string.format("Starting raid scan: %d spec(s), %d encounter(s), difficultyID=%d", #specs, #encounters, difficultyID))
    local nameCaches = {}
    for _, specEntry in ipairs(specs) do
        nameCaches[specEntry.specID] = {}
        for _, enc in ipairs(encounters) do
            nameCaches[specEntry.specID][enc.encounterID] = BuildEncounterNameCache(enc.encounterID, specEntry.specID, difficultyID)
        end
    end

    _raidState = {
        running = true,
        specs = specs,
        encounters = encounters,
        difficultyID = difficultyID,
        specIdx = 1,
        encounterIdx = 1,
        retries = 0,
        stableLines = nil,
        stableParsed = nil,
        specSwitchDone = false,
        expectingSpecChange = false,
        results = {},
        nameCaches = nameCaches,
        originalLootSpec = GetLootSpecialization()
    }

    _raidCombatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
    _raidCombatFrame:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")

    NotifyRaidProgress(1, #specs, 1, #encounters, nil)
    C_Timer.After(0, RaidScanStep)
    return true
end

-- ── Raid combat guard ─────────────────────────────────────────────────────────

_raidCombatFrame:SetScript("OnEvent", function(self, event)
    if not _raidState or not _raidState.running then
        return
    end
    if event == "PLAYER_REGEN_DISABLED" then
        AbortRaidScan("COMBAT")
    elseif event == "PLAYER_LOOT_SPEC_UPDATED" then
        if not _raidState.expectingSpecChange then
            Log("Raid scan aborted: loot spec changed manually during scan.")
            AbortRaidScan("ABORTED")
        end
    end
end)

-- ── Public: restore from backup ───────────────────────────────────────────────

-- Rolls back db.obtained to the snapshot taken just before the last scan
-- finalized.  contentType: "mythicplus", "raid", or nil to restore both.
-- Returns true, restoredCount on success; false, reason on failure.
function Scan.RestoreBackup(contentType)
    local db = _G[VCA.CHAR_DB_NAME]
    if not db then
        return false, "NO_DB"
    end
    local backup = db.obtainedBackup
    if not backup then
        return false, "NO_BACKUP"
    end

    local wantMP = not contentType or contentType == "mythicplus"
    local wantRaid = not contentType or contentType == "raid"

    if wantMP and not backup.mythicPlus then
        wantMP = false
    end
    if wantRaid and not backup.raid then
        wantRaid = false
    end
    if not wantMP and not wantRaid then
        return false, "NO_BACKUP"
    end

    db.obtained = db.obtained or {}
    local restoredCount = 0

    if wantMP then
        for key in pairs(db.obtained) do
            if key:sub(1, 12) == "MYTHIC_PLUS:" then
                db.obtained[key] = nil
            end
        end
        for key, val in pairs(backup.mythicPlus) do
            db.obtained[key] = val
            restoredCount = restoredCount + 1
        end
    end

    if wantRaid then
        local diffID = backup.raidDiffID or VCA.Difficulty.RAID_MYTHIC
        for key in pairs(db.obtained) do
            if key:sub(1, 5) == "RAID:" then
                local _, kDiff = key:match("^RAID:%d+:(%d+):")
                if tonumber(kDiff) == diffID then
                    db.obtained[key] = nil
                end
            end
        end
        for key, val in pairs(backup.raid) do
            db.obtained[key] = val
            restoredCount = restoredCount + 1
        end
    end

    return true, restoredCount
end

-- Returns the timestamps (Unix epoch) of the last M+ and raid backups,
-- or nil for each if that backup does not exist yet.
function Scan.GetBackupInfo()
    local db = _G[VCA.CHAR_DB_NAME]
    if not db or not db.obtainedBackup then
        return nil, nil
    end
    return db.obtainedBackup.mythicPlusTime, db.obtainedBackup.raidTime
end
