-- VoidcoreAdvisor: Reminder
-- Popup shown when entering a current-season mythic dungeon if the player's
-- loot spec is not the best match for their selected items.
--
-- Trigger:
--   PLAYER_ENTERING_WORLD fires after each loading screen.  After a short
--   delay (to let instance data settle), the module checks whether:
--     1. The player is inside a current-season M+ dungeon (difficultyID 8 or 23).
--     2. The player has items selected for this dungeon.
--     3. A different loot spec gives better odds for those selected items.
--   If all three conditions are met, a dialog-style popup is shown offering
--   to change the loot specialization.
local _, VCA = ...
local L = VCA.L

VCA.Reminder = {}
local Reminder = VCA.Reminder

-- ── State ─────────────────────────────────────────────────────────────────────

local lastShownInstanceID = nil -- prevents re-showing for the same dungeon
local pendingSpecID = nil -- specID to switch to if user clicks "Yes"

local function RankCurrentPlayerSpecsForItemsCached(itemIDs, sourceType, sourceID, difficultyID)
    local specs = VCA.SpecInfo.GetPlayerSpecs()
    local selectedSet = {}
    for _, id in ipairs(itemIDs) do
        selectedSet[id] = true
    end

    local results = {}
    for _, spec in ipairs(specs) do
        local allSpecItemIDs = VCA.LootPool.GetCachedItemsForSpec(sourceType, sourceID, difficultyID, spec.classID,
            spec.specID)
        if not allSpecItemIDs then
            -- Cache not yet warm (e.g. logged in inside an instance); compute on demand.
            allSpecItemIDs = VCA.LootPool.GetItemsForSpec(sourceType, sourceID, difficultyID, spec.classID, spec.specID)
        end

        local matchCount = 0
        local remainingCount = 0
        local matchRemainingCount = 0
        for _, itemID in ipairs(allSpecItemIDs) do
            if selectedSet[itemID] then
                matchCount = matchCount + 1
            end
            if not VCA.Data.IsObtained(sourceType, sourceID, difficultyID, spec.specID, itemID) then
                remainingCount = remainingCount + 1
                if selectedSet[itemID] then
                    matchRemainingCount = matchRemainingCount + 1
                end
            end
        end

        local selectedCount = #itemIDs
        results[#results + 1] = {
            specID = spec.specID,
            specName = spec.name,
            specIcon = spec.icon,
            specRole = spec.role,
            specIndex = spec.specIndex,
            baseCount = #allSpecItemIDs,
            remainingCount = remainingCount,
            matchCount = matchCount,
            matchRemainingCount = matchRemainingCount,
            selectedOdds = remainingCount > 0 and (matchRemainingCount / remainingCount) or 0,
            allObtained = #allSpecItemIDs > 0 and remainingCount == 0,
            noItems = matchCount < selectedCount
        }
    end

    table.sort(results, function(a, b)
        if a.noItems ~= b.noItems then
            return not a.noItems
        end
        if a.allObtained ~= b.allObtained then
            return not a.allObtained
        end
        if a.remainingCount ~= b.remainingCount then
            return a.remainingCount < b.remainingCount
        end
        if a.baseCount ~= b.baseCount then
            return a.baseCount < b.baseCount
        end
        return a.specID < b.specID
    end)

    return results
end

-- ── Main frame ────────────────────────────────────────────────────────────────

local frame = CreateFrame("Frame", "VoidcoreAdvisorReminder", UIParent, "BackdropTemplate")
frame:SetSize(360, 290)
frame:SetPoint("CENTER")
frame:SetFrameStrata("DIALOG")
frame:SetClampedToScreen(true)
frame:EnableMouse(true)
frame:Hide()

frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = {
        left = 11,
        right = 12,
        top = 12,
        bottom = 11
    }
})
VCA.OnTheme(function() local t = VCA.Theme.bg; frame:SetBackdropColor(t[1], t[2], t[3], 0.95) end)
VCA.OnTheme(function() local t = VCA.Theme.border; frame:SetBackdropBorderColor(t[1], t[2], t[3], 1) end)

-- ESC key closes the popup via the global UISpecialFrames mechanism.
tinsert(UISpecialFrames, "VoidcoreAdvisorReminder")

-- ── Title ─────────────────────────────────────────────────────────────────────

local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -14)
title:SetText(L["REMINDER_TITLE"])

