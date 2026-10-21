-- VoidcoreAdvisor: Panel
-- The side panel frame.  Anchors to the right edge of EncounterJournal and
-- shows context for the currently-viewed boss or dungeon.
--
-- Layout:
--   ┌────────────────────────────────────────────────────┐
--   │  VoidcoreAdvisor                               [X] │  header
--   │  <source name>                                     │
--   │  Raid Boss  •  2 Nebulous Voidcores                │
--   ├─────────────────────┬──────────────────────────────┤  divider
--   │ LOOT                │ SPEC RANKING                 │  column headers
--   │ ┌──┐ [Item name]  □ │ #1 [icon] SpecName  3/8 37% │
--   │ ┌──┐ [Item name]  □ │ #2 [icon] SpecName  5/8 37% │  rows
--   │ ...                 │ ...                          │
--   └─────────────────────┴──────────────────────────────┘
local _, VCA = ...
local L = VCA.L

VCA.Panel = {}
local Panel = VCA.Panel

-- ── Internal state shared with PanelColumns.lua ───────────────────────────────
-- PanelColumns.lua (loaded after this file) accesses these via Panel._s.
-- Never reassign the tables themselves; use wipe() to clear them.
local _s = {}
Panel._s = _s

-- Selection state
_s.selectedItemIDs = {}
local selectedItemIDs = _s.selectedItemIDs -- local alias for this file's closures
_s.selectedSpecIDs = {}
local selectedSpecIDs = _s.selectedSpecIDs -- local alias for this file's closures

-- ── Sizing ────────────────────────────────────────────────────────────────────

local PANEL_WIDTH = 600
local HEADER_H = 76 -- title + source label + info label + divider
local COL_HEADER_H = 20 -- "LOOT" / "SPEC RANKING" label row
local PADDING = 12 -- inner horizontal padding
local ROW_H = 26 -- height of one item / spec row
local ICON_SIZE = 20 -- inline icon size in rows
local COL_SPLIT = 0.52 -- left column fraction of content width

-- ── Main frame ────────────────────────────────────────────────────────────────

local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
Panel.frame = frame

frame:SetWidth(PANEL_WIDTH)
frame:SetFrameStrata("HIGH")
frame:SetClampedToScreen(true)
frame:Hide()

frame:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1,
    insets = {
        left = 1,
        right = 1,
        top = 1,
        bottom = 1
    }
})
VCA.OnTheme(function() local t = VCA.Theme.bg; frame:SetBackdropColor(t[1], t[2], t[3], 0.97) end) -- dark venom green glass
VCA.OnTheme(function() local t = VCA.Theme.border; frame:SetBackdropBorderColor(t[1], t[2], t[3], 1) end)

-- Gold corner brackets (top-left and bottom-right), like the stock frames.
local function CornerBracket(point, dx, dy)
    local h = frame:CreateTexture(nil, "OVERLAY")
    h:SetColorTexture(0.80, 0.70, 0.48, 1)
    h:SetSize(11, 1)
    h:SetPoint(point, frame, point, dx, dy)
    local v = frame:CreateTexture(nil, "OVERLAY")
    v:SetColorTexture(0.80, 0.70, 0.48, 1)
    v:SetSize(1, 11)
    v:SetPoint(point, frame, point, dx, dy)
end
CornerBracket("TOPLEFT", 0, 0)
CornerBracket("BOTTOMRIGHT", 0, 0)

-- ── Anchor helper ─────────────────────────────────────────────────────────────

-- Positions the panel flush against the right edge of EncounterJournal.
-- Safe to call multiple times (ClearAllPoints before re-anchoring).
local function GetPlacement()
    local gdb = _G[VCA.GLOBAL_DB_NAME]
    return gdb and gdb.panelPlacement
end

local function ApplyPlacement(p)
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", p.x, p.y)
    frame:SetSize(p.w, p.h)
end

-- Freezes the current position and size so the panel can be moved or resized freely.
local function Freeze()
    local x, y = frame:GetLeft(), frame:GetTop()
    if not (x and y) then
        return nil
    end
    local p = {x = x, y = y, w = frame:GetWidth(), h = frame:GetHeight()}
    ApplyPlacement(p)
    return p
end

local function SavePlacement()
    local gdb = _G[VCA.GLOBAL_DB_NAME]
    local x, y = frame:GetLeft(), frame:GetTop()
    if gdb and x and y then
        gdb.panelPlacement = {x = x, y = y, w = frame:GetWidth(), h = frame:GetHeight()}
    end
end

function Panel.AnchorToEJ()
    local ej = EncounterJournal
    if not ej then
        return
    end
    local placement = GetPlacement()
    if placement then
        ApplyPlacement(placement)
        return
    end
    frame:SetWidth(PANEL_WIDTH)
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", ej, "TOPRIGHT", 52, 0)
    frame:SetPoint("BOTTOMLEFT", ej, "BOTTOMRIGHT", 52, 0)
end

-- ── Header widgets ────────────────────────────────────────────────────────────

-- Title
local titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
titleText:SetPoint("TOPLEFT", 18, -16)
VCA.OnTheme(function() titleText:SetText(VCA.TitleText()) end)

-- X close button (uses the standard Blizzard close button template)
local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -4, -4)
closeBtn:SetScript("OnClick", function()
    Panel.SetMinimized(true)
    frame:Hide()
end)

-- Persist item selections when the panel hides (close, navigate away, logout).
frame:SetScript("OnHide", function()
    Panel.SaveItemSelections()
end)

-- Source name (boss or dungeon)
local sourceLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
sourceLabel:SetPoint("TOPLEFT", 18, -42)
sourceLabel:SetPoint("TOPRIGHT", -40, -42)
sourceLabel:SetJustifyH("LEFT")
sourceLabel:SetWordWrap(false)
sourceLabel:SetText("")
Panel.sourceLabel = sourceLabel

-- Content type + Voidcore cost
local infoLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
infoLabel:SetPoint("TOPLEFT", 18, -60)
infoLabel:SetJustifyH("LEFT")
infoLabel:SetText("")
Panel.infoLabel = infoLabel

-- Horizontal divider
local divider = frame:CreateTexture(nil, "ARTWORK")
divider:SetColorTexture(0.16, 0.25, 0.18, 1)
divider:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -HEADER_H)
divider:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -16, -HEADER_H)
divider:SetHeight(1)

-- ── Content area ─────────────────────────────────────────────────────────────
-- Two side-by-side columns below the divider.

local contentArea = CreateFrame("Frame", nil, frame)
contentArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -(HEADER_H + 1))
contentArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 11)
Panel.contentArea = contentArea

-- ── Column widths ─────────────────────────────────────────────────────────────

-- Recomputed each Refresh so dynamic resizing (future) is easy.
local function ContentWidth()
    return frame:GetWidth() - PADDING * 2
end

local function LeftColWidth()
    return math.floor(ContentWidth() * COL_SPLIT)
end

local function RightColWidth()
    return ContentWidth() - LeftColWidth() - 1 -- 1px for the vertical separator
end

_s.LeftColWidth = LeftColWidth
_s.RightColWidth = RightColWidth

-- ── Column header labels ──────────────────────────────────────────────────────

local lootColHeader = contentArea:CreateFontString(nil, "OVERLAY", "GameFontNormal")
lootColHeader:SetPoint("TOPLEFT", contentArea, "TOPLEFT", PADDING, -6)
lootColHeader:SetJustifyH("LEFT")
VCA.OnTheme(function() lootColHeader:SetText(VCA.Theme.hdr .. "LOOT|r") end)

