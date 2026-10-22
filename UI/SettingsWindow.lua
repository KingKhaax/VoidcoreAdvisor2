-- VoidcoreAdvisor Reborn: SettingsWindow
-- The addon's own settings window (/void open, or the button of the addon in the game's
-- Options). Side tabs with the same settings that used to live in the Options list; they are
-- saved in the same variables. The window is built the first time it is opened.
local addonName, VCA = ...
local L = VCA.L

local SW = {}
VCA.SettingsWindow = SW

local WIDTH, HEIGHT = 700, 520
local NAV_W = 176
local ROW_H = 54

local function GDB()
    return _G[VCA.GLOBAL_DB_NAME] or {}
end

local built = false
local frame
local widgets = {} -- everything with an Update() that shows a stored value
local tabs, panes = {}, {}

-- ── Small controls ────────────────────────────────────────────────────────────

local FLAT = {
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1,
    insets = {left = 1, right = 1, top = 1, bottom = 1}
}

local function Accent()
    return VCA.Theme.accent
end

-- On/off switch tied to a boolean in the account variables.
local function Switch(parent, key, afterChange)
    local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
    b:SetSize(40, 20)
    b:SetBackdrop(FLAT)
    local knob = b:CreateTexture(nil, "OVERLAY")
    knob:SetSize(14, 14)
    function b.Update()
        local on = GDB()[key] ~= false
        local a = Accent()
        knob:ClearAllPoints()
        if on then
            knob:SetPoint("RIGHT", b, "RIGHT", -3, 0)
            knob:SetColorTexture(a[1], a[2], a[3], 1)
            b:SetBackdropColor(a[1] * 0.25, a[2] * 0.25, a[3] * 0.25, 1)
            b:SetBackdropBorderColor(a[1], a[2], a[3], 1)
        else
            knob:SetPoint("LEFT", b, "LEFT", 3, 0)
            knob:SetColorTexture(0.3, 0.42, 0.35, 1)
            b:SetBackdropColor(0.02, 0.06, 0.04, 1)
            b:SetBackdropBorderColor(0.16, 0.35, 0.25, 1)
        end
    end
    b:SetScript("OnClick", function()
        GDB()[key] = not (GDB()[key] ~= false)
        b.Update()
        if afterChange then
            afterChange()
        end
    end)
    widgets[#widgets + 1] = b
    return b
end

local function Button(parent, text, width, onClick)
    local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
    b:SetSize(width, 24)
    b:SetBackdrop(FLAT)
    b:SetBackdropColor(0.07, 0.23, 0.13, 1)
    b:SetBackdropBorderColor(0.16, 0.48, 0.29, 1)
    local fs = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    fs:SetPoint("CENTER")
    fs:SetText(text)
    b:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.1, 0.31, 0.18, 1)
    end)
    b:SetScript("OnLeave", function(self)
        self:SetBackdropColor(0.07, 0.23, 0.13, 1)
    end)
    b:SetScript("OnClick", onClick)
    return b
end

