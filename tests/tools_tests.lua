-- Tests of the item list parser behind /void wish.
local VCA3 = {
    L = setmetatable({}, {__index = function(_, k) return k end}),
    Theme = {title = "", bg = {0, 0, 0}, border = {0, 0, 0}},
    OnTheme = function() end,
    GLOBAL_DB_NAME = "G3",
    CHAR_DB_NAME = "C3",
    ContentType = {RAID = "RAID", MYTHIC_PLUS = "MYTHIC_PLUS"},
    VoidcoreCost = {RAID = 1, MYTHIC_PLUS = 1},
    Difficulty = {}
}
local function Dummy()
    local t
    t = setmetatable({}, {__index = function() return function() return t end end, __call = function() return t end})
    return t
end
_G.CreateFrame = function() return Dummy() end
_G.UIParent, _G.UISpecialFrames, _G.tinsert = Dummy(), {}, table.insert
_G.C_Item = setmetatable({}, {__index = function() return function() end end})
assert(loadfile("UI/Tools.lua"))("addon", VCA3)
local Tools = VCA3.Tools

test("Wish: item links, ids and plain numbers are all found", function()
    local ids = Tools.ParseItemIDs("|Hitem:280617::::|h[x]|h, 281029 id=281215 12 2026")
    assert(#ids == 3)
end)
test("Wish: duplicates are listed once", function()
    assert(#Tools.ParseItemIDs("280617 280617 item:280617") == 1)
end)
test("Wish: a minimum gain skips small upgrades", function()
    local text = "Crown of the Dark Envoy 280617 +2.4%\nNecklace 281029 +0.3%\nPlain line 281215"
    local all = Tools.ParseItemIDs(text)
    local good = Tools.ParseItemIDs(text, 1)
    assert(#all == 3, #all)
    assert(#good == 2 and good[1] == 280617 and good[2] == 281215, #good)
end)
test("Wish: the percentage is not read as an item id", function()
    local ids = Tools.ParseItemIDs("280617 +123456%")
    assert(#ids == 1 and ids[1] == 280617)
end)
test("Wish: empty text", function()
    assert(#Tools.ParseItemIDs("") == 0 and #Tools.ParseItemIDs(nil) == 0)
end)