local subtitle = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
subtitle:SetPoint("TOP", title, "BOTTOM", 0, -4)
subtitle:SetText("|cff888888" .. L["REMINDER_SUBTITLE"] .. "|r")

local voidcoreCount = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
voidcoreCount:SetPoint("TOP", subtitle, "BOTTOM", 0, -3)

local divider = frame:CreateTexture(nil, "ARTWORK")
VCA.OnTheme(function() local t = VCA.Theme.border; divider:SetColorTexture(t[1], t[2], t[3], 0.4) end)
divider:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -56)
divider:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -16, -56)
divider:SetHeight(1)

-- ── Current loot spec row ─────────────────────────────────────────────────────

local curHeader = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
curHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -68)
curHeader:SetText("|cff888888" .. L["REMINDER_CURRENT_SPEC"] .. "|r")

local curIcon = frame:CreateTexture(nil, "ARTWORK")
curIcon:SetSize(28, 28)
curIcon:SetPoint("TOPLEFT", frame, "TOPLEFT", 24, -88)
curIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

local curName = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
curName:SetPoint("LEFT", curIcon, "RIGHT", 8, 0)

-- ── Recommended loot spec row ─────────────────────────────────────────────────

local recHeader = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
recHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -130)
recHeader:SetText("|cff00ff00" .. L["REMINDER_RECOMMENDED"] .. "|r")

local recIcon = frame:CreateTexture(nil, "ARTWORK")
recIcon:SetSize(28, 28)
recIcon:SetPoint("TOPLEFT", frame, "TOPLEFT", 24, -150)
recIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

local recName = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
recName:SetPoint("LEFT", recIcon, "RIGHT", 8, 0)

local recStats = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
recStats:SetPoint("TOPLEFT", frame, "TOPLEFT", 24, -184)

-- ── Dynamic warning section (1-item-remaining) ───────────────────────────────

local dynWarnDivider = frame:CreateTexture(nil, "ARTWORK")
dynWarnDivider:SetColorTexture(1.0, 0.5, 0.0, 0.4)
dynWarnDivider:SetHeight(1)
dynWarnDivider:Hide()

local dynWarnIcon = frame:CreateTexture(nil, "ARTWORK")
dynWarnIcon:SetSize(20, 20)
dynWarnIcon:SetAtlas("Ping_Wheel_Icon_Warning")
dynWarnIcon:Hide()

local dynWarnText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
dynWarnText:SetWidth(292)
dynWarnText:SetJustifyH("LEFT")
dynWarnText:Hide()

-- ── Spec-list section ────────────────────────────────────────────────────────

local dynSpecDivider = frame:CreateTexture(nil, "ARTWORK")
VCA.OnTheme(function() local t = VCA.Theme.border; dynSpecDivider:SetColorTexture(t[1], t[2], t[3], 0.4) end)
dynSpecDivider:SetHeight(1)
dynSpecDivider:Hide()

local dynSpecHeader = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
dynSpecHeader:Hide()

local dynSpecRows = {}
for i = 1, 4 do
    local row = {}
    row.icon = frame:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(18, 18)
    row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    row.label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.icon:Hide()
    row.label:Hide()
    dynSpecRows[i] = row
end

-- ── Prompt ────────────────────────────────────────────────────────────────────

local prompt = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
prompt:SetPoint("LEFT", frame, "LEFT", 20, 0)
prompt:SetPoint("RIGHT", frame, "RIGHT", -20, 0)
prompt:SetPoint("BOTTOM", frame, "BOTTOM", 0, 56)
prompt:SetJustifyH("CENTER")

-- ── Buttons ───────────────────────────────────────────────────────────────────

local yesBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
yesBtn:SetSize(140, 28)
yesBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 30, 18)
yesBtn:SetText(L["REMINDER_YES"])

yesBtn:SetScript("OnClick", function()
    if pendingSpecID then
        SetLootSpecialization(pendingSpecID)
    end
    frame:Hide()
end)

local noBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
noBtn:SetSize(140, 28)
noBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 18)
noBtn:SetText(L["REMINDER_NO"])

noBtn:SetScript("OnClick", function()
    frame:Hide()
end)

