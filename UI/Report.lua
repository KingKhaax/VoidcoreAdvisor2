-- VoidcoreAdvisor Reborn: Report
-- One small window that shows text you can select and copy (or paste into, with an action
-- button). Used by /void cores, next, history, chars, debug and wish.
local _, VCA = ...

local Report = {}
VCA.Report = Report

-- The window is created the first time it is used, so it costs nothing until then.
local built = false
local function Build()


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

-- Rich mode: a text that can show icons (an edit box cannot). Not selectable.
local richHolder = CreateFrame("Frame", nil, scroll)
richHolder:SetSize(500, 10)
local richText = richHolder:CreateFontString(nil, "OVERLAY", "ChatFontNormal")
richText:SetPoint("TOPLEFT", 0, 0)
richText:SetWidth(500)
richText:SetJustifyH("LEFT")
richText:SetJustifyV("TOP")
richText:SetSpacing(3)

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
    if opts.rich then
        scroll:SetScrollChild(richHolder)
        richText:SetText(text or "")
        richHolder:SetHeight(math.max(10, richText:GetStringHeight() + 6))
        scroll:SetVerticalScroll(0)
        frame:Show()
        return
    end
    scroll:SetScrollChild(edit)
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
end

local function EnsureBuilt()
    if not built then
        built = true
        Build()
    end
end
do
    Report.Show = function(...)
        EnsureBuilt()
        return Report.Show(...)
    end
    Report.Hide = function(...)
        if not built then
            return
        end
        return Report.Hide(...)
    end
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
