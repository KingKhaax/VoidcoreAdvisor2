-- VoidcoreAdvisor Reborn: Theme
-- One palette per color theme. Windows register a small function with
-- VCA.OnTheme() that paints them; ApplyTheme() runs all of them again, so
-- switching theme recolors every open window without reloading the UI.
local _, VCA = ...

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
    }
}

VCA.THEME_ORDER = {"green", "purple", "blue"}
VCA.Theme = VCA.Themes.green

local painters = {}

-- Runs fn now and again every time the theme changes.
function VCA.OnTheme(fn)
    painters[#painters + 1] = fn
    pcall(fn)
end

function VCA.ApplyTheme(name)
    if name and VCA.Themes[name] then
        VCA.Theme = VCA.Themes[name]
    end
    for _, fn in ipairs(painters) do
        pcall(fn)
    end
end

-- Window title with the theme color on the "Voidcore" part.
function VCA.TitleText()
    local s = VCA.L and VCA.L["PANEL_TITLE"] or "VoidcoreAdvisor"
    return (s:gsub("|cff8fe36b", VCA.Theme.title))
end