-- ── Shared spec-list builder ─────────────────────────────────────────────────
-- Populates up to 4 pre-built spec rows starting at dynY and returns the new dynY.
-- rows: array of {icon=Texture, label=FontString}
-- rankings: spec ranking table from RankCurrentPlayerSpecsForItemsCached
-- highlightSpecID: specID to colour green (favored/current)
-- parentFrame: frame used for TOPLEFT anchoring
local function BuildSpecList(parentFrame, startY, rows, rankings, highlightSpecID)
    local dynY = startY
    local rowsUsed = 0
    for _, r in ipairs(rankings or {}) do
        if rowsUsed >= 4 then
            break
        end
        local row = rows[rowsUsed + 1]

        row.icon:ClearAllPoints()
        row.icon:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 24, dynY)
        row.icon:SetTexture(r.specIcon or "Interface\\Icons\\INV_Misc_QuestionMark")
        row.icon:Show()

        local nameColor = (r.specID == highlightSpecID) and "cffffff00" or "cffa0a0a0"
        local remainStr
        if r.allObtained then
            remainStr = "|cff00ff00" .. L["ALL_OBTAINED"] .. "|r"
        elseif r.remainingCount > 0 then
            remainStr = "|cffdddddd" .. string.format(L["REMINDER_SPEC_REMAINING"], r.remainingCount) .. "|r"
        else
            remainStr = "|cff888888" .. L["REMINDER_SPEC_NONE"] .. "|r"
        end

        -- Attach a warning marker on any spec that has exactly 1 item left.
        local warnPrefix = ""
        if r.remainingCount == 1 then
            warnPrefix = CreateAtlasMarkup("Ping_Wheel_Icon_Warning", 14, 14) .. " "
        end

        row.label:ClearAllPoints()
        row.label:SetPoint("LEFT", row.icon, "RIGHT", 6, 0)
        row.label:SetText(warnPrefix .. "|" .. nameColor .. r.specName .. "|r: " .. remainStr)
        row.label:Show()

        dynY = dynY - 22
        rowsUsed = rowsUsed + 1
    end
    -- Hide unused rows.
    for i = rowsUsed + 1, 4 do
        rows[i].icon:Hide()
        rows[i].label:Hide()
    end
    return dynY
end

-- ── Show / Hide ───────────────────────────────────────────────────────────────

function Reminder.Show(currentSpecID, bestEntry, selectedCount, rankings)
    -- Voidcore count
    local currInfo = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo(VCA.VOIDCORE_CURRENCY_ID)
    local owned = currInfo and currInfo.quantity or 0
    voidcoreCount:SetText(string.format(L["REMINDER_VOIDCORE_COUNT"], owned))

    -- Current spec info
    local _, curSpecName, _, curSpecIcon = GetSpecializationInfoByID(currentSpecID)
    curIcon:SetTexture(curSpecIcon or "Interface\\Icons\\INV_Misc_QuestionMark")
    curName:SetText("|cffdddddd" .. (curSpecName or "Unknown") .. "|r")

    -- Recommended spec info
    recIcon:SetTexture(bestEntry.specIcon or "Interface\\Icons\\INV_Misc_QuestionMark")
    recName:SetText("|cffffff00" .. (bestEntry.specName or "Unknown") .. "|r")

    local pct = math.floor((bestEntry.selectedOdds or 0) * 100 + 0.5)
    recStats:SetText(string.format(L["REMINDER_ITEMS_SELECTED"], selectedCount) .. "  |cff888888\226\128\162|r  " ..
                         "|cffffff00" .. string.format(L["REMINDER_SELECTED_CHANCE"], pct) .. "|r")

    prompt:SetText(string.format(L["REMINDER_CHANGE_PROMPT"], bestEntry.specName or "?"))

    -- ── Dynamic section ──────────────────────────────────────────────────────
    -- Content above the dynamic section ends at approximately y=-200.
    local dynY = -208

    if bestEntry.remainingCount == 1 then
        -- Orange divider before warning.
        dynWarnDivider:ClearAllPoints()
        dynWarnDivider:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, dynY)
        dynWarnDivider:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -16, dynY)
        dynWarnDivider:Show()
        dynY = dynY - 12

        dynWarnIcon:ClearAllPoints()
        dynWarnIcon:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, dynY)
        dynWarnIcon:Show()

        dynWarnText:ClearAllPoints()
        dynWarnText:SetPoint("TOPLEFT", frame, "TOPLEFT", 46, dynY)
        dynWarnText:SetText(L["REMINDER_WARNING_ONE_ITEM"])
        dynWarnText:Show()

        dynY = dynY - 80
    else
        dynWarnDivider:Hide()
        dynWarnIcon:Hide()
        dynWarnText:Hide()
    end

    -- Purple divider before spec list.
    dynSpecDivider:ClearAllPoints()
    dynSpecDivider:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, dynY)
    dynSpecDivider:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -16, dynY)
    dynSpecDivider:Show()
    dynY = dynY - 14

    dynSpecHeader:ClearAllPoints()
    dynSpecHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, dynY)
    dynSpecHeader:SetText("|cff888888" .. L["REMINDER_SPEC_LIST_HEADER"] .. "|r")
    dynSpecHeader:Show()
    dynY = dynY - 20

    dynY = BuildSpecList(frame, dynY, dynSpecRows, rankings, bestEntry.specID)

    -- Resize frame to fit all content + room for prompt + buttons.
    frame:SetHeight(math.abs(dynY) + 90)

    pendingSpecID = bestEntry.specID
    frame:Show()