-- "< theme name >" selector tied to a theme key; withCurrent adds "the theme I use".
local function ThemeSelector(parent, key, withCurrent, afterChange)
    local box = CreateFrame("Frame", nil, parent)
    box:SetSize(200, 24)
    local keys = {}
    if withCurrent then
        keys[#keys + 1] = "current"
    end
    for _, k in ipairs(VCA.THEME_ORDER) do
        keys[#keys + 1] = k
    end
    local prev = Button(box, "<", 24, nil)
    prev:SetPoint("LEFT", box, "LEFT", 0, 0)
    local nxt = Button(box, ">", 24, nil)
    nxt:SetPoint("RIGHT", box, "RIGHT", 0, 0)
    local mid = CreateFrame("Frame", nil, box, "BackdropTemplate")
    mid:SetBackdrop(FLAT)
    mid:SetBackdropColor(0.02, 0.06, 0.04, 1)
    mid:SetBackdropBorderColor(0.16, 0.35, 0.25, 1)
    mid:SetPoint("TOPLEFT", prev, "TOPRIGHT", -1, 0)
    mid:SetPoint("BOTTOMRIGHT", nxt, "BOTTOMLEFT", 1, 0)
    local label = mid:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    label:SetPoint("CENTER")
    local function IndexOf(value)
        for i, k in ipairs(keys) do
            if k == value then
                return i
            end
        end
        return 1
    end
    function box.Update()
        local v = GDB()[key]
        label:SetText(v == "current" and L["THEME_CURRENT"] or VCA.ThemeLabel(v or keys[1]))
    end
    local function Step(delta)
        local i = (IndexOf(GDB()[key]) - 1 + delta) % #keys + 1
        GDB()[key] = keys[i]
        box.Update()
        if afterChange then
            afterChange()
        end
    end
    prev:SetScript("OnClick", function()
        Step(-1)
    end)
    nxt:SetScript("OnClick", function()
        Step(1)
    end)
    widgets[#widgets + 1] = box
    return box
end

-- ── Layout helpers ────────────────────────────────────────────────────────────

local function NewPane(titleText, subText)
    local pane = CreateFrame("Frame", nil, frame)
    pane:SetPoint("TOPLEFT", frame, "TOPLEFT", NAV_W + 18, -62)
    pane:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -18, 14)
    local t = pane:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    t:SetPoint("TOPLEFT", 0, 0)
    t:SetPoint("RIGHT", pane, "RIGHT", 0, 0)
    t:SetJustifyH("LEFT")
    t:SetWordWrap(false)
    t:SetText(titleText)
    t:SetTextColor(0.85, 0.72, 0.41)
    local s = pane:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    s:SetPoint("TOPLEFT", t, "BOTTOMLEFT", 0, -7)
    s:SetPoint("RIGHT", pane, "RIGHT", 0, 0)
    s:SetJustifyH("LEFT")
    s:SetWordWrap(false)
    s:SetText("|cff8fa597" .. subText .. "|r")
    pane.nextY = -58
    pane:Hide()
    return pane
end

-- One settings row: bold label, grey hint under it, the control on the right.
local function Row(pane, label, hint, makeControl, below)
    local row = CreateFrame("Frame", nil, pane)
    row:SetPoint("TOPLEFT", pane, "TOPLEFT", 0, pane.nextY)
    row:SetPoint("TOPRIGHT", pane, "TOPRIGHT", 0, pane.nextY)
    row:SetHeight(ROW_H)
    local line = row:CreateTexture(nil, "BORDER")
    line:SetColorTexture(0.07, 0.19, 0.12, 1)
    line:SetHeight(1)
    line:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0)
    line:SetPoint("TOPRIGHT", row, "TOPRIGHT", 0, 0)
    local control = makeControl(row)
    local l = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    l:SetPoint("TOPLEFT", row, "TOPLEFT", 0, -14)
    l:SetJustifyH("LEFT")
    l:SetText("|cffeeeeee" .. label .. "|r")
    local h
    if hint and hint ~= "" then
        h = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        h:SetPoint("TOPLEFT", l, "BOTTOMLEFT", 0, -8)
        h:SetJustifyH("LEFT")
        h:SetJustifyV("TOP")
        h:SetText("|cff8fa597" .. hint .. "|r")
    end
    -- The control sits on the right; the texts use the space left of it and the row grows
    -- with them, so a long label or hint never runs into the next row.
    local paneW = WIDTH - NAV_W - 36
    local textW = below and paneW or (paneW - control:GetWidth() - 40)
    for _, fs in ipairs({l, h}) do
        fs:SetWidth(textW)
        fs:SetWordWrap(true)
    end
    local textH = 14 + l:GetStringHeight() + (h and (8 + h:GetStringHeight()) or 0)
    local height
    if below then
        height = textH + 10 + control:GetHeight() + 14
        control:SetPoint("TOPLEFT", row, "TOPLEFT", 0, -(textH + 10))
    else
        height = math.max(ROW_H + 6, textH + 16)
        control:SetPoint("RIGHT", row, "RIGHT", 0, 0)
        control:SetPoint("TOP", row, "TOP", 0, -(height - control:GetHeight()) / 2 + 2)
    end
    row:SetHeight(height)
    pane.nextY = pane.nextY - height
    return row
end

local function SwitchRow(pane, key, label, hint, afterChange)
    Row(pane, label, hint, function(row)
        return Switch(row, key, afterChange)
    end)
end

-- A theme row: the selector and a Preview button.
local function ThemeRow(pane, key, label, hint, withCurrent, afterChange, onPreview)
    Row(pane, label, hint, function(row)
        local box = CreateFrame("Frame", nil, row)
        box:SetSize(200 + 8 + 90, 24)
        local sel = ThemeSelector(box, key, withCurrent, afterChange)
        sel:SetPoint("LEFT", box, "LEFT", 0, 0)
        local preview = Button(box, L["OPTIONS_PREVIEW_REMINDER"], 90, onPreview)
        preview:SetPoint("RIGHT", box, "RIGHT", 0, 0)
        return box
    end, true)
end

-- A preview window opened from here is placed beside this window (or on its left when there is
-- no room on the right), so it never covers the settings.
local function PlaceBeside(frameName)
    local f = _G[frameName]
    if not (f and f:IsShown() and frame and frame:IsShown()) then
        return
    end
    f:ClearAllPoints()
    local w = f:GetWidth() or 400
    if (frame:GetRight() or 0) + 12 + w > (UIParent:GetRight() or 1920) then
        f:SetPoint("TOPRIGHT", frame, "TOPLEFT", -12, 0)
    else
        f:SetPoint("TOPLEFT", frame, "TOPRIGHT", 12, 0)
    end
end

local function ApplyAndRefresh()
    VCA.ApplyTheme(GDB().theme)
    if VCA.Panel and VCA.Panel.Refresh then
        VCA.Panel.Refresh()
    end
end

-- ── Tabs ──────────────────────────────────────────────────────────────────────

local TOOLS = {
    {"SETTINGS_TOOL_MISSING", "/void missing", "missing", "VCAMissingFrame"},
    {"SETTINGS_TOOL_NEXT", "/void next", "next", "VCAReportFrame"},
    {"SETTINGS_TOOL_CORES", "/void cores", "cores", "VCAReportFrame"},
    {"SETTINGS_TOOL_HISTORY", "/void history", "history", "VCAReportFrame"},
    {"SETTINGS_TOOL_WISH", "/void wish", "wish", "VCAReportFrame"},
    {"SETTINGS_TOOL_RESET", "/void resetpanel", "resetpanel"}
}

local function BuildPanes()
    local general = NewPane(L["SETTINGS_TAB_GENERAL"], L["SETTINGS_SUB_GENERAL"])
    ThemeRow(general, "theme", L["OPTIONS_THEME"], L["OPTIONS_THEME_TOOLTIP"], false, ApplyAndRefresh, function()
        VCA.ThemePreview.Toggle()
        PlaceBeside("VCAThemePreviewFrame")
    end)
    SwitchRow(general, "showCumulative", L["OPTIONS_CUMULATIVE"], L["OPTIONS_CUMULATIVE_TOOLTIP"], function()
        if VCA.Panel and VCA.Panel.Refresh then
            VCA.Panel.Refresh()
        end
    end)
    SwitchRow(general, "weeklySummary", L["OPTIONS_SUMMARY"], L["OPTIONS_SUMMARY_TOOLTIP"])

    local reminder = NewPane(L["OPTIONS_CAT_REMINDER"], L["SETTINGS_SUB_REMINDER"])
    SwitchRow(reminder, "reminderEnabled", L["OPTIONS_REMINDER_ENABLE"], L["OPTIONS_REMINDER_TOOLTIP"])
    SwitchRow(reminder, "reminderBossEnabled", L["OPTIONS_REMINDER_BOSS"], L["OPTIONS_REMINDER_BOSS_TOOLTIP"])
    ThemeRow(reminder, "reminderTheme", L["OPTIONS_REMINDER_THEME"], L["OPTIONS_REMINDER_THEME_TOOLTIP"], true,
        ApplyAndRefresh, function()
            if VoidcoreAdvisorReminder and VoidcoreAdvisorReminder:IsShown() then
                VCA.Reminder.Hide()
            else
                VCA.Reminder.ShowExample()
                PlaceBeside("VoidcoreAdvisorReminder")
            end
        end)

    local roll = NewPane(L["OPTIONS_CAT_BONUS_ROLL"], L["SETTINGS_SUB_ROLL"])
    SwitchRow(roll, "bonusRollConfirmEnabled", L["OPTIONS_BONUS_ROLL_CONFIRM"], L["OPTIONS_BONUS_ROLL_CONFIRM_TOOLTIP"])
    SwitchRow(roll, "brcConfirmEnabled", L["OPTIONS_BRC_CONFIRM"], L["OPTIONS_BRC_CONFIRM_TOOLTIP"])
    SwitchRow(roll, "brcSpecListEnabled", L["OPTIONS_BRC_SPEC_LIST"], L["OPTIONS_BRC_SPEC_LIST_TOOLTIP"])
    ThemeRow(roll, "rollTheme", L["OPTIONS_ROLL_THEME"], L["OPTIONS_ROLL_THEME_TOOLTIP"], true, ApplyAndRefresh,
        function()
            if VCARollWindow and VCARollWindow:IsShown() then
                VCA.BonusRollConfirm.Hide()
            else
                VCA.BonusRollConfirm.ShowPreview()
                PlaceBeside("VCARollWindow")
            end
        end)

    local tools = NewPane(L["SETTINGS_TAB_TOOLS"], L["SETTINGS_SUB_TOOLS"])
    for i, tool in ipairs(TOOLS) do
        local b = CreateFrame("Button", nil, tools, "BackdropTemplate")
        b:SetSize(236, 46)
        b:SetBackdrop(FLAT)
        b:SetBackdropColor(0.04, 0.09, 0.06, 1)
        b:SetBackdropBorderColor(0.09, 0.25, 0.17, 1)
        local col, rowIdx = (i - 1) % 2, math.floor((i - 1) / 2)
        b:SetPoint("TOPLEFT", tools, "TOPLEFT", col * 246, -58 - rowIdx * 56)
        local n = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        n:SetPoint("TOPLEFT", 10, -8)
        n:SetWidth(216)
        n:SetJustifyH("LEFT")
        n:SetWordWrap(false)
        n:SetText("|cffeeeeee" .. L[tool[1]] .. "|r")
        local c = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        c:SetPoint("TOPLEFT", n, "BOTTOMLEFT", 0, -4)
        c:SetWidth(216)
        c:SetJustifyH("LEFT")
        c:SetWordWrap(false)
        c:SetText("|cffd9b968" .. tool[2] .. "|r")
        b:SetScript("OnEnter", function(self)
            self:SetBackdropBorderColor(0.85, 0.72, 0.41, 1)
        end)
        b:SetScript("OnLeave", function(self)
            self:SetBackdropBorderColor(0.09, 0.25, 0.17, 1)
        end)
        b:SetScript("OnClick", function()
            local handler = SlashCmdList and SlashCmdList["VOIDCOREADVISOR"]
            if handler then
                handler(tool[3])
                -- the window it opens goes beside this one, never on top of it
                if tool[4] then
                    PlaceBeside(tool[4])
                end
            end
        end)
    end
    -- Version: what you have, what it adds and who made it
    local ver = NewPane(L["SETTINGS_TAB_VERSION"], L["SETTINGS_SUB_VERSION"])
    local paneW = WIDTH - NAV_W - 36
    local verLine = ver:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    verLine:SetPoint("TOPLEFT", ver, "TOPLEFT", 0, -56)
    verLine:SetText("|cffeeeeeeVoidcoreAdvisor Reborn|r  |cffd9b968" .. tostring(VCA.VERSION) .. "|r")

    local notesTitle = ver:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    notesTitle:SetPoint("TOPLEFT", verLine, "BOTTOMLEFT", 0, -16)
    notesTitle:SetText("|cffd9b968" .. L["VERSION_NOTES_TITLE"] .. "|r")
    local notes = ver:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    notes:SetPoint("TOPLEFT", notesTitle, "BOTTOMLEFT", 0, -6)
    notes:SetWidth(paneW)
    notes:SetJustifyH("LEFT")
    notes:SetJustifyV("TOP")
    notes:SetSpacing(4)
    notes:SetText("|cffdddddd" .. L["VERSION_NOTES"] .. "|r")

    local creditsTitle = ver:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    creditsTitle:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 0, -16)
    creditsTitle:SetText("|cffd9b968" .. L["VERSION_CREDITS_TITLE"] .. "|r")
    local credits = ver:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    credits:SetPoint("TOPLEFT", creditsTitle, "BOTTOMLEFT", 0, -6)
    credits:SetWidth(paneW)
    credits:SetJustifyH("LEFT")
    credits:SetJustifyV("TOP")
    credits:SetSpacing(4)
    credits:SetText("|cffdddddd" .. L["VERSION_CREDITS"] .. "|r")

    -- Addresses you can select and copy (the text cannot be edited)
    local function Link(anchor, labelText, url)
        local label = ver:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        label:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -10)
        label:SetWidth(130)
        label:SetJustifyH("LEFT")
        label:SetWordWrap(false)
        label:SetText("|cff8fa597" .. labelText .. "|r")
        local box = CreateFrame("EditBox", nil, ver, "BackdropTemplate")
        box:SetSize(paneW - 138, 20)
        box:SetPoint("LEFT", label, "RIGHT", 8, 0)
        box:SetBackdrop(FLAT)
        box:SetBackdropColor(0.02, 0.06, 0.04, 1)
        box:SetBackdropBorderColor(0.16, 0.35, 0.25, 1)
        box:SetFontObject("ChatFontSmall")
        box:SetTextInsets(6, 6, 0, 0)
        box:SetAutoFocus(false)
        box:SetText(url)
        box:SetCursorPosition(0)
        box:SetScript("OnTextChanged", function(self, user)
            if user then
                self:SetText(url)
                self:SetCursorPosition(0)
            end
        end)
        box:SetScript("OnEditFocusGained", function(self)
            self:HighlightText()
        end)
        box:SetScript("OnEscapePressed", function(self)
            self:ClearFocus()
        end)
        return label
    end
    Link(credits, L["VERSION_LINK_CURSE"], "https://www.curseforge.com/wow/addons/voidcoreadvisor-reborn")
    return {general, reminder, roll, tools, ver}
