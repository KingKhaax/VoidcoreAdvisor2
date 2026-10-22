-- VoidcoreAdvisor Reborn: ThemePreview
-- A small sample window painted with the current color theme. It stays open while
-- you change the theme in the options, so you can see the colors change live.
-- Opened from the "Preview" button next to the theme selector or with /void preview.
local _, VCA = ...
local L = VCA.L

local Preview = {}
VCA.ThemePreview = Preview

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
VCA.OnTheme(function()
    local b, e = VCA.Theme.bg, VCA.Theme.border
    frame:SetBackdropColor(b[1], b[2], b[3], 0.97)
    frame:SetBackdropBorderColor(e[1], e[2], e[3], 1)
end)
frame:Hide()
tinsert(UISpecialFrames, "VCAThemePreviewFrame")

local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 14, -12)
VCA.OnTheme(function()
    title:SetText(VCA.TitleText())
end)

local subtitle = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -3)
subtitle:SetText(L["OPTIONS_THEME"])

local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -3, -3)

local function Line(y)
    local t = frame:CreateTexture(nil, "ARTWORK")
    t:SetHeight(1)
    t:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, y)
    t:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, y)
    VCA.OnTheme(function()
        local e = VCA.Theme.border
        t:SetColorTexture(e[1], e[2], e[3], 0.5)
    end)
    return t
end
Line(-52)

-- Column headers
local lootHeader = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
lootHeader:SetPoint("TOPLEFT", 14, -60)
VCA.OnTheme(function()
    lootHeader:SetText(VCA.Theme.hdr .. L["COL_LOOT"] .. "|r  |cffffffff+10|r")
end)
local specHeader = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
specHeader:SetPoint("TOPLEFT", 214, -60)
VCA.OnTheme(function()
    specHeader:SetText(VCA.Theme.hdr .. L["COL_SPEC_RANKING"] .. "|r")
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
        VCA.OnTheme(function()
            local a = VCA.Theme.accent
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

-- Timer bar
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
-- The sample bar counts down like a real bonus roll and starts over when it ends.
local clock = 0
frame:SetScript("OnUpdate", function(_, dt)
    clock = (clock + (dt or 0)) % PREVIEW_SECONDS
    local remaining = PREVIEW_SECONDS - clock
    timerBar:SetValue(remaining)
    timerText:SetText(VCA.FormatTimer(remaining))
end)
VCA.OnTheme(function()
    local t, g = VCA.Theme.timer, VCA.Theme.timerBg
    timerBar:SetStatusBarColor(t[1], t[2], t[3], 1)
    timerBg:SetColorTexture(g[1], g[2], g[3], 0.9)
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

function Preview.Toggle()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end

function Preview.Show()
    frame:Show()
end
