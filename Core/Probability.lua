-- VoidcoreAdvisor: Probability
-- Calculates Nebulous Voidcore drop probability for each player spec.
--
-- How probability works:
--   The Voidcore grants one RANDOM item from the pool that matches your loot
--   spec.  Once an item is received it is removed from the pool for that
--   difficulty.  Therefore:
--
--     odds of any specific desired item  =  1 / remaining_pool_size
--
--   A smaller pool is better when you are chasing a specific piece.
--
-- This module exposes two numbers per spec:
--   baseOdds      – 1 / total items for this spec (no accounting for obtained)
--   remainingOdds – 1 / items NOT yet obtained (the live, actionable number)
local _, VCA = ...

VCA.Probability = {}
local Probability = VCA.Probability

-- ── Per-spec calculation ──────────────────────────────────────────────────────

-- Calculates probability data for one spec against one source.
--
-- sourceType   : VCA.ContentType constant
-- sourceID     : encounterID (RAID) or instanceID (MYTHIC_PLUS)
-- difficultyID : EJ difficulty ID
-- classID      : numeric class ID
-- specID       : numeric specialization ID
--
-- Returns:
--   {
--     specID         : number
--     baseCount      : number  – total items available to this spec
--     remainingCount : number  – items not yet obtained
--     baseOdds       : number  – 1/baseCount       (0 if no items)
--     remainingOdds  : number  – 1/remainingCount  (0 if all obtained)
--     allObtained    : bool    – true when every item has been claimed
--     noItems        : bool    – true when this spec has no eligible items
--   }
-- isHighTier: nil = no tier filter (use plain obtained), true = key >= 10, false = key < 10
function Probability.CalculateForSpec(sourceType, sourceID, difficultyID, classID, specID, isHighTier, selectedSet)
    local itemIDs = VCA.LootPool.GetItemsForSpec(sourceType, sourceID, difficultyID, classID, specID)

    if selectedSet then
        -- Build the wanted subset, but keep the full pool for the odds denominator.
        -- remainingOdds = wanted_remaining / total_remaining
        -- (the true probability of rolling any wanted item from the full live pool)
        local wantedIDs = {}
        for _, itemID in ipairs(itemIDs) do
            if selectedSet[itemID] then
                wantedIDs[#wantedIDs + 1] = itemID
            end
        end
        local baseCount = #wantedIDs

        local totalRemaining = 0
        for _, itemID in ipairs(itemIDs) do
            if not VCA.Data.IsObtainedForKeyTier(sourceType, sourceID, difficultyID, specID, itemID, isHighTier) then
                totalRemaining = totalRemaining + 1
            end
        end

        local wantedRemaining = 0
        for _, itemID in ipairs(wantedIDs) do
            if not VCA.Data.IsObtainedForKeyTier(sourceType, sourceID, difficultyID, specID, itemID, isHighTier) then
                wantedRemaining = wantedRemaining + 1
            end
        end

        return {
            specID = specID,
            baseCount = baseCount,
            remainingCount = wantedRemaining,
            baseOdds = #itemIDs > 0 and (baseCount / #itemIDs) or 0,
            remainingOdds = totalRemaining > 0 and (wantedRemaining / totalRemaining) or 0,
            allObtained = baseCount > 0 and wantedRemaining == 0,
            noItems = baseCount == 0
        }
    end

    local baseCount = #itemIDs
    local remainingCount = 0
    for _, itemID in ipairs(itemIDs) do
        if not VCA.Data.IsObtainedForKeyTier(sourceType, sourceID, difficultyID, specID, itemID, isHighTier) then
            remainingCount = remainingCount + 1
        end
    end

    return {
        specID = specID,
        baseCount = baseCount,
        remainingCount = remainingCount,
        baseOdds = baseCount > 0 and (1 / baseCount) or 0,
        remainingOdds = remainingCount > 0 and (1 / remainingCount) or 0,
        allObtained = baseCount > 0 and remainingCount == 0,
        noItems = baseCount == 0
    }
end

-- ── Ranking ───────────────────────────────────────────────────────────────────

-- Ranks a list of specs by probability (best first = smallest remaining pool).
--
-- Sort order:
--   1. Specs with remaining items come before fully-obtained specs.
--   2. Among specs with remaining items: smaller remainingCount is better.
--   3. Tiebreak: smaller baseCount, then specID for stability.
--   4. Specs with NO eligible items (noItems) are always last.
--
-- specs        : array from VCA.SpecInfo.GetPlayerSpecs()
-- sourceType, sourceID, difficultyID : source to evaluate
--
-- Returns: sorted array.  Each entry is the table from CalculateForSpec, plus:
--   { specName, specIcon, specRole, specIndex, rank }
-- isHighTier: nil = no tier filter, true = key >= 10, false = key < 10
function Probability.RankSpecs(specs, sourceType, sourceID, difficultyID, isHighTier)
    local results = {}
    for _, spec in ipairs(specs) do
        local data = Probability.CalculateForSpec(sourceType, sourceID, difficultyID, spec.classID, spec.specID,
            isHighTier)
        data.specName = spec.name
        data.specIcon = spec.icon
        data.specRole = spec.role
        data.specIndex = spec.specIndex
        results[#results + 1] = data
    end

    table.sort(results, function(a, b)
        -- Specs with no eligible items drop to the very bottom.
        if a.noItems ~= b.noItems then
            return not a.noItems
        end
        -- Fully-obtained specs come after those with items remaining.
        if a.allObtained ~= b.allObtained then
            return not a.allObtained
        end
        -- Smaller remaining pool = better odds = ranks higher.
        if a.remainingCount ~= b.remainingCount then
            return a.remainingCount < b.remainingCount
        end
        -- Tiebreak by base pool size then spec ID for a stable sort.
        if a.baseCount ~= b.baseCount then
            return a.baseCount < b.baseCount
        end
        return a.specID < b.specID
    end)

    for i, result in ipairs(results) do
        result.rank = i
    end

    return results
end

-- Convenience: rank all specs of the current player for a given source.
-- isHighTier: nil = no tier filter, true = key >= 10, false = key < 10
function Probability.RankCurrentPlayerSpecs(sourceType, sourceID, difficultyID, isHighTier)
    local specs = VCA.SpecInfo.GetPlayerSpecs()
    return Probability.RankSpecs(specs, sourceType, sourceID, difficultyID, isHighTier)
end

-- Marks which specs are usable for a choice of items.  A spec that can loot ALL the chosen
-- items is the ideal one; when no spec can (for example a tank weapon and a damage weapon
-- of the same class), the specs that cover the most chosen items are the usable ones, and
-- their odds are those of the items they do cover.  Specs covering fewer, or none, are
-- flagged noItems.  results need matchCount; selectedCount = number of chosen items.
function Probability.MarkCoverage(results, selectedCount)
    local maxMatch = 0
    for _, r in ipairs(results) do
        if r.matchCount > maxMatch then
            maxMatch = r.matchCount
        end
    end
    local needed = math.min(selectedCount, maxMatch)
    for _, r in ipairs(results) do
        r.noItems = r.matchCount < needed or (selectedCount > 0 and maxMatch == 0)
    end
end

-- Ranks the current player's specs by how many of the given itemIDs fall into
-- each spec's loot pool at the specified source/difficulty.
--
-- itemIDs     : array of itemID numbers to filter by
-- Returns the same table shape as RankSpecs, but baseCount / remainingCount
-- reflect only the supplied items (not the full pool).
-- Sort order: specs that cover MORE selected items rank first; within equals,
-- fewer remaining (smaller unobtained intersection) ranks higher.
-- isHighTier: nil = no tier filter, true = key >= 10, false = key < 10
function Probability.RankCurrentPlayerSpecsForItems(itemIDs, sourceType, sourceID, difficultyID, isHighTier)
    local specs = VCA.SpecInfo.GetPlayerSpecs()

    local selectedSet = {}
    for _, id in ipairs(itemIDs) do
        selectedSet[id] = true
    end
    local usePriorities = VCA.Planner and VCA.Planner.HasPriorities()

    local results = {}
    for _, spec in ipairs(specs) do
        local allSpecItemIDs = VCA.LootPool.GetItemsForSpec(sourceType, sourceID, difficultyID, spec.classID,
            spec.specID)

        -- Check if this spec can see any of the selected items.
        local matchCount = 0
        for _, itemID in ipairs(allSpecItemIDs) do
            if selectedSet[itemID] then
                matchCount = matchCount + 1
            end
        end

        -- Full-pool counts drive the probability: the Voidcore rolls from the
        -- entire loot table for this spec, so a smaller remaining pool means a
        -- higher chance that any specific item (including the selected one) drops.
        local baseCount = #allSpecItemIDs
        local remainingCount = 0
        local matchRemainingCount = 0
        for _, itemID in ipairs(allSpecItemIDs) do
            if not VCA.Data.IsObtainedForKeyTier(sourceType, sourceID, difficultyID, spec.specID, itemID, isHighTier) then
                remainingCount = remainingCount + 1
                if selectedSet[itemID] then
                    matchRemainingCount = matchRemainingCount + 1
                end
            end
        end

        local selectedCount = #itemIDs
        -- Priorities (/void prio): remaining chosen items count by their weight.
        local weightedRemaining = 0
        if usePriorities then
            for _, itemID in ipairs(allSpecItemIDs) do
                if selectedSet[itemID] and
                    not VCA.Data.IsObtainedForKeyTier(sourceType, sourceID, difficultyID, spec.specID, itemID,
                        isHighTier) then
                    weightedRemaining = weightedRemaining + VCA.Planner.Weight(itemID)
                end
            end
        end
        results[#results + 1] = {
            weightedOdds = usePriorities and remainingCount > 0 and (weightedRemaining / remainingCount) or nil,
            specID = spec.specID,
            specName = spec.name,
            specIcon = spec.icon,
            specRole = spec.role,
            specIndex = spec.specIndex,
            baseCount = baseCount,
            remainingCount = remainingCount,
            matchCount = matchCount,
            matchRemainingCount = matchRemainingCount,
            baseOdds = baseCount > 0 and (1 / baseCount) or 0,
            remainingOdds = remainingCount > 0 and (1 / remainingCount) or 0,
            selectedOdds = remainingCount > 0 and (matchRemainingCount / remainingCount) or 0,
            allObtained = baseCount > 0 and remainingCount == 0,
            noItems = false -- set below by MarkCoverage
        }
    end
    Probability.MarkCoverage(results, #itemIDs)

    table.sort(results, function(a, b)
        if a.noItems ~= b.noItems then
            return not a.noItems
        end
        if a.allObtained ~= b.allObtained then
            return not a.allObtained
        end
        -- With priorities, the spec that favors your best-in-slot items comes first.
        if usePriorities and a.weightedOdds ~= b.weightedOdds then
            return (a.weightedOdds or 0) > (b.weightedOdds or 0)
        end
        -- Smaller remaining pool = higher drop chance = ranks higher.
        if a.remainingCount ~= b.remainingCount then
            return a.remainingCount < b.remainingCount
        end
        if a.baseCount ~= b.baseCount then
            return a.baseCount < b.baseCount
        end
        return a.specID < b.specID
    end)

    for i, r in ipairs(results) do
        r.rank = i
    end
    return results
end

-- ── Voidcore cost helper ──────────────────────────────────────────────────────

-- Returns the number of Nebulous Voidcores required for one roll at sourceType.
function Probability.GetVoidcoreCost(sourceType)
    if sourceType == VCA.ContentType.RAID then
        return VCA.VoidcoreCost.RAID
    end
    return VCA.VoidcoreCost.MYTHIC_PLUS
end
