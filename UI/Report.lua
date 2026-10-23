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
frame:SetSize(640, 420)
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

local title = frame:CreateFontString(nil, "OVERLAY", "VCAFontNormalLarge")
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
edit:SetWidth(580)
edit:SetMaxLetters(0)
edit:SetScript("OnEscapePressed", function(self)
    self:ClearFocus()
end)
scroll:SetScrollChild(edit)

-- Rich mode: a text that can show icons (an edit box cannot). Not selectable.
local richHolder = CreateFrame("Frame", nil, scroll)
richHolder:SetSize(580, 10)
local richText = richHolder:CreateFontString(nil, "OVERLAY", "ChatFontNormal")
richText:SetPoint("TOPLEFT", 0, 0)
richText:SetWidth(580)
richText:SetJustifyH("LEFT")
richText:SetJustifyV("TOP")
richText:SetSpacing(3)

-- Rich rows: in rich mode every line of the text is its own row, so a line that carries an item
-- can be hovered (tooltip), shift-clicked (into the chat) or ctrl-clicked (dressing room).
local richRows = {}

local function GetRichRow(i)
    local row = richRows[i]
    if row then
        return row
    end
    row = CreateFrame("Button", nil, richHolder)
    row:SetWidth(580)
    row.text = row:CreateFontString(nil, "OVERLAY", "ChatFontNormal")
    row.text:SetPoint("TOPLEFT", 0, 0)
    row.text:SetWidth(580)
    row.text:SetJustifyH("LEFT")
    row.text:SetJustifyV("TOP")
    row.text:SetSpacing(3)
    row.hl = row:CreateTexture(nil, "BACKGROUND")
    row.hl:SetAllPoints()
    row.hl:SetColorTexture(1, 1, 1, 0.08)
    row.hl:Hide()
    row:SetScript("OnEnter", function(self)
        if not self.link then
            return
        end
        self.hl:Show()
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
        GameTooltip:SetHyperlink(self.link)
        GameTooltip:Show()
    end)
    row:SetScript("OnLeave", function(self)
        self.hl:Hide()
        GameTooltip:Hide()
    end)
    row:SetScript("OnClick", function(self)
        if not self.link then
            return
        end
        if IsModifiedClick("CHATLINK") then
            local link = self.link
            if not link:find("|H", 1, true) and C_Item and C_Item.GetItemInfo then
                link = select(2, C_Item.GetItemInfo(link)) or link
            end
            ChatEdit_InsertLink(link)
        elseif IsModifiedClick("DRESSUP") then
            DressUpLink(self.link)
        end
    end)
    richRows[i] = row
    return row
end

-- Lays the text out as rows; links[n] is the item link of line n (optional).
local function ShowRichRows(text, links)
    richText:SetText("")
    local y, n = 0, 0
    for line in ((text or "") .. "\n"):gmatch("([^\n]*)\n") do
        n = n + 1
        local row = GetRichRow(n)
        row.link = links and links[n] or nil
        row.text:SetText(line == "" and " " or line)
        local h = math.max(8, row.text:GetStringHeight() + 3)
        row:SetHeight(h)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", richHolder, "TOPLEFT", 0, -y)
        row:EnableMouse(row.link ~= nil)
        row:Show()
        y = y + h
    end
    for i = n + 1, #richRows do
        richRows[i].link = nil
        richRows[i]:Hide()
    end
    richHolder:SetHeight(math.max(10, y + 6))
end

local actionBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
actionBtn:SetSize(140, 24)
actionBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -16, 14)

local footer = frame:CreateFontString(nil, "OVERLAY", "VCAFontHighlightSmall")
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
-- opts.rich    : show text with icons; opts.links = {[line number] = item link} makes those lines
--                hoverable and clickable
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
    frame:Raise()
    if opts.rich then
        scroll:SetScrollChild(richHolder)
        ShowRichRows(text, opts.links)
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
local bannerText = banner:CreateFontString(nil, "OVERLAY", "VCAFontHighlight")
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
