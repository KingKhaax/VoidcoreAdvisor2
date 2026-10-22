-- VoidcoreAdvisor Reborn: Planner
-- Helpers that answer "how many Voidcores do I need" and "where should I spend the next
-- one": cumulative odds, expected rolls, Voidcores spent this week, item priorities and a
-- ranked list of bosses and dungeons. The math is kept free of game calls so it can be
-- tested outside the game (tests/).
local _, VCA = ...

VCA.Planner = {}
local Planner = VCA.Planner

-- ── Math ──────────────────────────────────────────────────────────────────────

-- Chance to get at least one of `wanted` items in `rolls` rolls from a pool of `total`
-- items. Every roll takes one item out of the pool, so the chance grows faster than
-- 1-(1-p)^n: it is the exact "without replacement" value.
function Planner.AtLeastOne(total, wanted, rolls)
    if not total or not wanted or not rolls or total <= 0 or wanted <= 0 or rolls <= 0 then
        return 0
    end
    if wanted >= total or rolls > total - wanted then
        return 1
    end
    local none = 1
    for i = 0, rolls - 1 do
        none = none * ((total - wanted - i) / (total - i))
    end
    return 1 - none
end

-- Expected number of rolls until you have all `wanted` items of a pool of `total`.
function Planner.ExpectedRollsForAll(total, wanted)
    if not total or not wanted or total <= 0 or wanted <= 0 then
        return 0
    end
    wanted = math.min(wanted, total)
    return wanted * (total + 1) / (wanted + 1)
end

-- ── Priorities (wishlist) ─────────────────────────────────────────────────────

-- 1 = best in slot, 2 = alternative. Items without a priority count as best in slot.
local WEIGHTS = {[1] = 1.0, [2] = 0.5}
Planner.WEIGHTS = WEIGHTS

local function PriorityTable(create)
    local db = _G[VCA.CHAR_DB_NAME]
    if not db then
        return nil
    end
    if create then
        db.priority = db.priority or {}
    end
    return db.priority
end

function Planner.GetPriority(itemID)
    local t = PriorityTable(false)
    return t and t[itemID] or nil
end

function Planner.SetPriority(itemID, priority)
    local t = PriorityTable(true)
    if t then
        t[itemID] = priority
    end
end

function Planner.HasPriorities()
    local t = PriorityTable(false)
    return t ~= nil and next(t) ~= nil
end

function Planner.Weight(itemID)
    return WEIGHTS[Planner.GetPriority(itemID) or 1] or 1
end

-- ── Voidcores ─────────────────────────────────────────────────────────────────

function Planner.OwnedCores()
    local info = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo(VCA.VOIDCORE_CURRENCY_ID)
    return info and info.quantity or 0
end

-- Unix time of the last weekly reset.
function Planner.WeekStart()
    local untilReset = C_DateAndTime and C_DateAndTime.GetSecondsUntilWeeklyReset and
                           C_DateAndTime.GetSecondsUntilWeeklyReset()
    if not untilReset then
        return time() - 7 * 86400
    end
    return time() + untilReset - 7 * 86400
end

-- Rolls and Voidcores spent since the weekly reset, from the roll log. Manual marks are
-- not rolls and are skipped.
function Planner.SpentThisWeek()
    local since = Planner.WeekStart()
    local rolls, cores = 0, 0
    for _, entry in ipairs(VCA.Data.GetBonusRollLog() or {}) do
        if entry.timestamp and entry.timestamp >= since and not entry.manual then
            rolls = rolls + 1
            cores = cores + (entry.sourceType == VCA.ContentType.RAID and VCA.VoidcoreCost.RAID or
                        VCA.VoidcoreCost.MYTHIC_PLUS)
        end
    end
    return rolls, cores
end

-- ── Where to spend the next Voidcore ──────────────────────────────────────────

