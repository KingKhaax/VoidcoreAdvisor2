-- VoidcoreAdvisor Reborn: Report
-- One small window that shows text you can select and copy (or paste into, with an action
-- button). Used by /void cores, next, history, chars, debug and wish.
local _, VCA = ...

local Report = {}
VCA.Report = Report

local frame = CreateFrame("Frame", "VCAReportFrame", UIParent, "BackdropTemplate")
frame:SetSize(560, 400)
frame:SetPoint("CENTER")
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
    frame:SetBackdropColor(b[1], b[2], b[3], 0.98)
    frame:SetBackdropBorderColor(e[1], e[2], e[3], 1)
end)
frame:Hide()
tinsert(UISpecialFrames, "VCAReportFrame")

local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -14)

local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -4, -4)

local scroll = CreateFrame("ScrollFrame", "VCAReportScroll", frame, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -44)
scroll:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -34, 50)
local edit = CreateFrame("EditBox", nil, scroll)
edit:SetMultiLine(true)
edit:SetAutoFocus(false)
edit:SetFontObject("ChatFontNormal")
edit:SetWidth(500)
edit:SetMaxLetters(0)
edit:SetScript("OnEscapePressed", function(self)
    self:ClearFocus()
end)
scroll:SetScrollChild(edit)

local actionBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
actionBtn:SetSize(140, 24)
actionBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -16, 14)

local footer = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
footer:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 16, 18)
footer:SetPoint("RIGHT", actionBtn, "LEFT", -10, 0)
footer:SetJustifyH("LEFT")

local onAction

actionBtn:SetScript("OnClick", function()
    if onAction then
        onAction(edit:GetText() or "")
    end
end)

-- opts.button  : label of an action button; it receives the text of the box
-- opts.editable: the box starts empty and you paste into it (needs opts.button)
-- opts.footer  : small hint at the bottom
function Report.Show(titleText, text, opts)
    opts = opts or {}
    title:SetText(VCA.Theme.title .. titleText .. "|r")
    footer:SetText(opts.footer or "")
    onAction = opts.onAction
    if opts.button then
        actionBtn:SetText(opts.button)
        actionBtn:Show()
    else
        actionBtn:Hide()
    end
    edit:SetText(opts.editable and "" or text or "")
    frame:Show()
    edit:SetFocus()
    if not opts.editable then
        edit:HighlightText(0, 0)
        edit:SetCursorPosition(0)
    end
end

function Report.Hide()
    frame:Hide()
end

-- ── Banner ────────────────────────────────────────────────────────────────────
-- A visible notice at the top of the screen (gone after 30 seconds or on click).

local banner = CreateFrame("Button", "VCABanner", UIParent, "BackdropTemplate")
banner:SetSize(520, 54)
banner:SetPoint("TOP", UIParent, "TOP", 0, -90)
banner:SetFrameStrata("FULLSCREEN_DIALOG")
banner:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1,
    insets = {left = 1, right = 1, top = 1, bottom = 1}
})
banner:SetBackdropColor(0.25, 0.16, 0.02, 0.96)
banner:SetBackdropBorderColor(1, 0.7, 0.1, 1)
banner:Hide()
local bannerText = banner:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
bannerText:SetPoint("TOPLEFT", 12, -8)
bannerText:SetPoint("BOTTOMRIGHT", -12, 8)
bannerText:SetJustifyH("CENTER")
bannerText:SetJustifyV("MIDDLE")
banner:SetScript("OnClick", function(self)
    self:Hide()
end)

local bannerToken = 0
function VCA.Banner(text)
    bannerText:SetText(text)
    banner:Show()
    bannerToken = bannerToken + 1
    local token = bannerToken
    C_Timer.After(30, function()
        if bannerToken == token then
            banner:Hide()
        end
    end)
end
