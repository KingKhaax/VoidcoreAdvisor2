-- VoidcoreAdvisor: Init
-- Bootstrap: SavedVariables initialisation, login event handling, and
-- the public slash-command interface.  Loaded last so every other module
-- is available when this code runs.
local addonName, VCA = ...
local L = VCA.L

-- ── SavedVariables defaults ───────────────────────────────────────────────────

local function GetDefaults()
    return {
        schemaVersion = VCA.SCHEMA_VERSION,
        seasonFingerprint = nil,
        obtained = {},
        selectedItems = {}, -- { ["TYPE:sourceID:diffID"] = { [itemID]=true, ... } }
        bonusRollLog = {}, -- raw BONUS_ROLL_RESULT entries for manual verification
        minimized = false,
        overviewMinimized = false
    }
end

local function GetGlobalDefaults()
    return {
        reminderEnabled = true,
        bonusRollConfirmEnabled = true,
        brcSpecListEnabled = true,
        brcConfirmEnabled = true,
        brcDefaultOnV2 = true
    }
end

-- Apply any future schema migrations here.
local function MigrateDB(db)
    if db.schemaVersion == VCA.SCHEMA_VERSION then
        return
    end
    if (db.schemaVersion or 1) < 2 then
        -- v1→v2: insert specID=0 segment into obtained keys that lack it.
        VCA.Data.MigrateV1Keys(db)
    end
    db.schemaVersion = VCA.SCHEMA_VERSION
end

local function InitDB()
    -- Account-wide settings DB
    if type(_G[VCA.GLOBAL_DB_NAME]) ~= "table" then
        _G[VCA.GLOBAL_DB_NAME] = GetGlobalDefaults()
    else
        local gdb = _G[VCA.GLOBAL_DB_NAME]
        if gdb.reminderEnabled == nil then
            gdb.reminderEnabled = true
        end
        if gdb.bonusRollConfirmEnabled == nil then
            gdb.bonusRollConfirmEnabled = true
        end
        -- 2.0 turns the roll confirmation window on by default; apply it once
        -- to saves created while it was off by default.
        if gdb.brcConfirmEnabled == nil then
            gdb.brcConfirmEnabled = true
        end
        if not gdb.brcDefaultOnV2 then
            gdb.brcDefaultOnV2 = true
            gdb.bonusRollConfirmEnabled = true
        end
        if gdb.brcSpecListEnabled == nil then
            gdb.brcSpecListEnabled = true
        end
    end

    -- Per-character DB
    if type(_G[VCA.CHAR_DB_NAME]) ~= "table" then
        _G[VCA.CHAR_DB_NAME] = GetDefaults()
    else
        MigrateDB(_G[VCA.CHAR_DB_NAME])
        -- Ensure required top-level keys are present (handles sparse old saves).
        _G[VCA.CHAR_DB_NAME].obtained = _G[VCA.CHAR_DB_NAME].obtained or {}
        _G[VCA.CHAR_DB_NAME].selectedItems = _G[VCA.CHAR_DB_NAME].selectedItems or {}
        _G[VCA.CHAR_DB_NAME].bonusRollLog = _G[VCA.CHAR_DB_NAME].bonusRollLog or {}
        -- seasonFingerprint may be absent in saves from older versions; nil is fine.
        if _G[VCA.CHAR_DB_NAME].minimized == nil then
            _G[VCA.CHAR_DB_NAME].minimized = false
        end
        if _G[VCA.CHAR_DB_NAME].overviewMinimized == nil then
            _G[VCA.CHAR_DB_NAME].overviewMinimized = false
        end
    end
end

-- ── Bootstrap event handler ───────────────────────────────────────────────────

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

local function IsSafeWarmupContext()
    local inInstance = IsInInstance()
    return inInstance ~= true
end

local _deferredWarmAttempts = 0
local _maxDeferredWarmAttempts = 8

local function StartDeferredWarmup()
    if not IsSafeWarmupContext() then
        return
    end

    VCA.LootPool.WarmCache()
end

local function ScheduleDeferredWarmup(delay)
    C_Timer.After(delay, function()
        if IsSafeWarmupContext() then
            StartDeferredWarmup()
            return
        end

        _deferredWarmAttempts = _deferredWarmAttempts + 1
        if _deferredWarmAttempts < _maxDeferredWarmAttempts then
            -- Keep retrying gently so we eventually warm after leaving instances.
            ScheduleDeferredWarmup(5)
        end
    end)
end

-- Guard so zone transitions after the first world-enter do not re-run startup
-- season validation.
local _hasInitializedWorld = false

initFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        if (...) ~= addonName then
            return
        end
        InitDB()
        self:UnregisterEvent("ADDON_LOADED")
        if C_AddOns and C_AddOns.IsAddOnLoaded and C_AddOns.IsAddOnLoaded("VoidcoreAdvisor") then
            print("|cff9370DBVoidcoreAdvisor 2.0:|r |cffff4444" .. L["ORIGINAL_ADDON_LOADED"] .. "|r")
        end

    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Run only once per session. BuildSeasonFilter is called immediately
        -- (works inside instances); WarmCache is deferred until outside instances.
        if _hasInitializedWorld then
            return
        end
        _hasInitializedWorld = true

        -- Always build the season filter immediately so the Reminder and other
        -- features work even when logging in directly inside an instance.
        VCA.LootPool.BuildSeasonFilter()

        -- Clear per-character data when the season has changed.
        local newFingerprint = VCA.LootPool.GetSeasonFingerprint()
        if newFingerprint then
            local db = _G[VCA.CHAR_DB_NAME]
            if db.seasonFingerprint ~= newFingerprint then
                db.obtained = {}
                db.selectedItems = {}
                db.seasonFingerprint = newFingerprint
                print("|cff9370DBVoidcoreAdvisor 2.0:|r " .. L["NEW_SEASON_RESET"])
            end
        end

        -- Defer the heavy item-cache warmup until outside an instance.
        ScheduleDeferredWarmup(4)

        -- Notify any future UI layer that the backend is ready.
        if VCA.OnBackendReady then
            VCA.OnBackendReady()
        end
    end
