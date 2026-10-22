-- VoidcoreAdvisor Reborn: Tools
-- Text reports and helpers behind /void cores, next, history, chars, debug, prio, wish
-- and select. Each one opens the Report window so the text can be read and copied.
local _, VCA = ...
local L = VCA.L

local Tools = {}
VCA.Tools = Tools

local function Say(text)
    print(VCA.Theme.title .. "VoidcoreAdvisor Reborn:|r " .. text)
end

local DIFF_NAMES = {[14] = "Normal", [15] = "Heroic", [16] = "Mythic"}

local function ItemText(itemID, link)
    if link and link ~= "" then
        return link
    end
    return C_Item.GetItemNameByID(itemID) or ("item " .. tostring(itemID))
end

local function SourceName(sourceType, sourceID)
    if not sourceID then
        return "?"
    end
    if sourceType == VCA.ContentType.RAID then
        return (EJ_GetEncounterInfo(sourceID)) or tostring(sourceID)
    end
    return (EJ_GetInstanceInfo and EJ_GetInstanceInfo(sourceID)) or tostring(sourceID)
end

-- ── /void cores ───────────────────────────────────────────────────────────────

function Tools.Cores(difficulty)
    difficulty = tonumber(difficulty) or VCA.Difficulty.RAID_HEROIC
    local Planner = VCA.Planner
    local owned = Planner.OwnedCores()
    local rolls, spent = Planner.SpentThisWeek()
    local places = Planner.NextBest(difficulty)

    local raidCores, dungeonCores, raidItems, dungeonItems = 0, 0, 0, 0
    for _, p in ipairs(places) do
        local need = Planner.ExpectedRollsForAll(p.pool, p.remaining)
        if p.kind == "RAID" then
            raidCores = raidCores + need * VCA.VoidcoreCost.RAID
            raidItems = raidItems + p.remaining
        else
            dungeonCores = dungeonCores + need * VCA.VoidcoreCost.MYTHIC_PLUS
            dungeonItems = dungeonItems + p.remaining
        end
    end

    local lines = {
        string.format(L["TOOLS_CORES_OWNED"], owned),
        string.format(L["TOOLS_CORES_SPENT"], spent, rolls),
        ""
    }
    if #places == 0 then
        lines[#lines + 1] = L["TOOLS_NO_SELECTION"]
    else
        lines[#lines + 1] = string.format(L["TOOLS_CORES_NEED_RAID"], DIFF_NAMES[difficulty] or difficulty, raidItems,
            math.ceil(raidCores))
        lines[#lines + 1] = string.format(L["TOOLS_CORES_NEED_DUNGEON"], dungeonItems, math.ceil(dungeonCores))
        lines[#lines + 1] = ""
        local need = math.ceil(raidCores + dungeonCores)
        if need > owned then
            lines[#lines + 1] = string.format(L["TOOLS_CORES_SHORT"], need - owned)
        else
            lines[#lines + 1] = L["TOOLS_CORES_ENOUGH"]
        end
        lines[#lines + 1] = L["TOOLS_CORES_NOTE"]
    end
    VCA.Report.Show(L["TOOLS_CORES_TITLE"], table.concat(lines, "\n"),
        {footer = L["TOOLS_CORES_USAGE"]})
end

-- ── /void next ────────────────────────────────────────────────────────────────

function Tools.Next(difficulty)
    difficulty = tonumber(difficulty) or VCA.Difficulty.RAID_HEROIC
    local places = VCA.Planner.NextBest(difficulty)
    local lines = {string.format(L["TOOLS_NEXT_HEADER"], DIFF_NAMES[difficulty] or difficulty), ""}
    if #places == 0 then
        lines[#lines + 1] = L["TOOLS_NO_SELECTION"]
    end
    for i, p in ipairs(places) do
        local tag = ""
        if p.note == "KILLED" then
            tag = "  " .. L["TOOLS_NEXT_KILLED"]
        elseif p.note == "KEY" then
            tag = "  " .. L["TOOLS_NEXT_KEY"]
        end
        local kind = p.kind == "RAID" and L["CONTENT_RAID_BOSS"] or L["CONTENT_MP_DUNGEON"]
        lines[#lines + 1] = string.format("%d. %s (%s) - %.0f%%  %s%s", i, p.name, kind, p.odds * 100,
            p.spec or "", tag)
        if i >= 25 then
            break
        end
    end
    VCA.Report.Show(L["TOOLS_NEXT_TITLE"], table.concat(lines, "\n"), {footer = L["TOOLS_NEXT_USAGE"]})
end

-- ── /void history ─────────────────────────────────────────────────────────────

function Tools.History()
    local log = VCA.Data.GetBonusRollLog() or {}
    local rolls, wanted, manual = 0, 0, 0
    local bySource = {}
    for _, e in ipairs(log) do
        if e.manual then
            manual = manual + 1
        else
            rolls = rolls + 1
            if e.wanted then
                wanted = wanted + 1
            end
            local name = SourceName(e.sourceType, e.sourceID)
            bySource[name] = (bySource[name] or 0) + 1
        end
    end
    local lines = {string.format(L["TOOLS_HISTORY_TOTAL"], rolls, manual)}
    if rolls > 0 then
        lines[#lines + 1] = string.format(L["TOOLS_HISTORY_LUCK"], wanted, rolls, wanted * 100 / rolls)
        local topName, topCount
        for name, count in pairs(bySource) do
            if not topCount or count > topCount then
                topName, topCount = name, count
            end
        end
        lines[#lines + 1] = string.format(L["TOOLS_HISTORY_TOP"], topName, topCount)
    end
    lines[#lines + 1] = ""
    local shown = 0
    for i = #log, 1, -1 do
        local e = log[i]
        shown = shown + 1
        if shown > 25 then
            break
        end
        lines[#lines + 1] = string.format("%s  %s  -  %s%s", date("%Y/%m/%d %H:%M", e.timestamp or 0),
            ItemText(e.itemID, e.itemLink), SourceName(e.sourceType, e.sourceID),
            e.manual and ("  " .. L["TOOLS_HISTORY_MANUAL"]) or (e.wanted and ("  " .. L["TOOLS_HISTORY_WANTED"]) or ""))
    end
    if #log == 0 then
        lines[#lines + 1] = L["TOOLS_HISTORY_EMPTY"]
    end
    VCA.Report.Show(L["TOOLS_HISTORY_TITLE"], table.concat(lines, "\n"), {footer = L["TOOLS_HISTORY_NOTE"]})
end

-- ── /void chars ───────────────────────────────────────────────────────────────

function Tools.Chars()
    local gdb = _G[VCA.GLOBAL_DB_NAME]
    local names = {}
    for name in pairs(gdb and gdb.characters or {}) do
        names[#names + 1] = name
    end
    table.sort(names)
    local lines = {}
    for _, name in ipairs(names) do
        local c = gdb.characters[name]
        local heroic = c.raid and c.raid[15] or {}
        local mythic = c.raid and c.raid[16] or {}
        lines[#lines + 1] = string.format(L["TOOLS_CHARS_LINE"], name, c.class or "?", c.cores or 0,
            heroic.remaining or 0, heroic.chosen or 0, mythic.remaining or 0, mythic.chosen or 0,
            date("%Y/%m/%d", c.updated or 0))
    end
    if #lines == 0 then
        lines[1] = L["TOOLS_CHARS_EMPTY"]
    end
    VCA.Report.Show(L["TOOLS_CHARS_TITLE"], table.concat(lines, "\n"), {footer = L["TOOLS_CHARS_NOTE"]})
end

-- ── /void debug ───────────────────────────────────────────────────────────────

VCA.DebugLog = VCA.DebugLog or {}

function VCA.LogDebug(text)
    local log = VCA.DebugLog
    log[#log + 1] = date("%H:%M:%S ") .. tostring(text)
    while #log > 30 do
        table.remove(log, 1)
    end
end

local function Count(t)
    local n = 0
    for _ in pairs(t or {}) do
        n = n + 1
    end
    return n
end

function Tools.Debug()
    local gdb = _G[VCA.GLOBAL_DB_NAME] or {}
    local cdb = _G[VCA.CHAR_DB_NAME] or {}
    local version, build, _, toc = GetBuildInfo()
    local specID = VCA.SpecInfo and VCA.SpecInfo.GetEffectiveLootSpecID and VCA.SpecInfo.GetEffectiveLootSpecID()
    local lines = {
        "VoidcoreAdvisor Reborn " .. tostring(VCA.VERSION),
        string.format("WoW %s (%s) interface %s, client language %s", version or "?", build or "?", toc or "?",
            GetLocale()),
        string.format("Class %s, loot spec %s", select(2, UnitClass("player")) or "?", tostring(specID)),
        string.format("Themes: window=%s roll=%s reminder=%s", tostring(gdb.theme), tostring(gdb.rollTheme),
            tostring(gdb.reminderTheme)),
        string.format("Season data: %d raid bosses, %d dungeons, %d extra raids saved", Count(VCA.SeasonData and
            VCA.SeasonData.raids), #(VCA.SeasonData and VCA.SeasonData.dungeonInstanceIDs or {}), Count(gdb.liveRaids)),
        string.format("Saved: %d obtained marks, %d selections, %d roll log entries", Count(cdb.obtained),
            Count(cdb.selectedItems), #(cdb.bonusRollLog or {})),
        string.format("Original VoidcoreAdvisor loaded: %s", tostring(C_AddOns and C_AddOns.IsAddOnLoaded and
            C_AddOns.IsAddOnLoaded("VoidcoreAdvisor") or false)),
        "",
        "Recent messages:"
    }
    if #VCA.DebugLog == 0 then
        lines[#lines + 1] = "(none)"
    end
    for _, text in ipairs(VCA.DebugLog) do
        lines[#lines + 1] = text
    end
    VCA.Report.Show(L["TOOLS_DEBUG_TITLE"], table.concat(lines, "\n"), {footer = L["TOOLS_DEBUG_NOTE"]})
end

-- ── /void prio ────────────────────────────────────────────────────────────────

local PRIORITY_WORDS = {bis = 1, alt = 2}

local function ItemIDFromText(text)
    return tonumber((text or ""):match("item:(%d+)")) or tonumber((text or ""):match("(%d%d%d%d%d+)"))
end

function Tools.Priority(msg)
    local itemID = ItemIDFromText(msg)
    local word = (msg or ""):lower():match("%f[%a](bis)%f[%A]") or (msg or ""):lower():match("%f[%a](alt)%f[%A]") or
                     ((msg or ""):lower():match("%f[%a]clear%f[%A]") and "clear")
    if itemID and word then
        VCA.Planner.SetPriority(itemID, PRIORITY_WORDS[word])
        Say(string.format(L["TOOLS_PRIO_SET"], ItemText(itemID), word == "clear" and L["TOOLS_PRIO_NONE"] or
            (word == "bis" and "BiS" or "Alt")))
        if VCA.Panel and VCA.Panel.Refresh then
            VCA.Panel.Refresh()
        end
        return
    end
    local cdb = _G[VCA.CHAR_DB_NAME] or {}
    local ids = {}
    for id, p in pairs(cdb.priority or {}) do
        ids[#ids + 1] = id
    end
    table.sort(ids)
    local lines = {L["TOOLS_PRIO_HELP"], ""}
    for _, id in ipairs(ids) do
        lines[#lines + 1] = string.format("%s  -  %s", ItemText(id), cdb.priority[id] == 1 and "BiS" or "Alt")
    end
    if #ids == 0 then
        lines[#lines + 1] = L["TOOLS_PRIO_EMPTY"]
    end
    VCA.Report.Show(L["TOOLS_PRIO_TITLE"], table.concat(lines, "\n"))
end

-- ── /void wish (import a list of items) ───────────────────────────────────────

-- Every item ID found in the text: links ("item:123456"), "id=123456" and plain numbers.
function Tools.ParseItemIDs(text)
    local ids, seen = {}, {}
    local function add(n)
        n = tonumber(n)
        if n and n >= 10000 and n <= 9999999 and not seen[n] then
            seen[n] = true
            ids[#ids + 1] = n
        end
    end
    for n in (text or ""):gmatch("item:(%d+)") do
        add(n)
    end
    for n in (text or ""):gmatch("[Ii][Dd]=(%d+)") do
        add(n)
    end
    for n in (text or ""):gmatch("%f[%d](%d%d%d%d%d%d?%d?)%f[%D]") do
        add(n)
    end
    return ids
end

-- Chooses every given item wherever it drops (raid bosses on Normal/Heroic/Mythic and the
-- season dungeons). Returns how many (item, source) pairs were added.
function Tools.SelectItems(ids)
    local wanted = {}
    for _, id in ipairs(ids) do
        wanted[id] = true
    end
    local added = 0
    local function choose(sourceType, sourceID, diff, itemID)
        local set = VCA.Data.GetSelectedItems(sourceType, sourceID, diff)
        if not set[itemID] then
            set[itemID] = true
            VCA.Data.SaveSelectedItems(sourceType, sourceID, diff, set)
            added = added + 1
        end
    end
    for encounterID, data in pairs(VCA.SeasonData and VCA.SeasonData.raids or {}) do
        for _, diff in ipairs({14, 15, 16}) do
            for _, itemID in ipairs(data[diff] or {}) do
                if wanted[itemID] then
                    choose(VCA.ContentType.RAID, encounterID, diff, itemID)
                end
            end
        end
    end
    for _, instanceID in ipairs(VCA.SeasonData and VCA.SeasonData.dungeonInstanceIDs or {}) do
        local data = VCA.SeasonData.dungeons and VCA.SeasonData.dungeons[instanceID]
        local found = {}
        for _, list in pairs(data and data.bySpec or {}) do
            for _, itemID in ipairs(list) do
                if wanted[itemID] then
                    found[itemID] = true
                end
            end
        end
        for itemID in pairs(found) do
            choose(VCA.ContentType.MYTHIC_PLUS, instanceID, VCA.MythicPlusEJDifficulty, itemID)
        end
    end
    if VCA.Panel and VCA.Panel.ReloadItemSelections then
        VCA.Panel.ReloadItemSelections()
        VCA.Panel.Refresh()
    end
    return added
end

function Tools.Wish()
    VCA.Report.Show(L["TOOLS_WISH_TITLE"], "", {
        editable = true,
        button = L["TOOLS_WISH_BUTTON"],
        footer = L["TOOLS_WISH_HINT"],
        onAction = function(text)
            local ids = Tools.ParseItemIDs(text)
            if #ids == 0 then
                Say(L["TOOLS_WISH_NONE"])
                return
            end
            Say(string.format(L["TOOLS_WISH_DONE"], #ids, Tools.SelectItems(ids)))
            VCA.Report.Hide()
        end
    })
end

-- ── /void select ──────────────────────────────────────────────────────────────

function Tools.SelectAll(clear)
    if not (VCA.Panel and VCA.Panel.SelectAllUseful) then
        return
    end
    local n = VCA.Panel.SelectAllUseful(clear)
    if n == nil then
        Say(L["TOOLS_SELECT_NO_SOURCE"])
    elseif clear then
        Say(L["TOOLS_SELECT_CLEARED"])
    else
        Say(string.format(L["TOOLS_SELECT_DONE"], n))
    end
end

-- ── Character summary ─────────────────────────────────────────────────────────

local logoutFrame = CreateFrame("Frame")
logoutFrame:RegisterEvent("PLAYER_LOGOUT")
logoutFrame:SetScript("OnEvent", function()
    pcall(VCA.Planner.SaveCharacterSummary)
end)
