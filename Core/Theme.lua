-- VoidcoreAdvisor Reborn: Theme
-- One palette per color theme. Windows register a small function with
-- VCA.OnTheme() that paints them; ApplyTheme() runs all of them again, so
-- switching theme recolors every open window without reloading the UI.
--
-- Themes: three hand-made palettes (green, purple, blue), four elemental ones
-- (light, fire, frost, red), one per class (class colors) and "class", which
-- follows the class of the character you are playing.
local _, VCA = ...

local function Hex(r, g, b)
    return string.format("|cff%02x%02x%02x", math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5),
        math.floor(b * 255 + 0.5))
end

local function Mix(c, to, t)
    return c + (to - c) * t
end

-- Builds a full palette from one base color.
local function FromColor(r, g, b)
    local function lighter(t)
        return Mix(r, 1, t), Mix(g, 1, t), Mix(b, 1, t)
    end
    local ar, ag, ab = lighter(0.35)
    local tr, tg, tb = lighter(0.2)
    return {
        bg = {r * 0.10 + 0.02, g * 0.10 + 0.02, b * 0.10 + 0.02},
        border = {r * 0.60, g * 0.60, b * 0.60},
        accent = {ar, ag, ab},
        timer = {r * 0.90, g * 0.90, b * 0.90},
        timerBg = {r * 0.06 + 0.02, g * 0.06 + 0.02, b * 0.06 + 0.02},
        hdr = Hex(lighter(0.45)),
        title = Hex(tr, tg, tb)
    }
end

VCA.Themes = {
    green = {
        bg = {0.063, 0.125, 0.086},
        border = {0.30, 0.54, 0.35},
        accent = {0.56, 0.89, 0.42},
        timer = {0.44, 0.78, 0.35},
        timerBg = {0.04, 0.10, 0.06},
        hdr = "|cff9fe08a",
        title = "|cff8fe36b"
    },
    purple = {
        bg = {0.05, 0.02, 0.12},
        border = {0.58, 0.0, 0.82},
        accent = {0.69, 0.28, 0.97},
        timer = {0.62, 0.22, 0.90},
        timerBg = {0.12, 0.04, 0.20},
        hdr = "|cffb048f8",
        title = "|cffb048f8"
    },
    blue = {
        bg = {0.04, 0.08, 0.16},
        border = {0.25, 0.50, 0.85},
        accent = {0.45, 0.72, 1.0},
        timer = {0.30, 0.60, 0.95},
        timerBg = {0.04, 0.08, 0.18},
        hdr = "|cff8cc4ff",
        title = "|cff6fb0ff"
    },
    light = FromColor(1.0, 0.86, 0.45),
    fire = FromColor(1.0, 0.45, 0.10),
    frost = FromColor(0.45, 0.80, 1.0),
    red = FromColor(0.85, 0.15, 0.15)
}

-- Class colors (the same ones the game uses for class names).
VCA.CLASS_THEMES = {
    {"deathknight", "DEATHKNIGHT", 0.77, 0.12, 0.23},
    {"demonhunter", "DEMONHUNTER", 0.64, 0.19, 0.79},
    {"druid", "DRUID", 1.00, 0.49, 0.04},
    {"evoker", "EVOKER", 0.20, 0.58, 0.50},
    {"hunter", "HUNTER", 0.67, 0.83, 0.45},
    {"mage", "MAGE", 0.25, 0.78, 0.92},
    {"monk", "MONK", 0.00, 1.00, 0.60},
    {"paladin", "PALADIN", 0.96, 0.55, 0.73},
    {"priest", "PRIEST", 1.00, 1.00, 1.00},
    {"rogue", "ROGUE", 1.00, 0.96, 0.41},
    {"shaman", "SHAMAN", 0.00, 0.44, 0.87},
    {"warlock", "WARLOCK", 0.53, 0.53, 0.93},
    {"warrior", "WARRIOR", 0.78, 0.61, 0.43}
}

VCA.THEME_ORDER = {"class", "green", "purple", "blue", "light", "fire", "frost", "red"}
VCA.THEME_CLASSFILE = {}
for _, c in ipairs(VCA.CLASS_THEMES) do
    VCA.Themes[c[1]] = FromColor(c[3], c[4], c[5])
    VCA.THEME_CLASSFILE[c[1]] = c[2]
    VCA.THEME_ORDER[#VCA.THEME_ORDER + 1] = c[1]
end

VCA.Theme = VCA.Themes.green

-- "class" follows the character; everything else is a key of VCA.Themes.
function VCA.IsTheme(name)
    return name == "class" or (name ~= nil and VCA.Themes[name] ~= nil)
end

local function ClassThemeKey()
    local _, classFile = UnitClass("player")
    for key, file in pairs(VCA.THEME_CLASSFILE) do
        if file == classFile then
            return key
        end
    end
    return "green"
end

local function Resolve(name)
    if name == "class" then
        return ClassThemeKey()
    end
    return name
end

-- Name shown in the options for a theme key.
function VCA.ThemeLabel(key)
    local file = VCA.THEME_CLASSFILE[key]
    if file then
        local names = LOCALIZED_CLASS_NAMES_MALE
        return (names and names[file]) or key
    end
    return VCA.L["THEME_" .. key:upper()] or key
end

local painters = {}

-- Runs fn now and again every time the theme changes.
function VCA.OnTheme(fn)
    painters[#painters + 1] = fn
    pcall(fn)
end

function VCA.ApplyTheme(name)
    local key = Resolve(name)
    if key and VCA.Themes[key] then
        VCA.Theme = VCA.Themes[key]
    end
    for _, fn in ipairs(painters) do
        pcall(fn)
    end
end

-- 154 -> "2:34". Used by the countdown drawn on the timer bars.
function VCA.FormatTimer(seconds)
    local s = math.max(0, math.floor((seconds or 0) + 0.5))
    return string.format("%d:%02d", math.floor(s / 60), s % 60)
end

-- Window title with the theme color on the "Voidcore" part.
function VCA.TitleText()
    local s = VCA.L and VCA.L["PANEL_TITLE"] or "VoidcoreAdvisor"
    return (s:gsub("|cff8fe36b", VCA.Theme.title))
end

-- The "class" theme follows the character: repaint once the player is known.
local follower = CreateFrame("Frame")
follower:RegisterEvent("PLAYER_LOGIN")
follower:SetScript("OnEvent", function()
    local gdb = _G[VCA.GLOBAL_DB_NAME]
    local name = gdb and gdb.theme
    if name == "class" then
        VCA.ApplyTheme(name)
        if VCA.Panel and VCA.Panel.Refresh then
            VCA.Panel.Refresh()
        end
    end
end)