end

local TAB_ICONS = {
    "Interface\\Icons\\INV_Misc_Gear_01",
    "Interface\\Icons\\INV_Misc_Bell_01",
    "Interface\\Icons\\INV_Misc_Dice_02",
    "Interface\\Icons\\INV_Misc_Book_09",
    "Interface\\Icons\\INV_Scroll_03"
}

local function SelectTab(index)
    for i, pane in ipairs(panes) do
        pane:SetShown(i == index)
        tabs[i].selected = i == index
        tabs[i].Paint()
    end
    for _, w in ipairs(widgets) do
        w.Update()
    end
end

local function Build()
    built = true
    frame = CreateFrame("Frame", "VCASettingsFrame", UIParent, "BackdropTemplate")
    frame:SetSize(WIDTH, HEIGHT)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetBackdrop(FLAT)
    frame:Hide()

    -- Title bar
    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetSize(30, 30)
    icon:SetPoint("TOPLEFT", 14, -9)
    icon:SetTexture("Interface\\Icons\\INV_Enchant_VoidSphere")
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    title:SetPoint("LEFT", icon, "RIGHT", 10, 0)
    VCA.OnTheme(function()
        title:SetText(VCA.RebornTitle("VoidcoreAdvisor", VCA.GetPalette("current")))
    end)
    local version = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    version:SetPoint("TOPRIGHT", -46, -22)
    version:SetText("|cff8fa597" .. string.format(L["SETTINGS_VERSION"], tostring(VCA.VERSION)) .. "|r")
    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -4, -4)
    local rule = frame:CreateTexture(nil, "ARTWORK")
    rule:SetHeight(1)
    rule:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -50)
    rule:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -50)

    -- Side tabs
    local navBg = frame:CreateTexture(nil, "BACKGROUND")
    navBg:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -51)
    navBg:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 1, 1)
    navBg:SetWidth(NAV_W)
    local navLine = frame:CreateTexture(nil, "ARTWORK")
    navLine:SetWidth(1)
    navLine:SetPoint("TOPLEFT", frame, "TOPLEFT", NAV_W + 1, -51)
    navLine:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", NAV_W + 1, 1)

    panes = BuildPanes()
    local names = {L["SETTINGS_TAB_GENERAL"], L["SETTINGS_TAB_REMINDER"], L["SETTINGS_TAB_ROLL"],
                   L["SETTINGS_TAB_TOOLS"], L["SETTINGS_TAB_VERSION"]}
    for i, name in ipairs(names) do
        local tab = CreateFrame("Button", nil, frame)
        tab:SetSize(NAV_W - 1, 38)
        tab:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -52 - (i - 1) * 40)
        local bg = tab:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        local edge = tab:CreateTexture(nil, "ARTWORK")
        edge:SetWidth(3)
        edge:SetPoint("TOPLEFT")
        edge:SetPoint("BOTTOMLEFT")
        local ico = tab:CreateTexture(nil, "ARTWORK")
        ico:SetSize(22, 22)
        ico:SetPoint("LEFT", 14, 0)
        ico:SetTexture(TAB_ICONS[i])
        ico:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        local fs = tab:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        fs:SetPoint("LEFT", ico, "RIGHT", 10, 0)
        -- Never wider than the tab: a long name is cut with "..." instead of running into the page.
        fs:SetWidth(NAV_W - 14 - 22 - 10 - 10)
        fs:SetJustifyH("LEFT")
        fs:SetWordWrap(false)
        fs:SetText(name)
        function tab.Paint()
            local a = Accent()
            if tab.selected then
                bg:SetColorTexture(a[1], a[2], a[3], 0.16)
                edge:SetColorTexture(a[1], a[2], a[3], 1)
                fs:SetTextColor(1, 1, 1)
            else
                bg:SetColorTexture(0, 0, 0, 0)
                edge:SetColorTexture(0, 0, 0, 0)
                fs:SetTextColor(0.8, 0.88, 0.83)
            end
        end
        tab:SetScript("OnClick", function()
            SelectTab(i)
        end)
        tab:SetScript("OnEnter", function(self)
            if not self.selected then
                bg:SetColorTexture(1, 1, 1, 0.05)
            end
        end)
        tab:SetScript("OnLeave", function()
            tab.Paint()
        end)
        tabs[i] = tab
    end

    VCA.OnTheme(function()
        local b, e, a = VCA.Theme.bg, VCA.Theme.border, Accent()
        frame:SetBackdropColor(b[1], b[2], b[3], 0.98)
        frame:SetBackdropBorderColor(e[1], e[2], e[3], 1)
        rule:SetColorTexture(e[1], e[2], e[3], 0.7)
        navLine:SetColorTexture(e[1], e[2], e[3], 0.7)
        navBg:SetColorTexture(0, 0, 0, 0.28)
        for _, tab in ipairs(tabs) do
            tab.Paint()
        end
        for _, w in ipairs(widgets) do
            w.Update()
        end
    end)
    SelectTab(1)
end

-- ── Public ────────────────────────────────────────────────────────────────────

-- Escape closes this window like any other, except when it was opened from the game's own
-- Options panel: closing that panel must leave the addon window open.
local function SetEscapeCloses(on)
    for i = #UISpecialFrames, 1, -1 do
        if UISpecialFrames[i] == "VCASettingsFrame" then
            table.remove(UISpecialFrames, i)
        end
    end
    if on then
        tinsert(UISpecialFrames, "VCASettingsFrame")
    end
end

-- index (optional): 1 General, 2 Reminder, 3 Bonus roll, 4 Tools
function SW.Open(index)
    if not built then
        Build()
    end
    SetEscapeCloses(not (SettingsPanel and SettingsPanel:IsShown()))
    SelectTab(tonumber(index) or 1)
    frame:Show()
    frame:Raise()
end

function SW.Toggle()
    if built and frame:IsShown() then
        frame:Hide()
    else
        SW.Open()
    end
end

function SW.Hide()
    if built then
        frame:Hide()
    end
end
