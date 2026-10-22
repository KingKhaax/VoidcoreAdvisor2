-- Tests of the saved-data layer (Core/Data.lua, the real file) and of the roll log.
-- Loaded by tests/run.lua, which provides test() and near().
local VCA2 = {
    CHAR_DB_NAME = "CharDB2",
    ContentType = {RAID = "RAID", MYTHIC_PLUS = "MYTHIC_PLUS"},
    Difficulty = {RAID_HEROIC = 15},
    SpecInfo = {GetPlayerClassID = function() return 1 end},
    LootPool = {GetItemsForSpec = function() return {1, 2, 3, 4} end}
}
_G.CharDB2 = {obtained = {}, selectedItems = {}, bonusRollLog = {}}
assert(loadfile("Core/Data.lua"))("addon", VCA2)
local Data = VCA2.Data

test("Data: mark and unmark an item", function()
    Data.SetObtained("RAID", 100, 15, 1, 7, true)
    assert(Data.IsObtained("RAID", 100, 15, 1, 7))
    assert(not Data.IsObtained("RAID", 100, 15, 2, 7))
    Data.SetObtained("RAID", 100, 15, 1, 7, false)
    assert(not Data.IsObtained("RAID", 100, 15, 1, 7))
end)
test("Data: key tiers (M+) count tier-less marks for both tiers", function()
    Data.SetObtainedForKeyTier("MYTHIC_PLUS", 5, 23, 1, 9, nil, true)
    assert(Data.IsObtainedForKeyTier("MYTHIC_PLUS", 5, 23, 1, 9, true))
    assert(Data.IsObtainedForKeyTier("MYTHIC_PLUS", 5, 23, 1, 9, false))
    Data.SetObtained("MYTHIC_PLUS", 5, 23, 1, 9, false)
    Data.SetObtainedForKeyTier("MYTHIC_PLUS", 5, 23, 1, 9, true, true)
    assert(Data.IsObtainedForKeyTier("MYTHIC_PLUS", 5, 23, 1, 9, true))
    assert(not Data.IsObtainedForKeyTier("MYTHIC_PLUS", 5, 23, 1, 9, false))
    Data.ClearSourceForKeyTier("MYTHIC_PLUS", 5, 23, nil, true)
    assert(not Data.IsObtainedForKeyTier("MYTHIC_PLUS", 5, 23, 1, 9, true))
end)
test("Data: ClearSource only clears the given source and spec", function()
    Data.SetObtained("RAID", 100, 15, 1, 1, true)
    Data.SetObtained("RAID", 100, 15, 2, 1, true)
    Data.SetObtained("RAID", 101, 15, 1, 1, true)
    Data.ClearSource("RAID", 100, 15, 1)
    assert(not Data.IsObtained("RAID", 100, 15, 1, 1))
    assert(Data.IsObtained("RAID", 100, 15, 2, 1))
    assert(Data.IsObtained("RAID", 101, 15, 1, 1))
    Data.ClearSource("RAID", 100, 15)
    Data.ClearSource("RAID", 101, 15)
    assert(Data.GetTotalObtainedCount() == 0)
end)
test("Data: chosen items are saved as a copy and can be removed one by one", function()
    local set = {[3] = true, [4] = true}
    Data.SaveSelectedItems("RAID", 100, 15, set)
    set[3] = nil
    assert(Data.GetSelectedItems("RAID", 100, 15)[3] == true, "stored copy")
    Data.RemoveSelectedItem("RAID", 100, 15, 3)
    assert(Data.GetSelectedItems("RAID", 100, 15)[3] == nil)
    Data.RemoveSelectedItem("RAID", 100, 15, 4)
    assert(next(Data.GetSelectedItems("RAID", 100, 15)) == nil)
end)
test("Data: the roll log keeps the last 200 entries", function()
    _G.time = os.time
    for i = 1, 205 do
        Data.LogBonusRoll(i, nil, 1, nil)
    end
    local log = Data.GetBonusRollLog()
    assert(#log == 200 and log[1].itemID == 6 and log[200].itemID == 205)
    for i = #log, 1, -1 do
        log[i] = nil
    end
end)
test("Data: a roll stores whether it was a chosen item and the odds it had", function()
    Data.SaveSelectedItems("RAID", 100, 15, {[1] = true})
    Data.SetObtained("RAID", 100, 15, 1, 2, true) -- one of 4 already obtained: pool of 3
    Data.LogBonusRoll(1, nil, 1, {sourceType = "RAID", sourceID = 100, difficultyID = 15})
    local e = Data.GetBonusRollLog()[1]
    assert(e.wanted == true, "wanted")
    assert(near(e.odds, 1 / 3), "odds " .. tostring(e.odds))
    Data.LogBonusRoll(3, nil, 1, {sourceType = "RAID", sourceID = 100, difficultyID = 15})
    assert(Data.GetBonusRollLog()[2].wanted == false)
end)