end

function Reminder.Hide()
    frame:Hide()
end

function Reminder.ShowExample()
    local currentSpecID = VCA.SpecInfo.GetEffectiveLootSpecID()
    if not currentSpecID then
        return
    end

    -- Pick a different spec for the recommendation to make the preview realistic.
    local recSpecID = currentSpecID
    for i = 1, GetNumSpecializations() do
        local specID = GetSpecializationInfo(i)
        if specID and specID ~= currentSpecID then
            recSpecID = specID
            break
        end
    end

    local _, recSpecName, _, recSpecIcon = GetSpecializationInfoByID(recSpecID)

    -- Build a minimal rankings list for the preview.
    local exampleRankings = {}
    for i = 1, GetNumSpecializations() do
        local sid, sname, _, sicon = GetSpecializationInfo(i)
        if sid then
            exampleRankings[#exampleRankings + 1] = {
                specID = sid,
                specName = sname or "Unknown",
                specIcon = sicon,
                remainingCount = (sid == recSpecID) and 1 or math.random(2, 6),
                allObtained = false
            }
        end
    end

    Reminder.Show(currentSpecID, {
        specID = recSpecID,
        specName = recSpecName or "Unknown",
        specIcon = recSpecIcon,
        selectedOdds = 0.42,
        remainingCount = 1
    }, 5, exampleRankings)

    -- Prevent the "Yes" button from actually changing the loot spec.
    pendingSpecID = nil
end

-- ── Warning popup (already on the favored loot spec) ────────────────────────

local warnFrame = CreateFrame("Frame", "VoidcoreAdvisorWarning", UIParent, "BackdropTemplate")
warnFrame:SetSize(360, 340)
warnFrame:SetPoint("CENTER")
warnFrame:SetFrameStrata("DIALOG")
warnFrame:SetClampedToScreen(true)
warnFrame:EnableMouse(true)
warnFrame:Hide()

warnFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = {
        left = 11,
        right = 12,
        top = 12,
        bottom = 11
    }
})
VCA.OnTheme(function() local t = VCA.Theme.bg; warnFrame:SetBackdropColor(t[1], t[2], t[3], 0.95) end)
VCA.OnTheme(function() local t = VCA.Theme.border; warnFrame:SetBackdropBorderColor(t[1], t[2], t[3], 1) end)

tinsert(UISpecialFrames, "VoidcoreAdvisorWarning")

local wf_title = warnFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
wf_title:SetPoint("TOP", 0, -14)
wf_title:SetText(L["WARNING_TITLE"])

local wf_subtitle = warnFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
wf_subtitle:SetPoint("TOP", wf_title, "BOTTOM", 0, -4)
wf_subtitle:SetText("|cffff8000" .. L["WARNING_SUBTITLE"] .. "|r")

local wf_voidcoreCount = warnFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
wf_voidcoreCount:SetPoint("TOP", wf_subtitle, "BOTTOM", 0, -3)

local wf_divider1 = warnFrame:CreateTexture(nil, "ARTWORK")
VCA.OnTheme(function() local t = VCA.Theme.border; wf_divider1:SetColorTexture(t[1], t[2], t[3], 0.4) end)
wf_divider1:SetPoint("TOPLEFT", warnFrame, "TOPLEFT", 16, -56)
wf_divider1:SetPoint("TOPRIGHT", warnFrame, "TOPRIGHT", -16, -56)
wf_divider1:SetHeight(1)

local wf_specHeader = warnFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
wf_specHeader:SetPoint("TOPLEFT", warnFrame, "TOPLEFT", 20, -68)
wf_specHeader:SetText("|cff888888" .. L["WARNING_FAVORED_SPEC"] .. "|r")

