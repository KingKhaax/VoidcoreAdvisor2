-- VoidcoreAdvisor Reborn: ThemePreview
-- A small sample window painted with a color theme. It shows the theme you have
-- selected, or any other theme you pick for the preview (so you can browse them
-- without changing yours), and it stays open while you change themes in the options.
-- Opened from the "Preview" button next to the theme selector or with /void preview.
local _, VCA = ...
local L = VCA.L

local Preview = {}
VCA.ThemePreview = Preview

-- "current" = the theme you use; otherwise a theme key (or "class").
local previewKey = "current"

local painters = {}
local function Palette()
    return VCA.GetPalette(previewKey)
end

-- Registers a function that paints with the previewed palette; it runs again
-- whenever the previewed theme or the real theme changes.
local function Paint(fn)
    painters[#painters + 1] = fn
    pcall(fn)
end

local function Repaint()
    for _, fn in ipairs(painters) do
        pcall(fn)
    end
end
VCA.OnTheme(Repaint)

local frame = CreateFrame("Frame", "VCAThemePreviewFrame", UIParent, "BackdropTemplate")
frame:SetSize(400, 290)
frame:SetPoint("CENTER", UIParent, "CENTER", 360, 0)
frame:SetFrameStrata("DIALOG")
frame:SetClampedToScreen(true)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1,
    insets = {left = 1, right = 1, top = 1, bottom = 1}
})
Paint(function()
    local p = Palette()
    frame:SetBackdropColor(p.bg[1], p.bg[2], p.bg[3], 0.97)
    frame:SetBackdropBorderColor(p.border[1], p.border[2], p.border[3], 1)
end)
frame:Hide()
tinsert(UISpecialFrames, "VCAThemePreviewFrame")

local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 14, -12)
Paint(function()
    local s = L["PANEL_TITLE"] or "VoidcoreAdvisor"
    title:SetText((s:gsub("|cff8fe36b", Palette().title)))
end)

-- Name of the previewed theme, with arrows to browse them.
local themeName = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
themeName:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -3)

local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -3, -3)

local function Order()
    local order = {"current"}
    for _, key in ipairs(VCA.THEME_ORDER) do
        order[#order + 1] = key
    end
    return order
end

local function Label(key)
    if key == "current" then
        return L["THEME_CURRENT"]
    end
    return VCA.ThemeLabel(key)
end

-- Shows a theme in the sample window; nothing is saved.
function Preview.SetTheme(key)
    if key ~= "current" and not VCA.IsTheme(key) then
        key = "current"
    end
    previewKey = key
    themeName:SetText(Label(key))
    Repaint()
end

local function Step(delta)
    local order = Order()
    local index = 1
    for i, key in ipairs(order) do
        if key == previewKey then
            index = i
        end
    end
    index = (index - 1 + delta) % #order + 1
    Preview.SetTheme(order[index])
end

local prevBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
prevBtn:SetSize(22, 20)
prevBtn:SetPoint("TOPRIGHT", closeBtn, "TOPLEFT", -34, -3)
prevBtn:SetText("<")
prevBtn:SetScript("OnClick", function()
    Step(-1)
end)
local nextBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
nextBtn:SetSize(22, 20)
nextBtn:SetPoint("LEFT", prevBtn, "RIGHT", 2, 0)
nextBtn:SetText(">")
nextBtn:SetScript("OnClick", function()
    Step(1)
end)

local function Line(y)
    local t = frame:CreateTexture(nil, "ARTWORK")
    t:SetHeight(1)
    t:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, y)
    t:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, y)
    Paint(function()
        local e = Palette().border
        t:SetColorTexture(e[1], e[2], e[3], 0.5)
    end)
    return t
end
Line(-52)

-- Column headers
local lootHeader = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
lootHeader:SetPoint("TOPLEFT", 14, -60)
Paint(function()
    lootHeader:SetText(Palette().hdr .. L["COL_LOOT"] .. "|r  |cffffffff+10|r")
end)
local specHeader = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
specHeader:SetPoint("TOPLEFT", 214, -60)
Paint(function()
    specHeader:SetText(Palette().hdr .. L["COL_SPEC_RANKING"] .. "|r")
end)

-- Loot rows (sample items; the second is selected, the last one is already obtained)
local SAMPLE_ITEMS = {
    {"Interface\\Icons\\INV_Helmet_03", "Crown of the Dark Envoy", "ffc27df2", false, false},
    {"Interface\\Icons\\INV_Jewelry_Necklace_07", "Necklace of the Twisting Void", "ffc27df2", true, false},
    {"Interface\\Icons\\INV_Gauntlets_29", "Voidclaw Gauntlets", "ffc27df2", false, false},
    {"Interface\\Icons\\INV_Chest_Plate04", "Breastplate of the Dark Touch", "ff8a6aa3", false, true}
}
for i, item in ipairs(SAMPLE_ITEMS) do
    local row = CreateFrame("Frame", nil, frame)
    row:SetSize(190, 24)
    row:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, -78 - (i - 1) * 27)
    local bg = row:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(1, 1, 1, 0.04)
    if item[4] then
        local sel = row:CreateTexture(nil, "BACKGROUND", nil, 1)
        sel:SetAllPoints()
        Paint(function()
            local a = Palette().accent
            sel:SetColorTexture(a[1], a[2], a[3], 0.22)
        end)
    end
    local icon = row:CreateTexture(nil, "ARTWORK")
    icon:SetSize(20, 20)
    icon:SetPoint("LEFT", 2, 0)
    icon:SetTexture(item[1])
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    local name = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    name:SetPoint("LEFT", icon, "RIGHT", 5, 0)
    name:SetPoint("RIGHT", row, "RIGHT", -4, 0)
    name:SetJustifyH("LEFT")
    name:SetWordWrap(false)
    name:SetText("|c" .. item[3] .. item[2] .. "|r")
    if item[5] then
        row:SetAlpha(0.55)
    end
