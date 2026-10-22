-- VoidcoreAdvisor Reborn: Missing
-- One list with every item you still need for your loot spec, from all
-- current-season raid bosses and Mythic+ dungeons, best odds first.
-- Opened with /void missing [14|15|16] (raid difficulty, Heroic by default).
local _, VCA = ...
local L = VCA.L

local Missing = {}
VCA.Missing = Missing

local WIDTH, HEIGHT = 540, 470
local ROW_H = 26
local RAID_DIFFICULTIES = {[14] = true, [15] = true, [16] = true}
local raidDifficulty = 15

local frame = CreateFrame("Frame", "VCAMissingFrame", UIParent, "BackdropTemplate")
frame:SetSize(WIDTH, HEIGHT)
frame:SetPoint("CENTER")
frame:SetFrameStrata("HIGH")
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
tinsert(UISpecialFrames, "VCAMissingFrame")

local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -14)
VCA.OnTheme(function()
    title:SetText(VCA.Theme.title .. L["MISSING_TITLE"] .. "|r")
end)

local subtitle = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
subtitle:SetJustifyH("LEFT")

local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -4, -4)

local divider = frame:CreateTexture(nil, "ARTWORK")
divider:SetHeight(1)
divider:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, -56)
divider:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -12, -56)
VCA.OnTheme(function()
    local e = VCA.Theme.border
    divider:SetColorTexture(e[1], e[2], e[3], 0.5)
end)

local scroll = CreateFrame("ScrollFrame", "VCAMissingScroll", frame, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, -62)
scroll:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 10)
local child = CreateFrame("Frame", nil, scroll)
child:SetSize(WIDTH - 50, 10)
scroll:SetScrollChild(child)

local emptyText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
emptyText:SetPoint("CENTER", 0, -10)
emptyText:SetText(L["MISSING_EMPTY"])
emptyText:Hide()

local rows = {}

local function GetRow(i)
    local row = rows[i]
    if row then
        return row
    end
    row = CreateFrame("Frame", nil, child)
    row:SetHeight(ROW_H - 2)
    row:SetPoint("TOPLEFT", child, "TOPLEFT", 0, -(i - 1) * ROW_H)
    row:SetPoint("TOPRIGHT", child, "TOPRIGHT", 0, -(i - 1) * ROW_H)
    row:EnableMouse(true)
    row.bg = row:CreateTexture(nil, "BACKGROUND")
    row.bg:SetAllPoints()
    row.bg:SetColorTexture(1, 1, 1, 0.04)
    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(20, 20)
    row.icon:SetPoint("LEFT", 3, 0)
    row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    row.chance = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    row.chance:SetPoint("RIGHT", -8, 0)
    row.chance:SetWidth(52)
    row.chance:SetJustifyH("RIGHT")
    row.source = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.source:SetPoint("RIGHT", row.chance, "LEFT", -8, 0)
    row.source:SetWidth(150)
    row.source:SetJustifyH("RIGHT")
    row.source:SetWordWrap(false)
    row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    row.name:SetPoint("LEFT", row.icon, "RIGHT", 6, 0)
    row.name:SetPoint("RIGHT", row.source, "LEFT", -6, 0)
    row.name:SetJustifyH("LEFT")
    row.name:SetWordWrap(false)
    row:SetScript("OnEnter", function(self)
        if self.itemID then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetItemByID(self.itemID)
            GameTooltip:Show()
        end
    end)
    row:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    rows[i] = row
    return row
end

-- Builds the list of { itemID, source, chance } for the current loot spec.
local function BuildEntries()
    local entries = {}
    local sd = VCA.SeasonData
    local classID = VCA.SpecInfo.GetPlayerClassID()
    local specID = VCA.SpecInfo.GetEffectiveLootSpecID()
    if not (sd and classID and specID) then
        return entries, specID
    end

    local function AddSource(sourceType, sourceID, difficultyID, sourceName)
        local pool = VCA.LootPool.GetItemsForSpec(sourceType, sourceID, difficultyID, classID, specID) or {}
        local missing = {}
        for _, itemID in ipairs(pool) do
            if not VCA.Data.IsObtainedForKeyTier(sourceType, sourceID, difficultyID, specID, itemID, nil) then
                missing[#missing + 1] = itemID
            end
        end
        for _, itemID in ipairs(missing) do
            entries[#entries + 1] = {
                itemID = itemID,
                source = sourceName,
                chance = 1 / #missing
            }
        end
    end

    for encounterID in pairs(sd.raids or {}) do
        local name = EJ_GetEncounterInfo(encounterID)
        AddSource(VCA.ContentType.RAID, encounterID, raidDifficulty, name or ("#" .. encounterID))
    end
    for instanceID in pairs(sd.dungeons or {}) do
        local name = EJ_GetInstanceInfo(instanceID)
        AddSource(VCA.ContentType.MYTHIC_PLUS, instanceID, VCA.MythicPlusEJDifficulty, name or ("#" .. instanceID))
    end

    table.sort(entries, function(a, b)
        if a.chance ~= b.chance then
            return a.chance > b.chance
        end
        if a.source ~= b.source then
            return a.source < b.source
        end
        return a.itemID < b.itemID
    end)
    return entries, specID
end

function Missing.Refresh()
    local entries, specID = BuildEntries()
    local specName = specID and select(2, GetSpecializationInfoByID(specID)) or "?"
    local diffName = L["DIFFICULTY_" .. ({[14] = "NORMAL", [15] = "HEROIC", [16] = "MYTHIC"})[raidDifficulty]] or ""
    subtitle:SetText(string.format("%s  \226\128\162  %s  \226\128\162  %d", specName, diffName, #entries))

    for i, entry in ipairs(entries) do
        local row = GetRow(i)
        row.itemID = entry.itemID
        local name, link = C_Item.GetItemInfo(entry.itemID)
        if not name and C_Item.RequestLoadItemDataByID then
            C_Item.RequestLoadItemDataByID(entry.itemID)
        end
        row.icon:SetTexture(C_Item.GetItemIconByID(entry.itemID) or "Interface\\Icons\\INV_Misc_QuestionMark")
        row.name:SetText(link or name or ("Item " .. entry.itemID))
        row.source:SetText("|cffb8b8c0" .. entry.source .. "|r")
        row.chance:SetText(string.format("%.0f%%", entry.chance * 100))
        row:Show()
    end
    for i = #entries + 1, #rows do
        rows[i]:Hide()
    end
    child:SetHeight(math.max(10, #entries * ROW_H))
    emptyText:SetShown(#entries == 0)
end

-- Only listens for item data while the list is open.
frame:SetScript("OnShow", function(self)
    self:RegisterEvent("GET_ITEM_INFO_RECEIVED")
end)
frame:SetScript("OnHide", function(self)
    self:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
end)
local pendingRefresh = false
frame:SetScript("OnEvent", function()
    if frame:IsShown() and not pendingRefresh then
        pendingRefresh = true
        C_Timer.After(0.5, function()
            pendingRefresh = false
            if frame:IsShown() then
                Missing.Refresh()
            end
        end)
    end
end)

-- difficulty: optional raid difficulty (14 Normal, 15 Heroic, 16 Mythic).
function Missing.Show(difficulty)
    difficulty = tonumber(difficulty)
    if difficulty and RAID_DIFFICULTIES[difficulty] then
        raidDifficulty = difficulty
    end
    Missing.Refresh()
    frame:Show()
end