local wf_curIcon = warnFrame:CreateTexture(nil, "ARTWORK")
wf_curIcon:SetSize(28, 28)
wf_curIcon:SetPoint("TOPLEFT", warnFrame, "TOPLEFT", 24, -88)
wf_curIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

local wf_curName = warnFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
wf_curName:SetPoint("LEFT", wf_curIcon, "RIGHT", 8, 0)

-- Warning section (always shown)
local wf_warnDivider = warnFrame:CreateTexture(nil, "ARTWORK")
wf_warnDivider:SetColorTexture(1.0, 0.5, 0.0, 0.4)
wf_warnDivider:SetPoint("TOPLEFT", warnFrame, "TOPLEFT", 16, -130)
wf_warnDivider:SetPoint("TOPRIGHT", warnFrame, "TOPRIGHT", -16, -130)
wf_warnDivider:SetHeight(1)

local wf_warnIcon = warnFrame:CreateTexture(nil, "ARTWORK")
wf_warnIcon:SetSize(20, 20)
wf_warnIcon:SetPoint("TOPLEFT", warnFrame, "TOPLEFT", 20, -148)
wf_warnIcon:SetAtlas("Ping_Wheel_Icon_Warning")

local wf_warnText = warnFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
wf_warnText:SetWidth(292)
wf_warnText:SetJustifyH("LEFT")
wf_warnText:SetPoint("TOPLEFT", warnFrame, "TOPLEFT", 46, -148)

-- Spec-list section (dynamic height, positioned by ShowWarning)
local wf_specListDivider = warnFrame:CreateTexture(nil, "ARTWORK")
VCA.OnTheme(function() local t = VCA.Theme.border; wf_specListDivider:SetColorTexture(t[1], t[2], t[3], 0.4) end)
wf_specListDivider:SetHeight(1)
wf_specListDivider:Hide()

local wf_specListHeader = warnFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
wf_specListHeader:Hide()

local wf_specRows = {}
for i = 1, 4 do
    local row = {}
    row.icon = warnFrame:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(18, 18)
    row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    row.label = warnFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.icon:Hide()
    row.label:Hide()
    wf_specRows[i] = row
end

local wf_closeBtn = CreateFrame("Button", nil, warnFrame, "UIPanelButtonTemplate")
wf_closeBtn:SetSize(140, 28)
wf_closeBtn:SetPoint("BOTTOM", warnFrame, "BOTTOM", 0, 18)
wf_closeBtn:SetText(L["WARNING_CLOSE"])
wf_closeBtn:SetScript("OnClick", function()
    warnFrame:Hide()
end)

function Reminder.ShowWarning(currentSpecID, currentEntry, rankings)
    -- Voidcore count
    local currInfo = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo(VCA.VOIDCORE_CURRENCY_ID)
    local owned = currInfo and currInfo.quantity or 0
    wf_voidcoreCount:SetText(string.format(L["WARNING_VOIDCORE_COUNT"], owned))

    -- Current (favored) spec
    local _, curSpecName, _, curSpecIcon = GetSpecializationInfoByID(currentSpecID)
    wf_curIcon:SetTexture(curSpecIcon or "Interface\\Icons\\INV_Misc_QuestionMark")
    wf_curName:SetText("|cffffff00" .. (curSpecName or "Unknown") .. "|r")

    -- Warning text
    wf_warnText:SetText(string.format(L["WARNING_ONE_ITEM"], currentEntry.remainingCount or 1))

    -- Spec list (dynamic, starts at y=-220 which is well below the 2-3 line warning text)
    local dynY = -220

    wf_specListDivider:ClearAllPoints()
    wf_specListDivider:SetPoint("TOPLEFT", warnFrame, "TOPLEFT", 16, dynY)
    wf_specListDivider:SetPoint("TOPRIGHT", warnFrame, "TOPRIGHT", -16, dynY)
    wf_specListDivider:Show()
    dynY = dynY - 14

    wf_specListHeader:ClearAllPoints()
    wf_specListHeader:SetPoint("TOPLEFT", warnFrame, "TOPLEFT", 20, dynY)
    wf_specListHeader:SetText("|cff888888" .. L["WARNING_SPEC_LIST_HEADER"] .. "|r")
    wf_specListHeader:Show()
    dynY = dynY - 20

    dynY = BuildSpecList(warnFrame, dynY, wf_specRows, rankings, currentSpecID)

    -- Resize to fit.
    warnFrame:SetHeight(math.abs(dynY) + 70)

    warnFrame:Show()