local function SortedList(set)
    local list = {}
    for id in pairs(set or {}) do
        list[#list + 1] = id
    end
    table.sort(list)
    return list
end

local function AverageWeight(list)
    if #list == 0 then
        return 1
    end
    local sum = 0
    for _, id in ipairs(list) do
        sum = sum + Planner.Weight(id)
    end
    return sum / #list
end

-- The best spec that can still roll every chosen item, or nil.
local function BestRanking(itemIDs, sourceType, sourceID, difficultyID)
    local rankings = VCA.Probability.RankCurrentPlayerSpecsForItems(itemIDs, sourceType, sourceID, difficultyID, nil)
    for _, r in ipairs(rankings) do
        if not r.noItems and not r.allObtained and r.remainingCount > 0 then
            return r
        end
    end
    return nil
end

-- Raid bosses already killed this week, by name: { [lowercase boss name] = true }.
local function KilledBosses(raidName, difficultyID)
    local killed = {}
    if not (GetNumSavedInstances and raidName) then
        return killed
    end
    for i = 1, GetNumSavedInstances() do
        local name, _, _, diff, locked, _, _, isRaid = GetSavedInstanceInfo(i)
        if isRaid and locked and name == raidName and diff == difficultyID and GetSavedInstanceEncounterInfo then
            local j = 1
            while true do
                local boss, _, isKilled = GetSavedInstanceEncounterInfo(i, j)
                if not boss then
                    break
                end
                if isKilled then
                    killed[boss:lower()] = true
                end
                j = j + 1
            end
        end
    end
    return killed
end

local function OwnedKeystoneName()
    if C_MythicPlus and C_MythicPlus.GetOwnedKeystoneChallengeMapID and C_ChallengeMode and
        C_ChallengeMode.GetMapUIInfo then
        local mapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
        if mapID then
            return (C_ChallengeMode.GetMapUIInfo(mapID))
        end
    end
    return nil
end

-- Ranked list of the places worth spending a Voidcore on, using the items you chose.
-- Each entry: { kind, name, odds, weight, score, spec, remaining, note }
--   odds  = chance that the roll gives one of your chosen items with the best spec
--   score = odds x the average priority weight of the chosen items
-- Raid bosses you already killed this week are listed last (score 0); the dungeon whose
-- keystone you carry gets a small bonus. Only places with chosen items are listed.
function Planner.NextBest(raidDifficulty)
    raidDifficulty = raidDifficulty or VCA.Difficulty.RAID_HEROIC
    local results = {}
    local killedCache = {}

    for encounterID in pairs(VCA.SeasonData and VCA.SeasonData.raids or {}) do
        local selected = SortedList(VCA.Data.GetSelectedItems(VCA.ContentType.RAID, encounterID, raidDifficulty))
        if #selected > 0 then
            local best = BestRanking(selected, VCA.ContentType.RAID, encounterID, raidDifficulty)
            if best then
                local name, _, _, _, _, journalInstanceID = EJ_GetEncounterInfo(encounterID)
                name = name or tostring(encounterID)
                local weight = AverageWeight(selected)
                local score, note = best.selectedOdds * weight, nil
                local raidName = journalInstanceID and EJ_GetInstanceInfo and (EJ_GetInstanceInfo(journalInstanceID))
                killedCache[raidName or ""] = killedCache[raidName or ""] or KilledBosses(raidName, raidDifficulty)
                if killedCache[raidName or ""][name:lower()] then
                    score, note = 0, "KILLED"
                end
                results[#results + 1] = {
                    kind = "RAID",
                    name = name,
                    odds = best.selectedOdds,
                    weight = weight,
                    score = score,
                    spec = best.specName,
                    remaining = best.matchRemainingCount,
                    pool = best.remainingCount,
                    note = note
                }
            end
        end
    end

    local keyName = OwnedKeystoneName()
    for _, instanceID in ipairs(VCA.SeasonData and VCA.SeasonData.dungeonInstanceIDs or {}) do
        local selected = SortedList(VCA.Data.GetSelectedItems(VCA.ContentType.MYTHIC_PLUS, instanceID,
            VCA.MythicPlusEJDifficulty))
        if #selected > 0 then
            local best = BestRanking(selected, VCA.ContentType.MYTHIC_PLUS, instanceID, VCA.MythicPlusEJDifficulty)
            if best then
                local name = EJ_GetInstanceInfo and (EJ_GetInstanceInfo(instanceID)) or tostring(instanceID)
                local weight = AverageWeight(selected)
                local score, note = best.selectedOdds * weight, nil
                if keyName and name == keyName then
                    score, note = score * 1.15, "KEY"
                end
                results[#results + 1] = {
                    kind = "DUNGEON",
                    name = name,
                    odds = best.selectedOdds,
                    weight = weight,
                    score = score,
                    spec = best.specName,
                    remaining = best.matchRemainingCount,
                    pool = best.remainingCount,
                    note = note
                }
            end
        end
    end

    table.sort(results, function(a, b)
        if a.score ~= b.score then
            return a.score > b.score
        end
        return a.name < b.name
    end)
    return results
end

-- ── Account summary (compare characters) ──────────────────────────────────────

-- Stores what this character still needs in the account-wide saved variables so
-- /void chars can list every character. Called when you log out.
function Planner.SaveCharacterSummary()
    local gdb = _G[VCA.GLOBAL_DB_NAME]
    if not gdb or not VCA.SeasonData then
        return
    end
    local specID = VCA.SpecInfo and VCA.SpecInfo.GetEffectiveLootSpecID and VCA.SpecInfo.GetEffectiveLootSpecID()
    local summary = {
        updated = time(),
        class = select(2, UnitClass("player")),
        cores = Planner.OwnedCores(),
        raid = {}
    }
    for _, diff in ipairs({VCA.Difficulty.RAID_HEROIC, VCA.Difficulty.RAID_MYTHIC}) do
        local chosen, remaining = 0, 0
        for encounterID in pairs(VCA.SeasonData.raids or {}) do
            for itemID in pairs(VCA.Data.GetSelectedItems(VCA.ContentType.RAID, encounterID, diff)) do
                chosen = chosen + 1
                if not (specID and
                    VCA.Data.IsObtainedForKeyTier(VCA.ContentType.RAID, encounterID, diff, specID, itemID, nil)) then
                    remaining = remaining + 1
                end
            end
        end
        summary.raid[diff] = {chosen = chosen, remaining = remaining}
    end
    gdb.characters = gdb.characters or {}
    gdb.characters[UnitName("player") .. "-" .. (GetRealmName() or "")] = summary
end