-- X button to clear all spec selections (near the center divider in loot column header)
local clearSpecBtn = CreateFrame("Button", nil, contentArea)
clearSpecBtn:SetSize(14, 14)
clearSpecBtn:SetNormalFontObject("GameFontNormal")
clearSpecBtn:SetText("|cffff4444x|r")
clearSpecBtn:SetScript("OnClick", function()
    wipe(selectedSpecIDs)
    wipe(selectedItemIDs)
    Panel.SaveItemSelections()
    Panel.RefreshSpecColumn()
    Panel.RefreshItemColumn()
end)
clearSpecBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(L["CLEAR_SELECTED"])
    GameTooltip:Show()
end)
clearSpecBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
clearSpecBtn:Hide()

-- ── Key level dropdown (M+ only) ─────────────────────────────────────────────
local selectedKeyLevel = 10 -- default to 10+

local keyLevelButton = CreateFrame("Button", nil, contentArea)
keyLevelButton:SetSize(50, 16)
keyLevelButton:SetPoint("LEFT", lootColHeader, "RIGHT", 6, 0)
keyLevelButton:Hide()

local keyLevelText = keyLevelButton:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
keyLevelText:SetAllPoints(keyLevelButton)
keyLevelText:SetJustifyH("LEFT")

local function GetKeyLevelLabel(level)
    return "+" .. level
end

local function GetRewardForKeyLevel(level)
    return VCA.MythicPlusVaultRewards[math.min(level, 10)]
end

_s.GetRewardForKeyLevel = GetRewardForKeyLevel
_s.getSelectedKeyLevel = function()
    return selectedKeyLevel
end

local function UpdateKeyLevelText()
    local reward = GetRewardForKeyLevel(selectedKeyLevel)
    local track = reward and reward.track or "?"
    keyLevelText:SetText("|cffdddddd" .. GetKeyLevelLabel(selectedKeyLevel) .. "|r |cff888888(" .. track .. ")|r")
    -- Resize button to fit text
    keyLevelButton:SetWidth(keyLevelText:GetStringWidth() + 8)
end

local keyLevelMenu = CreateFrame("Frame", nil, keyLevelButton, "BackdropTemplate")
keyLevelMenu:SetFrameStrata("TOOLTIP")
keyLevelMenu:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 12,
    insets = {
        left = 3,
        right = 3,
        top = 3,
        bottom = 3
    }
})
VCA.OnTheme(function() local t = VCA.Theme.bg; keyLevelMenu:SetBackdropColor(t[1], t[2], t[3], 0.97) end)
VCA.OnTheme(function() local t = VCA.Theme.border; keyLevelMenu:SetBackdropBorderColor(t[1], t[2], t[3], 1) end)
keyLevelMenu:Hide()

local keyLevelOptions = {2, 3, 4, 5, 6, 7, 8, 9, 10}
local menuButtons = {}
for i, level in ipairs(keyLevelOptions) do
    local btn = CreateFrame("Button", nil, keyLevelMenu)
    btn:SetSize(70, 16)
    btn:SetPoint("TOPLEFT", keyLevelMenu, "TOPLEFT", 4, -(4 + (i - 1) * 16))
    local label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetAllPoints(btn)
    label:SetJustifyH("LEFT")
    btn.label = label
    btn.level = level

    local highlight = btn:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetAllPoints(btn)
    highlight:SetColorTexture(VCA.Theme.accent[1], VCA.Theme.accent[2], VCA.Theme.accent[3], 0.25)

    btn:SetScript("OnClick", function(self)
        selectedKeyLevel = self.level
        UpdateKeyLevelText()
        keyLevelMenu:Hide()
        Panel.Refresh()
    end)
    menuButtons[i] = btn
end
keyLevelMenu:SetSize(78, 8 + #keyLevelOptions * 16)

local function ShowKeyLevelMenu()
    for i, btn in ipairs(menuButtons) do
        local level = btn.level
        local reward = GetRewardForKeyLevel(level)
        local track = reward and reward.track or "?"
        local lbl = GetKeyLevelLabel(level) .. "  |cff888888" .. track .. "|r"
        if level == selectedKeyLevel then
            lbl = "|cffffff00" .. lbl .. "|r"
        end
        btn.label:SetText(lbl)
    end
    keyLevelMenu:ClearAllPoints()
    keyLevelMenu:SetPoint("TOPLEFT", keyLevelButton, "BOTTOMLEFT", 0, -2)
    keyLevelMenu:Show()
end

keyLevelButton:SetScript("OnClick", function()
    if keyLevelMenu:IsShown() then
        keyLevelMenu:Hide()
    else
        ShowKeyLevelMenu()
    end
end)

-- Close menu when clicking elsewhere
keyLevelMenu:SetScript("OnShow", function(self)
    self:SetPropagateKeyboardInput(true)
end)
keyLevelMenu:SetScript("OnKeyDown", function(self, key)
    if key == "ESCAPE" then
        self:Hide()
        self:SetPropagateKeyboardInput(false)
    else
        self:SetPropagateKeyboardInput(true)
    end
end)

local specColHeader = contentArea:CreateFontString(nil, "OVERLAY", "GameFontNormal")
specColHeader:SetJustifyH("LEFT")
VCA.OnTheme(function() specColHeader:SetText(VCA.Theme.hdr .. "" .. L["COL_SPEC_RANKING"] .. "|r") end)

-- X button to clear all item selections (near the center divider in spec column header)
local clearItemBtn = CreateFrame("Button", nil, contentArea)
clearItemBtn:SetSize(14, 14)
clearItemBtn:SetNormalFontObject("GameFontNormal")
clearItemBtn:SetText("|cffff4444x|r")
clearItemBtn:SetScript("OnClick", function()
    wipe(selectedItemIDs)
    Panel.SaveItemSelections()
    Panel.RefreshSpecColumn()
    Panel.RefreshItemColumn()
end)
clearItemBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(L["CLEAR_SELECTED"])
    GameTooltip:Show()
end)
clearItemBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
clearItemBtn:Hide()

-- Mark-roll mode: while active, clicking a loot row marks (or unmarks) the item
-- as obtained for every spec, for rolls the addon did not track.
Panel.markMode = false
-- Bar fixed to the bottom of the loot column, so it never collides with the
-- key level selector that sits next to the "LOOT" title on Mythic+ sources.
local MARK_BAR_H = 24
local markModeBtn = CreateFrame("Button", nil, contentArea, "BackdropTemplate")
markModeBtn:SetHeight(MARK_BAR_H)
markModeBtn:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1
})
markModeBtn:SetBackdropBorderColor(0, 0, 0, 1)
local markModeText = markModeBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
markModeText:SetPoint("CENTER")
markModeBtn.text = markModeText
local markShine = markModeBtn:CreateTexture(nil, "ARTWORK")
markShine:SetPoint("TOPLEFT", markModeBtn, "TOPLEFT", 1, -1)
markShine:SetPoint("TOPRIGHT", markModeBtn, "TOPRIGHT", -1, -1)
markShine:SetHeight(1)
markShine:SetColorTexture(1, 1, 1, 0.28)
local markHover = markModeBtn:CreateTexture(nil, "HIGHLIGHT")
markHover:SetAllPoints()
markHover:SetColorTexture(1, 1, 1, 0.12)
local function UpdateMarkModeButton()
    if Panel.markMode then
        markModeBtn:SetBackdropColor(0.45, 0.35, 0.05, 1)
        markModeText:SetText("|cffffe9a3" .. L["MARK_MODE_ACTIVE"] .. "|r")
    else
        markModeBtn:SetBackdropColor(0.14, 0.42, 0.16, 1)
        markModeText:SetText("+ " .. L["MARK_MODE_BUTTON"])
    end
