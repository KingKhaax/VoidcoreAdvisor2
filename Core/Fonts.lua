-- VoidcoreAdvisor Reborn: Fonts
-- Every text of the addon uses one of the VCAFont* font objects below. Changing the font of
-- those objects changes the font of the addon and all its windows at once.
-- The choices are the fonts of the game, Source Sans 3 (shipped in the Fonts folder) and every
-- font other addons register with LibSharedMedia-3.0.
local addonName, VCA = ...

local Fonts = {}
VCA.Fonts = Fonts

local MEDIA = "Interface\\AddOns\\" .. addonName .. "\\Fonts\\"

-- The font objects the addon uses, the game font object each one copies, and whether it is a
-- "heading" (gold labels and titles take the semibold weight when the font has one).
local OBJECTS = {
    {"VCAFontNormal", "GameFontNormal", true},
    {"VCAFontNormalLarge", "GameFontNormalLarge", true},
    {"VCAFontNormalSmall", "GameFontNormalSmall", true},
    {"VCAFontNormalHuge", "GameFontNormalHuge", true},
    {"VCAFontHighlight", "GameFontHighlight", false},
    {"VCAFontHighlightSmall", "GameFontHighlightSmall", false},
    {"VCAFontHighlightLarge", "GameFontHighlightLarge", false},
    {"VCAFontDisableSmall", "GameFontDisableSmall", false}
}

local DEFAULT = "default"

-- Fonts that come with the game or the addon. regular/bold: bold is used for headings.
local BUILTIN = {
    {name = "Source Sans 3", regular = MEDIA .. "SourceSans3-Regular.ttf", bold = MEDIA .. "SourceSans3-Semibold.ttf"},
    {name = "Friz Quadrata", regular = "Fonts\\FRIZQT__.TTF"},
    {name = "Arial Narrow", regular = "Fonts\\ARIALN.TTF"},
    {name = "Morpheus", regular = "Fonts\\MORPHEUS.TTF"},
    {name = "Skurri", regular = "Fonts\\skurri.TTF"}
}

local objects = {}
for _, def in ipairs(OBJECTS) do
    local obj = CreateFont(def[1])
    if _G[def[2]] then
        obj:CopyFontObject(_G[def[2]])
    end
    objects[#objects + 1] = {obj = obj, base = def[2], heading = def[3]}
end

local function LSM()
    if LibStub then
        return LibStub("LibSharedMedia-3.0", true)
    end
    return nil
end

local function GDB()
    return _G[VCA.GLOBAL_DB_NAME]
end

-- The file(s) of a font name: regular and bold paths, or nil when it is not available.
function Fonts.Resolve(name)
    if not name or name == DEFAULT then
        return nil
    end
    for _, f in ipairs(BUILTIN) do
        if f.name == name then
            return f.regular, f.bold or f.regular
        end
    end
    local lsm = LSM()
    if lsm and lsm.Fetch then
        local path = lsm:Fetch("font", name, true)
        if type(path) == "string" then
            return path, path
        end
    end
    return nil
end

-- All the names to choose from: the game and addon fonts first, then everything LibSharedMedia
-- has (other addons), without repeats, each group in alphabetical order.
function Fonts.List()
    local list, seen = {}, {}
    for _, f in ipairs(BUILTIN) do
        list[#list + 1] = f.name
        seen[f.name] = true
    end
    local lsm = LSM()
    if lsm and lsm.List then
        local names = {}
        local all = lsm:List("font")
        for i = 1, type(all) == "table" and #all or 0 do
            local n = all[i]
            if type(n) == "string" and not seen[n] then
                seen[n] = true
                names[#names + 1] = n
            end
        end
        table.sort(names, function(a, b)
            return a:lower() < b:lower()
        end)
        for _, n in ipairs(names) do
            list[#list + 1] = n
        end
    end
    return list
end

-- Puts the named font on every addon font object (nil or "default" restores the game's).
-- Returns true when the font was applied.
function Fonts.Apply(name)
    local regular, bold = Fonts.Resolve(name)
    local applied = false
    for _, o in ipairs(objects) do
        local base = _G[o.base]
        if not regular then
            if base then
                o.obj:CopyFontObject(base)
            end
        else
            local _, size, flags
            if base and base.GetFont then
                _, size, flags = base:GetFont()
            end
            local path = (o.heading and bold) or regular
            local ok = pcall(o.obj.SetFont, o.obj, path, size or 12, flags or "")
            if ok then
                applied = true
            elseif base then
                o.obj:CopyFontObject(base)
            end
        end
    end
    return applied
end

-- Saves the choice and applies it.
function Fonts.Choose(name)
    local gdb = GDB()
    if gdb then
        gdb.fontName = (name and name ~= DEFAULT) and name or nil
    end
    return Fonts.Apply(name)
end

function Fonts.Current()
    local gdb = GDB()
    return gdb and gdb.fontName or nil
end

-- Apply the saved choice once every addon has loaded (others register their fonts on the way),
-- and again when the chosen font gets registered late.
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function()
    Fonts.Apply(Fonts.Current())
    local lsm = LSM()
    if lsm and lsm.RegisterCallback then
        local owner = {}
        lsm.RegisterCallback(owner, "LibSharedMedia_Registered", function(_, mediaType, key)
            if mediaType == "font" and key == Fonts.Current() then
                Fonts.Apply(key)
            end
        end)
    end
end)