end

function Reminder.HideWarning()
    warnFrame:Hide()
end

-- ── Evaluation ────────────────────────────────────────────────────────────────

function Reminder.Evaluate()
    -- Check if the reminder is disabled in settings.
    local db = _G[VCA.GLOBAL_DB_NAME]
    if db and db.reminderEnabled == false then
        return
    end

    local instanceName, instanceType, difficultyID, _, _, _, _, instanceID = GetInstanceInfo()

    -- Reset tracking when not inside a 5-man dungeon.
    if instanceType ~= "party" then
        lastShownInstanceID = nil
        return
    end

    -- Only mythic difficulties: 23 = Mythic 0, 8 = Mythic Keystone (M+).
    if difficultyID ~= 23 and difficultyID ~= 8 then
        return
    end

    -- Don't remind if the player has no Voidcores to spend.
    local currInfo = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo(VCA.VOIDCORE_CURRENCY_ID)
    local owned = currInfo and currInfo.quantity or 0
    if owned < 1 then
        return
    end

    if not VCA.LootPool.IsSeasonFilterReady or not VCA.LootPool.IsSeasonFilterReady() then
        return
    end

    -- Map the in-game instance to the EJ instanceID.
    -- Primary: locale-independent InstanceID lookup (requires SeasonData with mapID).
    local ejInstanceID = instanceID and VCA.LootPool.GetSeasonDungeonByInstanceID(instanceID)
    -- Fallback: localized name lookup for SeasonData built before mapID support.
    if not ejInstanceID then
        ejInstanceID = VCA.LootPool.GetSeasonDungeonByName(instanceName)
    end
    if not ejInstanceID then
        return
    end -- not a current-season dungeon

    -- Don't re-show for the same dungeon until the player leaves.
    if lastShownInstanceID == ejInstanceID then
        return
    end

    -- Check if the player has selected items for this dungeon.
    local selectedSet = VCA.Data.GetSelectedItems(VCA.ContentType.MYTHIC_PLUS, ejInstanceID, VCA.MythicPlusEJDifficulty)
    if not next(selectedSet) then
        return
    end

    local selectedList = {}
    for id in pairs(selectedSet) do
        selectedList[#selectedList + 1] = id
    end

    -- Rank all player specs by probability for the selected items.
    local rankings = RankCurrentPlayerSpecsForItemsCached(selectedList, VCA.ContentType.MYTHIC_PLUS, ejInstanceID,
        VCA.MythicPlusEJDifficulty)

    if not rankings or #rankings == 0 then
        return
    end

    local bestSpec = rankings[1]
    if not bestSpec or bestSpec.noItems or bestSpec.allObtained then
        return
    end
    if (bestSpec.selectedOdds or 0) <= 0 then
        return
    end

    -- Already on the best spec.
    local currentLootSpecID = VCA.SpecInfo.GetEffectiveLootSpecID()
    if currentLootSpecID == bestSpec.specID then
        -- If the favored spec has only 1 item remaining, warn about pool reset.
        if bestSpec.remainingCount == 1 then
            lastShownInstanceID = ejInstanceID
            Reminder.ShowWarning(currentLootSpecID, bestSpec, rankings)
        end
        return
    end

    -- Suppress if the current spec is tied with the best spec (same odds),
    -- but never suppress when the best spec covers selected items the current spec doesn't.
    for _, r in ipairs(rankings) do
        if r.specID == currentLootSpecID then
            if not bestSpec.noItems and r.noItems then
                break
            end
            if r.remainingCount <= bestSpec.remainingCount then
                return
            end
            break
        end
    end

    lastShownInstanceID = ejInstanceID
    Reminder.Show(currentLootSpecID, bestSpec, #selectedList, rankings)
end

function Reminder.ForceEvaluate()
    lastShownInstanceID = nil
    Reminder.Evaluate()
end

-- ── Event handler ─────────────────────────────────────────────────────────────

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", function(self, event, isInitialLogin, isReloadingUi)
    -- Skip UI reloads to avoid repeated popups.
    if isReloadingUi then
        return
    end
    -- Short delay so instance info and loot pool caches are ready.
    C_Timer.After(2, function()
        Reminder.Evaluate()
    end)
end)