end
markModeBtn:SetScript("OnClick", function()
    Panel.markMode = not Panel.markMode
    Panel.lastMarkItemID = nil
    UpdateMarkModeButton()
end)
markModeBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(L["MARK_MODE_BUTTON"], 1, 1, 1)
    GameTooltip:AddLine(L["MARK_MODE_TIP"], nil, nil, nil, true)
    GameTooltip:AddLine(L["MARK_MODE_SHIFT_TIP"], 0.9, 0.8, 0.4, true)
    GameTooltip:Show()
end)
markModeBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
markModeBtn:Hide()
UpdateMarkModeButton()

local lootSpecLabel = contentArea:CreateFontString(nil, "OVERLAY", "GameFontNormal")
lootSpecLabel:SetJustifyH("RIGHT")
lootSpecLabel:SetText("")

-- ── Voidcache icon button (spec column header, right of loot spec label) ──────
-- EJ difficulty → SetItemByID item-context argument
local _raidDiffToContext = {
    [VCA.Difficulty.RAID_NORMAL] = 3,
    [VCA.Difficulty.RAID_LFR] = 4,
    [VCA.Difficulty.RAID_HEROIC] = 5,
    [VCA.Difficulty.RAID_MYTHIC] = 6
}
-- Currently displayed voidcache item ID; kept in sync by Refresh / ClearContext.
local _currentVoidcacheID = nil

local voidcacheIconBtn = CreateFrame("Button", nil, contentArea)
voidcacheIconBtn:SetSize(16, 16)
voidcacheIconBtn:Hide()

local voidcacheIconTex = voidcacheIconBtn:CreateTexture(nil, "ARTWORK")
voidcacheIconTex:SetAllPoints(voidcacheIconBtn)
voidcacheIconTex:SetTexCoord(0.08, 0.92, 0.08, 0.92)

local voidcacheIconHL = voidcacheIconBtn:CreateTexture(nil, "HIGHLIGHT")
voidcacheIconHL:SetAllPoints(voidcacheIconBtn)
voidcacheIconHL:SetColorTexture(1, 1, 1, 0.25)

local function ShowVoidcacheTooltip(owner)
    if not _currentVoidcacheID then
        return
    end
    GameTooltip:SetOwner(owner, "ANCHOR_LEFT")
    if Panel.sourceType == VCA.ContentType.MYTHIC_PLUS then
        GameTooltip:SetItemByID(_currentVoidcacheID, nil, 16, selectedKeyLevel)
    elseif Panel.sourceType == VCA.ContentType.RAID then
        local ctx = _raidDiffToContext[Panel.difficultyID]
        if ctx then
            GameTooltip:SetItemByID(_currentVoidcacheID, nil, ctx)
        else
            GameTooltip:SetItemByID(_currentVoidcacheID)
        end
    end
    GameTooltip:Show()
end

voidcacheIconBtn:SetScript("OnEnter", function(self)
    ShowVoidcacheTooltip(self)
end)
voidcacheIconBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

-- Vertical separator between columns
local colSep = contentArea:CreateTexture(nil, "ARTWORK")

-- Expose column header widgets for PanelColumns.lua
_s.lootColHeader = lootColHeader
_s.clearSpecBtn = clearSpecBtn
_s.specColHeader = specColHeader
_s.clearItemBtn = clearItemBtn
colSep:SetColorTexture(0.16, 0.25, 0.18, 1)
colSep:SetWidth(1)

-- Horizontal rule below column headers
local colHeaderRule = contentArea:CreateTexture(nil, "ARTWORK")
colHeaderRule:SetColorTexture(0.4, 0.4, 0.4, 0.3)
colHeaderRule:SetPoint("TOPLEFT", contentArea, "TOPLEFT", PADDING, -(COL_HEADER_H + 2))
colHeaderRule:SetPoint("TOPRIGHT", contentArea, "TOPRIGHT", -PADDING, -(COL_HEADER_H + 2))
colHeaderRule:SetHeight(1)

-- ── Item quality color escape sequence ───────────────────────────────────────
-- Uses |cnIQn: syntax (added in 11.1.5).

local function QualityColor(quality)
    return "|cnIQ" .. (quality or 1) .. ":"
end

_s.QualityColor = QualityColor

-- ── Tooltip: M+ bonus ID injection ──────────────────────────────────────────
-- Builds a modified item hyperlink string with bonus IDs matching the
-- selected key level so the tooltip renders at the correct item level.