end

-- Spec rows, using the player's own specializations
local SPEC_PERCENT = {"82%", "41%", "20%"}
for i = 1, 3 do
    local row = CreateFrame("Frame", nil, frame)
    row:SetSize(176, 24)
    row:SetPoint("TOPLEFT", frame, "TOPLEFT", 212, -78 - (i - 1) * 27)
    local bg = row:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(1, 1, 1, 0.04)
    local rank = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    rank:SetPoint("LEFT", 4, 0)
    rank:SetText("#" .. i)
    local icon = row:CreateTexture(nil, "ARTWORK")
    icon:SetSize(20, 20)
    icon:SetPoint("LEFT", 24, 0)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    local name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    name:SetPoint("LEFT", icon, "RIGHT", 5, 0)
    local pct = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    pct:SetPoint("RIGHT", -6, 0)
    pct:SetText("|cffffff00" .. SPEC_PERCENT[i] .. "|r")
    local specID, specName, _, specIcon
    if GetSpecialization and GetSpecializationInfo then
        specID, specName, _, specIcon = GetSpecializationInfo(i)
    end
    icon:SetTexture(specIcon or "Interface\\Icons\\INV_Misc_QuestionMark")
    name:SetText(specName or ("Spec " .. i))
end

-- Timer bar with the time left in its center
local timerBg = frame:CreateTexture(nil, "BACKGROUND")
timerBg:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, -196)
timerBg:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -12, -196)
timerBg:SetHeight(14)
local timerBar = CreateFrame("StatusBar", nil, frame)
timerBar:SetPoint("TOPLEFT", timerBg, "TOPLEFT", 0, 0)
timerBar:SetPoint("BOTTOMRIGHT", timerBg, "BOTTOMRIGHT", 0, 0)
timerBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
local PREVIEW_SECONDS = 174
timerBar:SetMinMaxValues(0, PREVIEW_SECONDS)
timerBar:SetValue(PREVIEW_SECONDS * 0.62)
local timerText = timerBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
timerText:SetPoint("CENTER", timerBar, "CENTER", 0, 0)
timerText:SetShadowColor(0, 0, 0, 1)
timerText:SetShadowOffset(1, -1)
timerText:SetText(VCA.FormatTimer(PREVIEW_SECONDS * 0.62))
Paint(function()
    local p = Palette()
    local t, g = p.timer, p.timerBg
    timerBar:SetStatusBarColor(t[1], t[2], t[3], 1)
    timerBg:SetColorTexture(g[1], g[2], g[3], 0.9)
end)
-- The sample bar counts down like a real bonus roll and starts over when it ends.
local clock = 0
frame:SetScript("OnUpdate", function(_, dt)
    clock = (clock + (dt or 0)) % PREVIEW_SECONDS
    local remaining = PREVIEW_SECONDS - clock
    timerBar:SetValue(remaining)
    timerText:SetText(VCA.FormatTimer(remaining))
end)

-- Roll / Pass / Mark buttons (these colors do not change with the theme)
local function SampleButton(text, r, g, b, w, point, x, y)
    local btn = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    btn:SetSize(w, 24)
    btn:SetPoint(point, frame, point, x, y)
    btn:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1
    })
    btn:SetBackdropColor(r, g, b, 1)
    btn:SetBackdropBorderColor(0, 0, 0, 1)
    local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fs:SetPoint("CENTER")
    fs:SetText(text)
    return btn
end
SampleButton(L["BONUS_ROLL_CONFIRM_ROLL"], 0.14, 0.42, 0.16, 180, "TOPLEFT", 12, -214)
SampleButton(L["BONUS_ROLL_CONFIRM_PASS"], 0.5, 0.09, 0.09, 180, "TOPRIGHT", -12, -214)
SampleButton("+ " .. L["MARK_MODE_BUTTON"], 0.14, 0.42, 0.16, 376, "TOPLEFT", 12, -246)

local note = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
note:SetPoint("BOTTOMLEFT", 14, 10)
note:SetText("/void theme <name>")

function Preview.GetTheme()
    return previewKey
end

-- It always opens on the theme you use.
function Preview.Show()
    if not frame:IsShown() then
        Preview.SetTheme("current")
    end
    frame:Show()
end

function Preview.Toggle()
    if frame:IsShown() then
        frame:Hide()
    else
        Preview.Show()
    end
end

themeName:SetText(Label(previewKey))