end)

-- ── Public API ────────────────────────────────────────────────────────────────

-- Wipe all obtained item data for this character (exposed to slash command
-- and the UI "Reset" button when it is built).
function VCA.ResetObtainedData()
    _G[VCA.CHAR_DB_NAME] = GetDefaults()
end

-- ── Slash commands ────────────────────────────────────────────────────────────

SLASH_VOIDCOREADVISOR1 = "/void"
SLASH_VOIDCOREADVISOR2 = "/voidcoreadvisor2"

SlashCmdList["VOIDCOREADVISOR"] = function(msg)
    local cmd = (msg:match("^%s*(%S+)") or ""):lower()

    if cmd == "reset" then
        VCA.ResetObtainedData()
        print("|cff9370DBVoidcoreAdvisor 2.0:|r " .. L["RESET_CONFIRM"])

    elseif cmd == "count" then
        local count = VCA.Data.GetTotalObtainedCount()
        print("|cff9370DBVoidcoreAdvisor 2.0:|r " .. string.format(L["COUNT_FORMAT"], count))

    elseif cmd == "spec" then
        -- Debug: print which spec will be used for loot.
        local specID = VCA.SpecInfo.GetEffectiveLootSpecID()
        local rawID = VCA.SpecInfo.GetRawLootSpecID()
        local suffix = rawID == 0 and L["FOLLOWS_ACTIVE_SPEC"] or ""
        print("|cff9370DBVoidcoreAdvisor 2.0:|r " .. string.format(L["SPEC_FORMAT"], specID or "unknown", suffix))

    elseif cmd == "source" then
        -- Debug: print the currently active detection source.
        local src = VCA.Detection.GetActiveSource()
        if src then
            print("|cff9370DBVoidcoreAdvisor 2.0:|r " ..
                      string.format(L["SOURCE_FORMAT"], src.sourceType, src.sourceID, src.difficultyID))
        else
            print("|cff9370DBVoidcoreAdvisor 2.0:|r " .. L["NO_ACTIVE_SOURCE"])
        end

    elseif cmd == "rolls" then
        -- Print raw bonus roll event log for manual verification.
        local log = VCA.Data.GetBonusRollLog()
        if #log == 0 then
            print("|cff9370DBVoidcoreAdvisor 2.0:|r No bonus roll events recorded.")
        else
            print("|cff9370DBVoidcoreAdvisor 2.0:|r Bonus roll log (" .. #log .. " entries, oldest first):")
            for i, entry in ipairs(log) do
                local ts = date("%Y-%m-%d %H:%M:%S", entry.timestamp)
                local src = "unknown source"
                if entry.sourceType and entry.sourceID and entry.difficultyID then
                    src = entry.sourceType .. ":" .. entry.sourceID .. " diff=" .. entry.difficultyID
                    if entry.keyLevel then
                        src = src .. " key=" .. entry.keyLevel
                    end
                end
                if entry.manual then
                    src = src .. " [manual]"
                end
                local spec = entry.specID and ("spec=" .. entry.specID) or "spec=?"
                print(string.format("  [%d] %s  %s  %s  %s", i, ts,
                    entry.itemLink or ("itemID=" .. tostring(entry.itemID)), spec, src))
            end
        end

    elseif cmd == "version" then
        print("|cff9370DBVoidcoreAdvisor 2.0:|r " .. string.format(L["VERSION_FORMAT"], VCA.VERSION))

    elseif cmd == "replaylog" then
        VCA.Detection.ReplayBonusRollLog(true)
        -- Refresh the panel so newly-marked items are immediately hidden.
        if VCA.Panel and VCA.Panel.Refresh then
            VCA.Panel.Refresh()
        end

    elseif cmd == "restore" then
        local mpTime, raidTime = VCA.VoidcacheScan.GetBackupInfo()
        if not mpTime and not raidTime then
            print("|cff9370DBVoidcoreAdvisor 2.0:|r " .. L["RESTORE_NO_BACKUP"])
        else
            local ok, result = VCA.VoidcacheScan.RestoreBackup()
            if ok then
                print("|cff9370DBVoidcoreAdvisor 2.0:|r " .. string.format(L["RESTORE_COMPLETE"], result))
                if VCA.DungeonOverview and VCA.DungeonOverview.Refresh then
                    VCA.DungeonOverview.Refresh()
                end
                if VCA.RaidOverview and VCA.RaidOverview.Refresh then
                    VCA.RaidOverview.Refresh()
                end
                if VCA.Panel and VCA.Panel.Refresh then
                    VCA.Panel.Refresh()
                end
            else
                print("|cff9370DBVoidcoreAdvisor 2.0:|r " .. L["RESTORE_FAILED"])
            end
        end

    elseif cmd == "reminder" then
        -- Force-evaluate the reminder, ignoring the already-shown guard.
        VCA.Reminder.ForceEvaluate()

    elseif cmd == "liveraid" then
        VCA.LiveRaid.Run(true)

    else
        print("|cff9370DBVoidcoreAdvisor 2.0:|r " .. L["HELP_HEADER"])
        print(L["HELP_RESET"])
        print(L["HELP_COUNT"])
        print(L["HELP_SPEC"])
        print(L["HELP_SOURCE"])
        print(L["HELP_VERSION"])
        print(L["HELP_REPLAYLOG"])
        print(L["HELP_RESTORE"])
    end
end