local function BuildMythicPlusTooltipLink(itemLink)
    local reward = GetRewardForKeyLevel(selectedKeyLevel)
    if not reward then
        return nil
    end

    local itemString = itemLink:match("item[%-?%d:]+")
    if not itemString then
        return nil
    end

    local fields = {}
    for field in (itemString .. ":"):gmatch("([^:]*):") do
        fields[#fields + 1] = field
    end
    -- Ensure at least 14 fields (up to numBonusIDs position)
    while #fields < 14 do
        fields[#fields + 1] = ""
    end
    -- Field 13 = context (35 = M+ context)
    fields[13] = "35"

    local numBonuses = tonumber(fields[14]) or 0
    -- Collect existing bonus IDs, stripping 3524 if present
    local newBonuses = {}
    for bi = 15, 14 + numBonuses do
        if fields[bi] ~= "3524" then
            newBonuses[#newBonuses + 1] = fields[bi]
        end
    end

    -- Append the M+ base bonus IDs and the key-level-specific track bonus
    for _, b in ipairs(VCA.MythicPlusBonusIDs) do
        newBonuses[#newBonuses + 1] = tostring(b)
    end
    newBonuses[#newBonuses + 1] = tostring(reward.bonusID)

    -- Remove old bonus entries from fields, insert new ones
    for _ = 1, numBonuses do
        table.remove(fields, 15)
    end
    fields[14] = tostring(#newBonuses)
    for i, b in ipairs(newBonuses) do
        table.insert(fields, 14 + i, b)
    end

    return table.concat(fields, ":")
end

_s.BuildMythicPlusTooltipLink = BuildMythicPlusTooltipLink

-- Tracks the current EJ loot filter so it can be temporarily cleared and
-- restored without depending on a non-existent getter API.
local _ejFilterClassID = 0
local _ejFilterSpecID = 0
hooksecurefunc("EJ_SetLootFilter", function(classID, specID)
    if VCA.LootPool._reentryGuard then
        return
    end
    _ejFilterClassID = classID or 0
    _ejFilterSpecID = specID or 0
end)

-- Returns the item link for a raid item directly from the EJ so the tooltip
-- shows the correct difficulty item level. Temporarily clears the loot filter
-- so all items are visible regardless of the current spec filter, then restores
-- the filter to the player's loot spec.
--
-- _ejFilterClassID/_ejFilterSpecID track explicit EJ_SetLootFilter calls.
-- Blizzard sets the EJ filter internally when the journal opens without calling
-- EJ_SetLootFilter, so those values start at 0/0. When they are 0/0 we seed
-- the restore target from the player's actual class and loot spec so we don't
-- accidentally leave the EJ showing "All Specializations".
local function GetRaidEJItemLink(itemID)
    if not C_EncounterJournal or not C_EncounterJournal.GetLootInfoByIndex then
        return nil
    end
    local savedClass = _ejFilterClassID
    local savedSpec = _ejFilterSpecID
    if savedClass == 0 and savedSpec == 0 then
        savedClass = VCA.SpecInfo.GetPlayerClassID() or 0
        savedSpec = VCA.SpecInfo.GetEffectiveLootSpecID() or 0
    end
    VCA.LootPool._reentryGuard = true
    EJ_SetLootFilter(0, 0)
    local numLoot = EJ_GetNumLoot and EJ_GetNumLoot() or 0
    local result = nil
    for i = 1, numLoot do
        local info = C_EncounterJournal.GetLootInfoByIndex(i)
        if info and info.itemID == itemID and info.link and info.link ~= "" then
            result = info.link
            break
        end
    end
    -- Update tracking before restoring so the next call remembers the spec.
    _ejFilterClassID = savedClass
    _ejFilterSpecID = savedSpec
    EJ_SetLootFilter(savedClass, savedSpec)
    VCA.LootPool._reentryGuard = false
    return result
end

-- Builds a raid item link showing the correct Voidcore reward track and ilvl.
-- Keeps linkLevel (f[10]) for correct ilvl; clears specID (f[11]) which suppresses
-- the "Upgrade Level" display when set.
local function BuildRaidTooltipLink(itemLink, difficultyID)
    local info = VCA.RaidVoidcoreTooltip[difficultyID]
    if not info or not itemLink or itemLink == "" then
        return nil
    end

    local itemString = itemLink:match("item[%-?%d:]+")
    if not itemString then
        return nil
    end

    local fields = {}
    for field in (itemString .. ":"):gmatch("([^:]*):") do
        fields[#fields + 1] = field
    end
    while #fields < 14 do
        fields[#fields + 1] = ""
    end

    local numBonuses = tonumber(fields[14]) or 0
    local itemID = tonumber(fields[2])
    local isSpecial = VCA.RaidTooltipExtraBonusItems and VCA.RaidTooltipExtraBonusItems[itemID]

    -- Check for encounter-specific bonus override (keyed by difficulty + encounterID).
    local encounterBonus = VCA.RaidEncounterTooltipBonus and VCA.RaidEncounterTooltipBonus[difficultyID] and
                               VCA.RaidEncounterTooltipBonus[difficultyID][Panel.sourceID]

    fields[11] = "" -- clear loot specID; its presence suppresses the track label
    fields[13] = info.ctx

    -- Build new bonus list: [tag?, 13708 if special+non-mythic, track]
    local newBonuses = {}
    if encounterBonus then
        newBonuses = encounterBonus
    elseif isSpecial and difficultyID == VCA.Difficulty.RAID_MYTHIC then
        -- Special items on Mythic use 3524 (original Mythic tag) instead of 13335.
        newBonuses = {"3524", tostring(info.bonus)}
    else
        if info.tag then
            newBonuses[#newBonuses + 1] = tostring(info.tag)
        end
        if isSpecial then
            newBonuses[#newBonuses + 1] = "13708"
        end
        newBonuses[#newBonuses + 1] = tostring(info.bonus)
    end

    for _ = 1, numBonuses do
        table.remove(fields, 15)
    end
    fields[14] = tostring(#newBonuses)
    for i, b in ipairs(newBonuses) do
        table.insert(fields, 14 + i, b)
    end

    -- Zero numModifiers so source modifier data cannot override the injected rank.
    local numModsPos = 15 + #newBonuses
    if fields[numModsPos] then
        fields[numModsPos] = "0"
    end

    return table.concat(fields, ":")
end

-- ── Tooltip: obtained-spec lines ───────────────────────────────────────────
-- Appends "Obtained as:" spec lines to whatever tooltip is currently open.
-- Called before every GameTooltip:Show() on item icon hover.
local function AppendObtainedSpecLines(rf)
    local specs = rf.checkbox and rf.checkbox.specs
    if not specs or #specs == 0 then
        return
    end
    if not (Panel.sourceType and Panel.sourceID and Panel.difficultyID) then
        return
    end
    local itemID = rf.itemID
    if not itemID then
        return
    end

    local obtainedSpecs = {}
    for _, sp in ipairs(specs) do
        if VCA.Data.IsObtained(Panel.sourceType, Panel.sourceID, Panel.difficultyID, sp.specID, itemID) then
            obtainedSpecs[#obtainedSpecs + 1] = sp
        end
    end
    local migratedObtained = VCA.Data.IsObtainedMigrated(Panel.sourceType, Panel.sourceID, Panel.difficultyID, itemID)
    if #obtainedSpecs == 0 and not migratedObtained then
        return
    end

    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L["SPEC_PICKER_TITLE"], 1, 1, 1)
    for _, sp in ipairs(obtainedSpecs) do
        GameTooltip:AddLine("|T" .. sp.icon .. ":12:12:0:0:64:64:4:60:4:60|t " .. sp.name, 0.4, 1.0, 0.4)
    end
    if migratedObtained then
        GameTooltip:AddLine(L["OBTAINED_UNKNOWN_SPEC"], 1.0, 0.7, 0.1)
    end
end

-- ── Row pool helpers ──────────────────────────────────────────────────────────
-- We maintain two pools of recycled row frames so we never create more widgets
-- than necessary.
-- itemRows and specRows are exposed in Panel._s so PanelColumns.lua can
-- pass them to GetOrCreateItemRow / GetOrCreateSpecRow.
_s.itemRows = {}
local itemRows = _s.itemRows
_s.specRows = {}
local specRows = _s.specRows

local function GetOrCreateItemRow(pool, parent)
    for _, row in ipairs(pool) do
        if not row.frame:IsShown() then
            return row
        end
    end
    -- Create a new row.  Use Button so WoW always delivers mouse events even
    -- when nested inside a ScrollFrame, where plain Frame hit-testing can be
    -- unreliable.
    local rowFrame = CreateFrame("Button", nil, parent)
    rowFrame:SetHeight(ROW_H)
    rowFrame:RegisterForClicks("LeftButtonUp")

    -- Flash texture (used for detection highlight)
    local flash = rowFrame:CreateTexture(nil, "HIGHLIGHT")
    flash:SetAllPoints(rowFrame)
    flash:SetColorTexture(0, 1, 0, 0)

    -- Selection highlight (golden tint when the user clicks the row)
    local selHighlight = rowFrame:CreateTexture(nil, "BACKGROUND")
    selHighlight:SetAllPoints(rowFrame)
    selHighlight:SetColorTexture(1, 0.75, 0, 0)
    selHighlight:Hide()

    local rowBg = rowFrame:CreateTexture(nil, "BACKGROUND", nil, -1)
    rowBg:SetAllPoints(rowFrame)
    rowBg:SetColorTexture(1, 1, 1, 0.04)

    -- Icon housed in its own Button so the tooltip fires only on icon hover.
    local iconButton = CreateFrame("Button", nil, rowFrame)
    iconButton:SetSize(ICON_SIZE, ICON_SIZE)
    iconButton:SetPoint("LEFT", rowFrame, "LEFT", 0, 0)

    local icon = iconButton:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints(iconButton)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) -- trim default icon border

    local iconBorder = iconButton:CreateTexture(nil, "OVERLAY")
    iconBorder:SetTexture("Interface/Common/WhiteIconFrame")
    iconBorder:SetAllPoints(iconButton)
    iconBorder:Hide()

    local nameLabel = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameLabel:SetJustifyH("LEFT")
    nameLabel:SetPoint("LEFT", iconButton, "RIGHT", 4, 0)
    nameLabel:SetPoint("RIGHT", rowFrame, "RIGHT", -20, 0)
    nameLabel:SetWordWrap(false)

    -- Loot icon button — replaces the CheckButton so we can use a bag icon.
    -- SetChecked / GetChecked shims keep PanelColumns.lua compatible.
    local checkbox = CreateFrame("Button", nil, rowFrame)
    checkbox:SetSize(16, 16)
    checkbox:SetPoint("RIGHT", rowFrame, "RIGHT", 0, 0)

    local checkboxTex = checkbox:CreateTexture(nil, "ARTWORK")
    checkboxTex:SetAllPoints(checkbox)
    checkboxTex:SetTexture("Interface\\Icons\\inv_misc_bag_07")
    checkboxTex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    checkbox.tex = checkboxTex

    local checkboxHL = checkbox:CreateTexture(nil, "HIGHLIGHT")
    checkboxHL:SetAllPoints(checkbox)
    checkboxHL:SetColorTexture(1, 1, 1, 0.3)

    checkbox._obtained = false
    function checkbox:SetChecked(v)
        self._obtained = v
        if v == "migrated" then
            -- Amber: obtained but spec unknown (migrated from pre-spec save data).
            self.tex:SetVertexColor(1.0, 0.7, 0.1)
            self.tex:SetAlpha(1)
        elseif v then
            -- Green: obtained with a known spec.
            self.tex:SetVertexColor(0.4, 1.0, 0.4)
            self.tex:SetAlpha(1)
        else
            self.tex:SetVertexColor(1, 1, 1)
            self.tex:SetAlpha(0.30)
        end
    end
    function checkbox:GetChecked()
        return self._obtained
    end
    checkbox:SetChecked(false)

    -- Tooltip on icon hover only
    iconButton:SetScript("OnEnter", function(self)
        local rf = self:GetParent()
        local link = rf.itemLink
        local id = rf.itemID
        if not (link or id) then
            return
        end

        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")

        -- Inject Voidcore reward bonus IDs so the tooltip shows the correct
        -- item level for the Nebulous Voidcore reward track (Myth 1/6).
        if link and link ~= "" then
            local modified
            if Panel.sourceType == VCA.ContentType.MYTHIC_PLUS and rf.itemSlot ~= "" then
                modified = BuildMythicPlusTooltipLink(link)
            elseif Panel.sourceType == VCA.ContentType.RAID then
                modified = BuildRaidTooltipLink(link, Panel.difficultyID)
            end
            if modified then
                local ok = pcall(GameTooltip.SetHyperlink, GameTooltip, modified)
                if ok and GameTooltip:NumLines() and GameTooltip:NumLines() > 0 then
                    AppendObtainedSpecLines(rf)
                    GameTooltip:Show()
                    return
                end
                GameTooltip:ClearLines()
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            end
        end

        if link and link ~= "" then
            GameTooltip:SetHyperlink(link)
        elseif id then
            GameTooltip:SetItemByID(id)
        end
        AppendObtainedSpecLines(rf)
        GameTooltip:Show()
    end)
    iconButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    local row = {
        frame = rowFrame,
        flash = flash,
        selHighlight = selHighlight,
        iconButton = iconButton,
        icon = icon,
        iconBorder = iconBorder,
        nameLabel = nameLabel,
        checkbox = checkbox
    }

    -- Wire the selection click once at creation time so it is never lost when
    -- rows are recycled from the pool.
    rowFrame:SetScript("OnClick", function(self, btn)
        local id = self.itemID
        if not id then
            return
        end
        if Panel.markMode then
            local cb = row.checkbox
            local toggle = cb:GetScript("OnClick")
            if not (toggle and cb.itemID == id) then
                return
            end
            local wantObtained = not cb.isObtained
            local ids = {id}
            if IsShiftKeyDown() and Panel.lastMarkItemID then
                -- Shift+click marks every item between the previous click and this one.
                local from, to
                for i, r in ipairs(pool) do
                    if r.frame:IsShown() then
                        if r.frame.itemID == Panel.lastMarkItemID then
                            from = i
                        end
                        if r == row then
                            to = i
                        end
                    end
                end
                if from and to then
                    ids = {}
                    for i = math.min(from, to), math.max(from, to) do
                        if pool[i].frame:IsShown() and pool[i].frame.itemID then
                            ids[#ids + 1] = pool[i].frame.itemID
                        end
                    end
                end
            end
            -- Each toggle refreshes (and may reorder) the rows, so look rows up by item ID.
            for _, itemID in ipairs(ids) do
                for _, r in ipairs(pool) do
                    local rcb = r.checkbox
                    if r.frame:IsShown() and rcb.itemID == itemID then
                        if (rcb.isObtained and true or false) ~= wantObtained then
                            local rtoggle = rcb:GetScript("OnClick")
                            if rtoggle then
                                rtoggle(rcb)
                            end
                        end
                        break
                    end
                end
            end
            Panel.lastMarkItemID = id
            return
        end
        if self.dimmed then
            return
        end
        -- Toggle: click selects, click again deselects.
        if selectedItemIDs[id] then
            selectedItemIDs[id] = nil
        else
            selectedItemIDs[id] = true
        end
        -- Refresh highlight visuals on all visible rows immediately.
        for _, r in ipairs(pool) do
            if r.frame:IsShown() and r.frame.itemID then
                if selectedItemIDs[r.frame.itemID] then
                    r.selHighlight:SetColorTexture(1, 0.75, 0, 0.18)
                    r.selHighlight:Show()
                else
                    r.selHighlight:Hide()
                end
            end
        end
        Panel.RefreshSpecColumn()
        Panel.RefreshItemColumn()
        Panel.SaveItemSelections()
    end)

    pool[#pool + 1] = row
    return row
end

_s.GetOrCreateItemRow = GetOrCreateItemRow

local function GetOrCreateSpecRow(pool, parent)
    for _, row in ipairs(pool) do
        if not row.frame:IsShown() then
            return row
        end
    end
    local rowFrame = CreateFrame("Button", nil, parent)
    rowFrame:SetHeight(ROW_H)
    rowFrame:RegisterForClicks("LeftButtonUp")

    -- Selection highlight (purple tint when spec is selected)
    local selHighlight = rowFrame:CreateTexture(nil, "BACKGROUND")
    selHighlight:SetAllPoints(rowFrame)
    selHighlight:SetColorTexture(VCA.Theme.accent[1], VCA.Theme.accent[2], VCA.Theme.accent[3], 0)
    selHighlight:Hide()

    local rowLine = rowFrame:CreateTexture(nil, "BORDER")
    rowLine:SetColorTexture(0.12, 0.2, 0.15, 1)
    rowLine:SetHeight(1)
    rowLine:SetPoint("BOTTOMLEFT", rowFrame, "BOTTOMLEFT", 0, 0)
    rowLine:SetPoint("BOTTOMRIGHT", rowFrame, "BOTTOMRIGHT", 0, 0)

    local rankLabel = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rankLabel:SetJustifyH("RIGHT")
    rankLabel:SetWidth(24)
    rankLabel:SetPoint("LEFT", rowFrame, "LEFT", 0, 0)

    local icon = rowFrame:CreateTexture(nil, "ARTWORK")
    icon:SetSize(ICON_SIZE, ICON_SIZE)
    icon:SetPoint("LEFT", rankLabel, "RIGHT", 3, 0)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    local nameLabel = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameLabel:SetJustifyH("LEFT")
    nameLabel:SetPoint("LEFT", icon, "RIGHT", 4, 0)
    nameLabel:SetPoint("RIGHT", rowFrame, "RIGHT", 0, 0)
    nameLabel:SetWordWrap(false)

    -- Invisible hit-area for the warning icon (shown only when remainingCount == 1)
    local warnHitArea = CreateFrame("Button", nil, rowFrame)
    warnHitArea:SetSize(18, ROW_H)
    warnHitArea:SetPoint("LEFT", icon, "RIGHT", 4, 0)
    warnHitArea:SetFrameLevel(rowFrame:GetFrameLevel() + 2)
    warnHitArea:EnableMouse(true)
    warnHitArea:SetScript("OnEnter", function(self)
        if self.tooltipText then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(self.tooltipText, 1, 1, 1, 1, true)
            GameTooltip:Show()
        end
    end)
    warnHitArea:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    warnHitArea:Hide()

    local statsLabel = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    statsLabel:SetJustifyH("RIGHT")
    statsLabel:SetPoint("RIGHT", rowFrame, "RIGHT", 0, 0)

    -- Spec selection click (single-select: selecting a new spec deselects the previous one)
    rowFrame:SetScript("OnClick", function(self, btn)
        local specID = self.specID
        if not specID then
            return
        end
        local wasSelected = selectedSpecIDs[specID]
        wipe(selectedSpecIDs)
        if not wasSelected then
            selectedSpecIDs[specID] = true
        end
        -- Update spec highlight visuals
        for _, r in ipairs(pool) do
            if r.frame:IsShown() and r.frame.specID then
                if selectedSpecIDs[r.frame.specID] then
                    r.selHighlight:SetColorTexture(VCA.Theme.accent[1], VCA.Theme.accent[2], VCA.Theme.accent[3], 0.14)
                    r.selHighlight:Show()
                else
                    r.selHighlight:Hide()
                end
            end
        end
        Panel.RefreshItemColumn()
    end)

    local row = {
        frame = rowFrame,
        selHighlight = selHighlight,
        rankLabel = rankLabel,
        icon = icon,
        nameLabel = nameLabel,
        statsLabel = statsLabel,
        warnHitArea = warnHitArea
    }
    pool[#pool + 1] = row
    return row
end

-- ── Row hide helpers ──────────────────────────────────────────────────────────

_s.GetOrCreateSpecRow = GetOrCreateSpecRow

local function HideAllItemRows()
    for _, row in ipairs(itemRows) do
        row.frame:Hide()
    end
end

local function HideAllSpecRows()
    for _, row in ipairs(specRows) do
        row.frame:Hide()
    end
end

_s.HideAllItemRows = HideAllItemRows
_s.HideAllSpecRows = HideAllSpecRows

-- ── Slot sort order ───────────────────────────────────────────────────────────
-- Maps INVTYPE_* equip-location strings to a numeric sort priority so the item
-- list reads like the character sheet: head first, trinkets last.
-- Finger/Ring and all weapon sub-types are collapsed into single categories.

local SLOT_SORT_ORDER = {
    -- Synthesis tokens (tier set tokens, Nullcores, etc.) have no equip slot;
    -- sort them first to match EJ ordering.
    INVTYPE_NON_EQUIP_IGNORE = 0,
    INVTYPE_HEAD = 1,
    INVTYPE_NECK = 2,
    INVTYPE_SHOULDER = 3,
    INVTYPE_CLOAK = 4,
    INVTYPE_CHEST = 5,
    INVTYPE_ROBE = 5,
    INVTYPE_WRIST = 6,
    INVTYPE_HAND = 7,
    INVTYPE_WAIST = 8,
    INVTYPE_LEGS = 9,
    INVTYPE_FEET = 10,
    INVTYPE_FINGER = 11,
    -- All weapon / off-hand types grouped together
    INVTYPE_WEAPON = 12,
    INVTYPE_2HWEAPON = 12,
    INVTYPE_WEAPONMAINHAND = 12,
    INVTYPE_WEAPONOFFHAND = 12,
    INVTYPE_HOLDABLE = 12,
    INVTYPE_SHIELD = 12,
    INVTYPE_RANGED = 12,
    INVTYPE_RANGEDRIGHT = 12,
    -- Trinkets last
    INVTYPE_TRINKET = 13
}

local function GetSlotSortOrder(itemID)
    if not itemID then
        return 99
    end
    local _, _, _, equipLoc = C_Item.GetItemInfoInstant(itemID)
    if not equipLoc or equipLoc == "" then
        return 99
    end
    return SLOT_SORT_ORDER[equipLoc] or 99
end

_s.GetSlotSortOrder = GetSlotSortOrder

-- ── Populate item column ──────────────────────────────────────────────────────

local itemScrollChild = CreateFrame("Frame", nil, contentArea)
local itemScrollFrame = CreateFrame("ScrollFrame", nil, contentArea)
itemScrollFrame:SetScrollChild(itemScrollChild)

-- Mouse wheel scrolling
itemScrollFrame:EnableMouseWheel(true)
itemScrollFrame:SetScript("OnMouseWheel", function(self, delta)
    local current = self:GetVerticalScroll()
    local maxScroll = math.max(0, itemScrollChild:GetHeight() - self:GetHeight())
    local step = ROW_H * 3
    local newScroll = math.max(0, math.min(maxScroll, current - delta * step))
    self:SetVerticalScroll(newScroll)
end)

-- Thin scrollbar track + thumb
local scrollTrack = itemScrollFrame:CreateTexture(nil, "BACKGROUND")
scrollTrack:SetWidth(4)
scrollTrack:SetColorTexture(0.1, 0.1, 0.1, 0.4)
scrollTrack:SetPoint("TOPRIGHT", itemScrollFrame, "TOPRIGHT", 5, 0)
scrollTrack:SetPoint("BOTTOMRIGHT", itemScrollFrame, "BOTTOMRIGHT", 5, 0)
scrollTrack:Hide()

local scrollThumb = itemScrollFrame:CreateTexture(nil, "OVERLAY")
scrollThumb:SetWidth(4)
scrollThumb:SetColorTexture(0.6, 0.6, 0.6, 0.6)
scrollThumb:Hide()

-- Expose scroll frame widgets and scrollbar for PanelColumns.lua
_s.itemScrollChild = itemScrollChild
_s.itemScrollFrame = itemScrollFrame
_s.scrollTrack = scrollTrack
_s.scrollThumb = scrollThumb

-- UpdateScrollbar is defined in PanelColumns.lua (loaded after this file).
-- The hook body runs at game time when PanelColumns.lua is already loaded.
itemScrollFrame:HookScript("OnMouseWheel", function()
    Panel.UpdateScrollbar()
end)

-- ── Populate spec column ──────────────────────────────────────────────────────

local specScrollChild = CreateFrame("Frame", nil, contentArea)
local specScrollFrame = CreateFrame("ScrollFrame", nil, contentArea)
specScrollFrame:SetScrollChild(specScrollChild)

_s.specScrollChild = specScrollChild
_s.specScrollFrame = specScrollFrame
-- ── Layout pass ───────────────────────────────────────────────────────────────
-- Recalculates all column/scroll frame positions.  Called on Refresh and on
-- frame resize (if we ever make it resizable).

local function DoLayout()
    local contentH = contentArea:GetHeight() - COL_HEADER_H - 10
    local leftW = LeftColWidth()
    local rightW = RightColWidth()
    local splitX = PADDING + leftW

    -- Column separator
    colSep:ClearAllPoints()
    colSep:SetPoint("TOP", contentArea, "TOPLEFT", splitX, -2)
    colSep:SetPoint("BOTTOM", contentArea, "BOTTOMLEFT", splitX, 2)

    -- Clear-spec-selection button (near center divider, inside loot column)
    clearSpecBtn:ClearAllPoints()
    clearSpecBtn:SetPoint("RIGHT", contentArea, "TOPLEFT", splitX - 4, -6 - (COL_HEADER_H / 2) + 4)

    -- Spec column header position (left col header is already anchored)
    specColHeader:ClearAllPoints()
    specColHeader:SetPoint("TOPLEFT", contentArea, "TOPLEFT", splitX + PADDING, -6)

    -- Clear-item-selection button (just left of center divider)
    clearItemBtn:ClearAllPoints()
    clearItemBtn:SetPoint("RIGHT", contentArea, "TOPLEFT", splitX - 22, -6 - (COL_HEADER_H / 2) + 4)

    -- Voidcache icon (at the far right of the spec column header row)
    voidcacheIconBtn:ClearAllPoints()
    voidcacheIconBtn:SetPoint("RIGHT", contentArea, "TOPRIGHT", -PADDING, -6 - (COL_HEADER_H / 2) + 4)

    -- Loot spec label (right-aligned, to the left of the voidcache icon)
    lootSpecLabel:ClearAllPoints()
    lootSpecLabel:SetPoint("RIGHT", voidcacheIconBtn, "LEFT", -4, 0)
    lootSpecLabel:SetPoint("LEFT", specColHeader, "RIGHT", 8, 0)
    lootSpecLabel:SetWordWrap(false)

    -- Item scroll frame
    itemScrollFrame:ClearAllPoints()
    itemScrollFrame:SetPoint("TOPLEFT", contentArea, "TOPLEFT", PADDING, -(COL_HEADER_H + 8))
    itemScrollFrame:SetPoint("BOTTOMLEFT", contentArea, "BOTTOMLEFT", PADDING, MARK_BAR_H + 10)
    itemScrollFrame:SetWidth(leftW - PADDING)

    markModeBtn:ClearAllPoints()
    markModeBtn:SetPoint("BOTTOMLEFT", contentArea, "BOTTOMLEFT", PADDING, 6)
    markModeBtn:SetWidth(leftW - PADDING)

    itemScrollChild:SetWidth(leftW - PADDING)

    -- Spec scroll frame
    specScrollFrame:ClearAllPoints()
    specScrollFrame:SetPoint("TOPLEFT", contentArea, "TOPLEFT", splitX + PADDING, -(COL_HEADER_H + 8))
    specScrollFrame:SetPoint("BOTTOMRIGHT", contentArea, "BOTTOMRIGHT", -PADDING, 4)
    specScrollFrame:SetWidth(rightW - PADDING)

    specScrollChild:SetWidth(rightW - PADDING)
end

-- ── Move and resize ───────────────────────────────────────────────────────────
-- Drag the header to move the panel, drag the corner to resize it. The position
-- and size are remembered; /void resetpanel puts it back next to the journal.

frame:SetMovable(true)
frame:SetResizable(true)
if frame.SetResizeBounds then
    frame:SetResizeBounds(480, 340, 900, 1000)
end

local dragHandle = CreateFrame("Frame", nil, frame)
dragHandle:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
dragHandle:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -30, 0)
dragHandle:SetHeight(HEADER_H)
dragHandle:EnableMouse(true)
dragHandle:RegisterForDrag("LeftButton")
dragHandle:SetScript("OnDragStart", function()
    Freeze()
    frame:StartMoving()
end)
dragHandle:SetScript("OnDragStop", function()
    frame:StopMovingOrSizing()
    SavePlacement()
end)

local grip = CreateFrame("Button", nil, frame)
grip:SetSize(16, 16)
grip:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
grip:SetFrameLevel(frame:GetFrameLevel() + 10)
grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
grip:SetScript("OnMouseDown", function()
    if Freeze() then
        frame:StartSizing("BOTTOMRIGHT")
    end
end)
grip:SetScript("OnMouseUp", function()
    frame:StopMovingOrSizing()
    SavePlacement()
    DoLayout()
    Panel.Refresh()
end)

frame:SetScript("OnSizeChanged", function()
    if frame:IsShown() then
        DoLayout()
    end
end)

function Panel.ResetPlacement()
    local gdb = _G[VCA.GLOBAL_DB_NAME]
    if gdb then
        gdb.panelPlacement = nil
    end
    Panel.AnchorToEJ()
    DoLayout()
    Panel.Refresh()
end

-- ── Context update ────────────────────────────────────────────────────────────

-- Persist the current item selection to the char DB.
function Panel.SaveItemSelections()
    if Panel.sourceType and Panel.sourceID and Panel.difficultyID then
        VCA.Data.SaveSelectedItems(Panel.sourceType, Panel.sourceID, Panel.difficultyID, selectedItemIDs)
    end
end

-- Reload in-memory selectedItemIDs from the DB for the current context.
-- Call this whenever an external system (e.g. slot-drawer) modifies the DB
-- directly so the Panel does not overwrite those changes on the next SetContext.
function Panel.ReloadItemSelections()
    if not (Panel.sourceType and Panel.sourceID and Panel.difficultyID) then
        return
    end
    wipe(selectedItemIDs)
    local saved = VCA.Data.GetSelectedItems(Panel.sourceType, Panel.sourceID, Panel.difficultyID)
    for id in pairs(saved) do
        selectedItemIDs[id] = true
    end
end

function Panel.SetContext(sourceType, sourceID, difficultyID, sourceName, isRaid)
    -- Persist outgoing selections before switching context.
    Panel.SaveItemSelections()

    -- Restore saved item selection for this source (spec selection is transient).
    wipe(selectedItemIDs)
    wipe(selectedSpecIDs)
    local saved = VCA.Data.GetSelectedItems(sourceType, sourceID, difficultyID)
    for id in pairs(saved) do
        selectedItemIDs[id] = true
    end
    HideAllItemRows()
    HideAllSpecRows()

    Panel.sourceType = sourceType
    Panel.sourceID = sourceID
    Panel.difficultyID = difficultyID

    VCA.Detection.SetActiveSource(sourceType, sourceID, difficultyID)

    sourceLabel:SetText(sourceName or "")
    Panel.isRaid = isRaid

    -- Show key level dropdown only for M+ dungeons
    if sourceType == VCA.ContentType.MYTHIC_PLUS then
        UpdateKeyLevelText()
        keyLevelButton:Show()
    else
        keyLevelButton:Hide()
        keyLevelMenu:Hide()
    end

    Panel.Refresh()
end

function Panel.ClearContext()
    Panel.SaveItemSelections()

    VCA.Detection.ClearActiveSource()

    wipe(selectedItemIDs)
    wipe(selectedSpecIDs)
    HideAllItemRows()
    HideAllSpecRows()

    Panel.sourceType = nil
    Panel.sourceID = nil
    Panel.difficultyID = nil
    Panel.isRaid = nil

    sourceLabel:SetText("")
    infoLabel:SetText("")
    lootSpecLabel:SetText("")
    _currentVoidcacheID = nil
    voidcacheIconBtn:Hide()
    lootColHeader:SetText(VCA.Theme.hdr .. "" .. L["COL_LOOT"] .. "|r")
    specColHeader:SetText(VCA.Theme.hdr .. "" .. L["COL_SPEC_RANKING"] .. "|r")
    clearSpecBtn:Hide()
    clearItemBtn:Hide()
    markModeBtn:Hide()
    Panel.markMode = false
    UpdateMarkModeButton()
    keyLevelMenu:Hide()
end

-- ── Refresh ───────────────────────────────────────────────────────────────────

function Panel.Refresh()
    if not frame:IsShown() then
        return
    end
    if not Panel.sourceID then
        return
    end
    markModeBtn:Show()

    -- Update loot spec label
    local lootSpecID = VCA.SpecInfo.GetEffectiveLootSpecID()
    if lootSpecID and lootSpecID > 0 then
        local _, name, _, icon = GetSpecializationInfoByID(lootSpecID)
        if name then
            lootSpecLabel:SetText("|cff888888" .. L["LOOT_SPEC_LABEL"] .. "|r |cffdddddd" .. name .. "|r")
        else
            lootSpecLabel:SetText("")
        end
    else
        lootSpecLabel:SetText("")
    end

    -- Update voidcache icon
    local newVoidcacheID
    if Panel.sourceType == VCA.ContentType.MYTHIC_PLUS then
        newVoidcacheID = VCA.DungeonVoidcacheIDs and VCA.DungeonVoidcacheIDs[Panel.sourceID]
    elseif Panel.sourceType == VCA.ContentType.RAID then
        newVoidcacheID = VCA.RaidEncounterCacheIDs and VCA.RaidEncounterCacheIDs[Panel.sourceID]
    end
    _currentVoidcacheID = newVoidcacheID
    if newVoidcacheID then
        local texture = select(10, C_Item.GetItemInfo(newVoidcacheID))
        if texture then
            voidcacheIconTex:SetTexture(texture)
            voidcacheIconBtn:Show()
        else
            voidcacheIconBtn:Hide()
        end
    else
        voidcacheIconBtn:Hide()
    end

    -- Update info label with voidcore cost; turn red when the player cannot afford it.
    local cost = VCA.Probability.GetVoidcoreCost(Panel.sourceType)
    local contentTag = Panel.isRaid and L["CONTENT_RAID_BOSS"] or L["CONTENT_MP_DUNGEON"]
    local coreWord = cost == 1 and L["NEBULOUS_VOIDCORE"] or L["NEBULOUS_VOIDCORES"]
    local currInfo = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo(VCA.VOIDCORE_CURRENCY_ID)
    local owned = currInfo and currInfo.quantity or 0
    local costColor
    if owned < cost then
        costColor = "|cffff3333" -- red: cannot afford
    elseif cost == 2 then
        costColor = "|cffffff00" -- yellow for raids
    else
        costColor = "|cff00ff00" -- green for M+
    end
    infoLabel:SetText(contentTag .. "  •  " .. costColor .. cost .. " " .. coreWord .. "|r")

    DoLayout()
    Panel.RefreshItemColumn()
    Panel.RefreshSpecColumn()
end

-- ── Detection callback ────────────────────────────────────────────────────────
-- Wired to Detection module: flash the detected item row green, print to chat.

VCA.Detection.SetOnItemDetectedCallback(function(itemID, source)
    -- Chat message
    local itemName = C_Item.GetItemNameByID(itemID) or tostring(itemID)
    print(VCA.Theme.hdr .. "VoidcoreAdvisor Reborn:|r " .. string.format(L["DETECTED_OBTAINED"], "|cnIQ4:" .. itemName .. "|r"))

    -- Remove from saved selections now that it's obtained.
    VCA.Data.RemoveSelectedItem(source.sourceType, source.sourceID, source.difficultyID, itemID)
    selectedItemIDs[itemID] = nil

    -- Flash the item row if panel is open for this source
    if Panel.sourceID == source.sourceID and Panel.sourceType == source.sourceType and Panel.difficultyID ==
        source.difficultyID then
        for _, row in ipairs(itemRows) do
            if row.checkbox.itemID == itemID and row.frame:IsShown() then
                row.flash:SetColorTexture(0, 1, 0, 0.35)
                -- Fade out over ~1.5 s using OnUpdate
                local age = 0
                row.frame:SetScript("OnUpdate", function(self, elapsed)
                    age = age + elapsed
                    local alpha = math.max(0, 0.35 - age * 0.23)
                    row.flash:SetColorTexture(0, 1, 0, alpha)
                    if age >= 1.5 then
                        row.flash:SetColorTexture(0, 1, 0, 0)
                        self:SetScript("OnUpdate", nil)
                    end
                end)
                break
            end
        end
        Panel.Refresh()
    end
end)

-- ── Visibility helpers ────────────────────────────────────────────────────────

function Panel.Show()
    Panel.AnchorToEJ()
    frame:Show()
    Panel.Refresh()
end

function Panel.Hide()
    frame:Hide()
end

function Panel.IsShown()
    return frame:IsShown()
end

function Panel.IsMinimized()
    local db = _G[VCA.CHAR_DB_NAME]
    return db and db.minimized or false
end

function Panel.SetMinimized(val)
    local db = _G[VCA.CHAR_DB_NAME]
    if db then
        db.minimized = val and true or false
    end
end

-- ── Live spec-change / loot-data update ───────────────────────────────────────
-- When the player changes their loot spec setting, or when the EJ finishes
-- loading loot data for a newly selected instance, refresh both columns.

local specChangeFrame = CreateFrame("Frame")
specChangeFrame:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
specChangeFrame:RegisterEvent("EJ_LOOT_DATA_RECIEVED")
specChangeFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
specChangeFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
specChangeFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOOT_SPEC_UPDATED" then
        if _currentVoidcacheID and frame:IsShown() then
            -- Bust the tooltip cache using a different voidcache ID so the next
            -- SetItemByID call fetches fresh spec data (same pattern as BonusRollConfirm).
            if C_TooltipInfo and C_TooltipInfo.GetItemByID then
                local bustID = nil
                for _, id in pairs(VCA.DungeonVoidcacheIDs or {}) do
                    if id ~= _currentVoidcacheID then
                        bustID = id;
                        break
                    end
                end
                if not bustID then
                    for _, id in pairs(VCA.RaidEncounterCacheIDs or {}) do
                        if id ~= _currentVoidcacheID then
                            bustID = id;
                            break
                        end
                    end
                end
                if bustID then
                    C_TooltipInfo.GetItemByID(bustID)
                end
            end
            -- Re-show tooltip immediately if it is already open over the icon.
            if GameTooltip:IsShown() and GameTooltip:GetOwner() == voidcacheIconBtn then
                ShowVoidcacheTooltip(voidcacheIconBtn)
            end
        end
        Panel.Refresh()
    elseif event == "GET_ITEM_INFO_RECEIVED" then
        -- Retry showing the icon if item data arrived after the initial Refresh.
        local itemID = ...
        if itemID == _currentVoidcacheID and frame:IsShown() and not voidcacheIconBtn:IsShown() then
            local texture = select(10, C_Item.GetItemInfo(itemID))
            if texture then
                voidcacheIconTex:SetTexture(texture)
                voidcacheIconBtn:Show()
            end
        end
    else
        Panel.Refresh()
    end
end)

local zoneResetFrame = CreateFrame("Frame")
zoneResetFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
zoneResetFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
zoneResetFrame:SetScript("OnEvent", function()
    Panel.ClearContext()
    Panel.Hide()
end)
