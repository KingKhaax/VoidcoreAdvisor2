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

-- true while the popup is about a raid boss instead of a Mythic+ dungeon (wording only).
local popupIsBoss = false

-- The reminder popups have their own theme setting (default: the colors of your class).
local function ReminderPalette()
    local gdb = _G[VCA.GLOBAL_DB_NAME]
    return VCA.GetPalette(gdb and gdb.reminderTheme or "class")
end
local shownBosses -- assigned in the raid boss section below

-- ── Shared look ───────────────────────────────────────────────────────────────
-- Flat themed frames with gold corner brackets, spec rows with a small bar, like the
-- sample windows. All colors come from ReminderPalette(), so the popup follows the
-- "Reminder popup theme" option.

local FRAME_W = 440
local PAD = 20

local function FlatBackdrop(f)
    f:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
        insets = {left = 1, right = 1, top = 1, bottom = 1}
    })
    VCA.OnTheme(function()
        local p = ReminderPalette()
        f:SetBackdropColor(p.bg[1], p.bg[2], p.bg[3], 0.97)
        f:SetBackdropBorderColor(p.border[1], p.border[2], p.border[3], 1)
    end)
    for _, point in ipairs({"TOPLEFT", "BOTTOMRIGHT"}) do
        local h = f:CreateTexture(nil, "OVERLAY")
        h:SetColorTexture(0.80, 0.70, 0.48, 1)
        h:SetSize(11, 1)
        h:SetPoint(point, f, point, 0, 0)
        local v = f:CreateTexture(nil, "OVERLAY")
        v:SetColorTexture(0.80, 0.70, 0.48, 1)
        v:SetSize(1, 11)
        v:SetPoint(point, f, point, 0, 0)
    end
end

-- A 1px line; themed unless an explicit color is given.
local function Line(f, r, g, b, a)
    local t = f:CreateTexture(nil, "ARTWORK")
    t:SetHeight(1)
    if r then
        t:SetColorTexture(r, g, b, a)
    else
        VCA.OnTheme(function()
            local e = ReminderPalette().border
            t:SetColorTexture(e[1], e[2], e[3], 0.5)
        end)
    end
    return t
end

local function PlaceLine(line, f, y)
    line:ClearAllPoints()
    line:SetPoint("TOPLEFT", f, "TOPLEFT", 16, y)
    line:SetPoint("TOPRIGHT", f, "TOPRIGHT", -16, y)
    line:Show()
end

-- A spec icon with a colored border (green = recommended, grey = current).
local function SpecIcon(f, recommended)
    local border = f:CreateTexture(nil, "BACKGROUND")
    if recommended then
        border:SetColorTexture(0.36, 1.0, 0.29, 1)
    else
        border:SetColorTexture(0.42, 0.43, 0.47, 1)
    end
    local icon = f:CreateTexture(nil, "ARTWORK")
    icon:SetSize(30, 30)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    border:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 2)
    border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
    return icon
end

-- Up to 4 rows: background, icon, text and a bar with the share of items still missing.
local BAR_W = 90
local function NewSpecRows(parent)
    local rows = {}
    for i = 1, 4 do
        local row = {}
        row.bg = parent:CreateTexture(nil, "BACKGROUND")
        row.bg:SetColorTexture(1, 1, 1, 0.045)
        row.icon = parent:CreateTexture(nil, "ARTWORK")
        row.icon:SetSize(20, 20)
        row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        row.label = parent:CreateFontString(nil, "OVERLAY", "VCAFontHighlightSmall")
        row.track = parent:CreateTexture(nil, "BORDER")
        row.track:SetSize(BAR_W, 5)
        row.track:SetColorTexture(0, 0, 0, 0.45)
        row.fill = parent:CreateTexture(nil, "ARTWORK")
        row.fill:SetHeight(5)
        row.bg:Hide()
        row.icon:Hide()
        row.label:Hide()
        row.track:Hide()
        row.fill:Hide()
        rows[i] = row
    end
    VCA.OnTheme(function()
        local t = ReminderPalette().timer
        for _, row in ipairs(rows) do
            row.fill:SetColorTexture(t[1], t[2], t[3], 1)
        end
    end)
    return rows
end

-- ── Main frame ────────────────────────────────────────────────────────────────

local frame = CreateFrame("Frame", "VoidcoreAdvisorReminder", UIParent, "BackdropTemplate")
frame:SetSize(FRAME_W, 290)
frame:SetPoint("CENTER")
frame:SetFrameStrata("DIALOG")
frame:SetClampedToScreen(true)
frame:EnableMouse(true)
frame:Hide()
FlatBackdrop(frame)

-- ESC key closes the popup via the global UISpecialFrames mechanism.
tinsert(UISpecialFrames, "VoidcoreAdvisorReminder")

-- ── Title ─────────────────────────────────────────────────────────────────────

local title = frame:CreateFontString(nil, "OVERLAY", "VCAFontNormalLarge")
VCA.OnTheme(function()
    title:SetText(VCA.RebornTitle(L["REMINDER_TITLE"], ReminderPalette()))
end)

local subtitle = frame:CreateFontString(nil, "OVERLAY", "VCAFontHighlightSmall")
subtitle:SetWidth(FRAME_W - PAD * 2)
subtitle:SetJustifyH("CENTER")
subtitle:SetWordWrap(true)
subtitle:SetText("|cff9b9ba6" .. L["REMINDER_SUBTITLE"] .. "|r")

local voidcoreCount = frame:CreateFontString(nil, "OVERLAY", "VCAFontNormal")

local divider = Line(frame)

-- ── Current loot spec row ─────────────────────────────────────────────────────

local curHeader = frame:CreateFontString(nil, "OVERLAY", "VCAFontNormal")
curHeader:SetText("|cffa9a9b3" .. L["REMINDER_CURRENT_SPEC"] .. "|r")
local curIcon = SpecIcon(frame, false)
local curName = frame:CreateFontString(nil, "OVERLAY", "VCAFontHighlightLarge")

-- ── Recommended loot spec row ─────────────────────────────────────────────────

local recHeader = frame:CreateFontString(nil, "OVERLAY", "VCAFontNormal")
recHeader:SetText("|cff5dff4a" .. L["REMINDER_RECOMMENDED"] .. "|r")
local recIcon = SpecIcon(frame, true)
local recName = frame:CreateFontString(nil, "OVERLAY", "VCAFontHighlightLarge")

local recStats = frame:CreateFontString(nil, "OVERLAY", "VCAFontNormal")
recStats:SetWidth(FRAME_W - PAD * 2)
recStats:SetJustifyH("CENTER")
recStats:SetWordWrap(true)

-- ── Dynamic warning section (1-item-remaining) ───────────────────────────────

local dynWarnDivider = Line(frame, 1.0, 0.5, 0.0, 0.45)
dynWarnDivider:Hide()

local dynWarnIcon = frame:CreateTexture(nil, "ARTWORK")
dynWarnIcon:SetSize(20, 20)
dynWarnIcon:SetAtlas("Ping_Wheel_Icon_Warning")
dynWarnIcon:Hide()

local dynWarnText = frame:CreateFontString(nil, "OVERLAY", "VCAFontHighlightSmall")
dynWarnText:SetWidth(FRAME_W - PAD * 2 - 26)
dynWarnText:SetJustifyH("LEFT")
dynWarnText:SetWordWrap(true)
dynWarnText:Hide()

-- ── Spec-list section ────────────────────────────────────────────────────────

local dynSpecDivider = Line(frame)
dynSpecDivider:Hide()

local dynSpecHeader = frame:CreateFontString(nil, "OVERLAY", "VCAFontNormal")
dynSpecHeader:Hide()

local dynSpecRows = NewSpecRows(frame)

-- ── Prompt ────────────────────────────────────────────────────────────────────

local prompt = frame:CreateFontString(nil, "OVERLAY", "VCAFontHighlight")
prompt:SetPoint("LEFT", frame, "LEFT", PAD, 0)
prompt:SetPoint("RIGHT", frame, "RIGHT", -PAD, 0)
prompt:SetPoint("BOTTOM", frame, "BOTTOM", 0, 56)
prompt:SetJustifyH("CENTER")

-- ── Buttons ───────────────────────────────────────────────────────────────────

local yesBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
yesBtn:SetSize(160, 28)
yesBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 30, 18)
yesBtn:SetText(L["REMINDER_YES"])

yesBtn:SetScript("OnClick", function()
    if pendingSpecID then
        SetLootSpecialization(pendingSpecID)
    end
    frame:Hide()
end)

local noBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
noBtn:SetSize(160, 28)
noBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 18)
noBtn:SetText(L["REMINDER_NO"])

noBtn:SetScript("OnClick", function()
    frame:Hide()
end)

-- ── Shared spec-list builder ─────────────────────────────────────────────────
-- Fills up to 4 spec rows starting at startY and returns the y below the last one.
-- rows: from NewSpecRows(); rankings: spec ranking table from
-- RankCurrentPlayerSpecsForItemsCached; highlightSpecID: spec drawn in gold.
local ROW_STRIDE = 26
local function BuildSpecList(parentFrame, startY, rows, rankings, highlightSpecID)
    local dynY = startY
    local rowsUsed = 0
    local width = parentFrame:GetWidth()
    for _, r in ipairs(rankings or {}) do
        if rowsUsed >= 4 then
            break
        end
        local row = rows[rowsUsed + 1]

        row.bg:ClearAllPoints()
        row.bg:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", PAD, dynY)
        row.bg:SetSize(width - PAD * 2, 24)
        row.bg:Show()

        row.icon:ClearAllPoints()
        row.icon:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", PAD + 3, dynY - 2)
        row.icon:SetTexture(r.specIcon or 134400)
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

        -- Bar: items still missing out of the spec's pool.
        local base = (r.baseCount and r.baseCount > 0) and r.baseCount or math.max(r.remainingCount * 2, 1)
        local frac = math.min(1, math.max(0, (r.remainingCount or 0) / base))
        row.track:ClearAllPoints()
        row.track:SetPoint("TOPRIGHT", parentFrame, "TOPRIGHT", -PAD - 8, dynY - 10)
        row.track:Show()
        row.fill:ClearAllPoints()
        row.fill:SetPoint("TOPLEFT", row.track, "TOPLEFT", 0, 0)
        row.fill:SetWidth(math.max(2, BAR_W * frac))
        row.fill:Show()

        dynY = dynY - ROW_STRIDE
        rowsUsed = rowsUsed + 1
    end
    -- Hide unused rows.
    for i = rowsUsed + 1, 4 do
        local row = rows[i]
        row.bg:Hide()
        row.icon:Hide()
        row.label:Hide()
        row.track:Hide()
        row.fill:Hide()
    end
    return dynY
end

-- ── Show / Hide ───────────────────────────────────────────────────────────────

function Reminder.Show(currentSpecID, bestEntry, selectedCount, rankings)
    local W = frame:GetWidth()

    -- Voidcore count
    local currInfo = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo(VCA.VOIDCORE_CURRENCY_ID)
    local owned = currInfo and currInfo.quantity or 0
    voidcoreCount:SetText(string.format(L["REMINDER_VOIDCORE_COUNT"], owned))

    -- Current spec info
    local _, curSpecName, _, curSpecIcon = GetSpecializationInfoByID(currentSpecID)
    curIcon:SetTexture(curSpecIcon or 134400)
    curName:SetText("|cffffffff" .. (curSpecName or "Unknown") .. "|r")

    -- Recommended spec info
    recIcon:SetTexture(bestEntry.specIcon or 134400)
    recName:SetText("|cfffff6d8" .. (bestEntry.specName or "Unknown") .. "|r")

    local pct = math.floor((bestEntry.selectedOdds or 0) * 100 + 0.5)
    recStats:SetText("|cffffd84d" .. string.format(L["REMINDER_ITEMS_SELECTED"], selectedCount) .. "|r  |cff9b9ba6\226\128\162|r  " ..
                         "|cffffd84d" .. string.format(L["REMINDER_SELECTED_CHANCE"], pct) .. "|r")

    prompt:SetText(string.format(L["REMINDER_CHANGE_PROMPT"], bestEntry.specName or "?"))

    -- Everything is stacked from the top using the real text heights, so nothing
    -- overlaps or gets cut when a language needs more lines.
    local y = -14
    title:ClearAllPoints()
    title:SetPoint("TOP", frame, "TOP", 0, y)
    y = y - title:GetStringHeight() - 4

    subtitle:ClearAllPoints()
    subtitle:SetPoint("TOP", frame, "TOP", 0, y)
    y = y - subtitle:GetStringHeight() - 4

    voidcoreCount:ClearAllPoints()
    voidcoreCount:SetPoint("TOP", frame, "TOP", 0, y)
    y = y - voidcoreCount:GetStringHeight() - 8

    PlaceLine(divider, frame, y)
    y = y - 10

    curHeader:ClearAllPoints()
    curHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", PAD, y)
    y = y - 20
    curIcon:ClearAllPoints()
    curIcon:SetPoint("TOPLEFT", frame, "TOPLEFT", PAD + 4, y)
    curName:ClearAllPoints()
    curName:SetPoint("LEFT", curIcon, "RIGHT", 10, 0)
    y = y - 38

    recHeader:ClearAllPoints()
    recHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", PAD, y)
    y = y - 20
    recIcon:ClearAllPoints()
    recIcon:SetPoint("TOPLEFT", frame, "TOPLEFT", PAD + 4, y)
    recName:ClearAllPoints()
    recName:SetPoint("LEFT", recIcon, "RIGHT", 10, 0)
    y = y - 38

    recStats:ClearAllPoints()
    recStats:SetPoint("TOP", frame, "TOP", 0, y)
    y = y - recStats:GetStringHeight() - 10

    if bestEntry.remainingCount == 1 then
        PlaceLine(dynWarnDivider, frame, y)
        y = y - 10

        dynWarnIcon:ClearAllPoints()
        dynWarnIcon:SetPoint("TOPLEFT", frame, "TOPLEFT", PAD, y)
        dynWarnIcon:Show()

        dynWarnText:ClearAllPoints()
        dynWarnText:SetPoint("TOPLEFT", frame, "TOPLEFT", PAD + 26, y)
        dynWarnText:SetText(L[popupIsBoss and "REMINDER_WARNING_ONE_ITEM_BOSS" or "REMINDER_WARNING_ONE_ITEM"])
        dynWarnText:Show()

        y = y - math.max(dynWarnText:GetStringHeight(), 20) - 10
    else
        dynWarnDivider:Hide()
        dynWarnIcon:Hide()
        dynWarnText:Hide()
    end

    PlaceLine(dynSpecDivider, frame, y)
    y = y - 10

    dynSpecHeader:ClearAllPoints()
    dynSpecHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", PAD, y)
    dynSpecHeader:SetText("|cffa9a9b3" .. L["REMINDER_SPEC_LIST_HEADER"] .. "|r")
    dynSpecHeader:Show()
    y = y - 22

    y = BuildSpecList(frame, y, dynSpecRows, rankings, bestEntry.specID)

    -- Room for the question and the buttons.
    frame:SetHeight(math.abs(y) + 96)

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
warnFrame:SetSize(FRAME_W, 340)
warnFrame:SetPoint("CENTER")
warnFrame:SetFrameStrata("DIALOG")
warnFrame:SetClampedToScreen(true)
warnFrame:EnableMouse(true)
warnFrame:Hide()
FlatBackdrop(warnFrame)

tinsert(UISpecialFrames, "VoidcoreAdvisorWarning")

local wf_title = warnFrame:CreateFontString(nil, "OVERLAY", "VCAFontNormalLarge")
VCA.OnTheme(function()
    wf_title:SetText(VCA.RebornTitle(L["WARNING_TITLE"], ReminderPalette()))
end)

local wf_subtitle = warnFrame:CreateFontString(nil, "OVERLAY", "VCAFontHighlightSmall")
wf_subtitle:SetWidth(FRAME_W - PAD * 2)
wf_subtitle:SetJustifyH("CENTER")
wf_subtitle:SetWordWrap(true)
wf_subtitle:SetText("|cffff8000" .. L["WARNING_SUBTITLE"] .. "|r")

local wf_voidcoreCount = warnFrame:CreateFontString(nil, "OVERLAY", "VCAFontNormal")

local wf_divider1 = Line(warnFrame)

local wf_specHeader = warnFrame:CreateFontString(nil, "OVERLAY", "VCAFontNormal")
wf_specHeader:SetText("|cffa9a9b3" .. L["WARNING_FAVORED_SPEC"] .. "|r")

local wf_curIcon = SpecIcon(warnFrame, false)
local wf_curName = warnFrame:CreateFontString(nil, "OVERLAY", "VCAFontHighlightLarge")

-- Warning section (always shown)
local wf_warnDivider = Line(warnFrame, 1.0, 0.5, 0.0, 0.45)

local wf_warnIcon = warnFrame:CreateTexture(nil, "ARTWORK")
wf_warnIcon:SetSize(20, 20)
wf_warnIcon:SetAtlas("Ping_Wheel_Icon_Warning")

local wf_warnText = warnFrame:CreateFontString(nil, "OVERLAY", "VCAFontHighlightSmall")
wf_warnText:SetWidth(FRAME_W - PAD * 2 - 26)
wf_warnText:SetJustifyH("LEFT")
wf_warnText:SetWordWrap(true)

-- Spec-list section (dynamic height, positioned by ShowWarning)
local wf_specListDivider = Line(warnFrame)
wf_specListDivider:Hide()

local wf_specListHeader = warnFrame:CreateFontString(nil, "OVERLAY", "VCAFontNormal")
wf_specListHeader:Hide()

local wf_specRows = NewSpecRows(warnFrame)

local wf_closeBtn = CreateFrame("Button", nil, warnFrame, "UIPanelButtonTemplate")
wf_closeBtn:SetSize(160, 28)
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
    wf_curIcon:SetTexture(curSpecIcon or 134400)
    wf_curName:SetText("|cffffffff" .. (curSpecName or "Unknown") .. "|r")

    -- Warning text
    wf_warnText:SetText(string.format(L[popupIsBoss and "WARNING_ONE_ITEM_BOSS" or "WARNING_ONE_ITEM"],
        currentEntry.remainingCount or 1))

    -- Stacked from the top with the real text heights.
    local y = -14
    wf_title:ClearAllPoints()
    wf_title:SetPoint("TOP", warnFrame, "TOP", 0, y)
    y = y - wf_title:GetStringHeight() - 4

    wf_subtitle:ClearAllPoints()
    wf_subtitle:SetPoint("TOP", warnFrame, "TOP", 0, y)
    y = y - wf_subtitle:GetStringHeight() - 4

    wf_voidcoreCount:ClearAllPoints()
    wf_voidcoreCount:SetPoint("TOP", warnFrame, "TOP", 0, y)
    y = y - wf_voidcoreCount:GetStringHeight() - 8

    PlaceLine(wf_divider1, warnFrame, y)
    y = y - 10

    wf_specHeader:ClearAllPoints()
    wf_specHeader:SetPoint("TOPLEFT", warnFrame, "TOPLEFT", PAD, y)
    y = y - 20
    wf_curIcon:ClearAllPoints()
    wf_curIcon:SetPoint("TOPLEFT", warnFrame, "TOPLEFT", PAD + 4, y)
    wf_curName:ClearAllPoints()
    wf_curName:SetPoint("LEFT", wf_curIcon, "RIGHT", 10, 0)
    y = y - 40

    PlaceLine(wf_warnDivider, warnFrame, y)
    y = y - 10
    wf_warnIcon:ClearAllPoints()
    wf_warnIcon:SetPoint("TOPLEFT", warnFrame, "TOPLEFT", PAD, y)
    wf_warnText:ClearAllPoints()
    wf_warnText:SetPoint("TOPLEFT", warnFrame, "TOPLEFT", PAD + 26, y)
    y = y - math.max(wf_warnText:GetStringHeight(), 20) - 10

    PlaceLine(wf_specListDivider, warnFrame, y)
    y = y - 10

    wf_specListHeader:ClearAllPoints()
    wf_specListHeader:SetPoint("TOPLEFT", warnFrame, "TOPLEFT", PAD, y)
    wf_specListHeader:SetText("|cffa9a9b3" .. L["WARNING_SPEC_LIST_HEADER"] .. "|r")
    wf_specListHeader:Show()
    y = y - 22

    y = BuildSpecList(warnFrame, y, wf_specRows, rankings, currentSpecID)

    -- Resize to fit.
    warnFrame:SetHeight(math.abs(y) + 70)

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
            popupIsBoss = false
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
    popupIsBoss = false
    Reminder.Show(currentLootSpecID, bestSpec, #selectedList, rankings)
end

function Reminder.ForceEvaluate()
    lastShownInstanceID = nil
    wipe(shownBosses)
    Reminder.Evaluate()
end

-- ── Raid bosses ───────────────────────────────────────────────────────────────
-- The same reminder, shown once per boss when you target it before the pull.

shownBosses = {} -- { ["encounterID:difficultyID"] = true }, reset on every loading screen
local bossNameCache = {} -- { [ejInstanceID] = { [lowercase boss or creature name] = encounterID } }

local function BossNames(ejInstanceID)
    local cached = bossNameCache[ejInstanceID]
    if cached then
        return cached
    end
    local map, count = {}, 0
    for encounterID, data in pairs(VCA.SeasonData and VCA.SeasonData.raids or {}) do
        if data.instanceID == ejInstanceID then
            local name = EJ_GetEncounterInfo(encounterID)
            if name then
                map[name:lower()] = encounterID
                count = count + 1
            end
            -- Council fights list each boss as a creature of the encounter.
            local i = 1
            while EJ_GetCreatureInfo do
                local _, creatureName = EJ_GetCreatureInfo(i, encounterID)
                if not creatureName then
                    break
                end
                map[creatureName:lower()] = encounterID
                i = i + 1
            end
        end
    end
    if count > 0 then
        bossNameCache[ejInstanceID] = map
    end
    return map
end

local function FindEncounter(ejInstanceID, unitName)
    local lower = unitName:lower()
    local names = BossNames(ejInstanceID)
    if names[lower] then
        return names[lower]
    end
    for name, encounterID in pairs(names) do
        if lower:find(name, 1, true) or name:find(lower, 1, true) then
            return encounterID
        end
    end
end

function Reminder.EvaluateBoss()
    local db = _G[VCA.GLOBAL_DB_NAME]
    if db and (db.reminderEnabled == false or db.reminderBossEnabled == false) then
        return
    end
    if InCombatLockdown() or not UnitExists("target") or UnitIsDead("target") or UnitIsPlayer("target") then
        return
    end
    local instanceName, instanceType, difficultyID, _, _, _, _, mapID = GetInstanceInfo()
    if instanceType ~= "raid" or not (VCA.EligibleRaidDifficulties and VCA.EligibleRaidDifficulties[difficultyID]) then
        return
    end
    -- Raid bosses are the "skull" (worldboss) units.
    if UnitClassification("target") ~= "worldboss" then
        return
    end
    if not VCA.LootPool.IsSeasonFilterReady or not VCA.LootPool.IsSeasonFilterReady() then
        return
    end
    local ejInstanceID = (mapID and VCA.LootPool.GetSeasonRaidByMapID(mapID)) or
                             VCA.LootPool.GetSeasonRaidByName(instanceName)
    if not ejInstanceID then
        return
    end
    local encounterID = FindEncounter(ejInstanceID, UnitName("target") or "")
    if not encounterID then
        return
    end
    local key = encounterID .. ":" .. difficultyID
    if shownBosses[key] then
        return
    end

    local cost = VCA.Probability.GetVoidcoreCost(VCA.ContentType.RAID)
    local currInfo = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo(VCA.VOIDCORE_CURRENCY_ID)
    if (currInfo and currInfo.quantity or 0) < cost then
        return
    end

    local selectedSet = VCA.Data.GetSelectedItems(VCA.ContentType.RAID, encounterID, difficultyID)
    if not next(selectedSet) then
        return
    end
    local selectedList = {}
    for id in pairs(selectedSet) do
        selectedList[#selectedList + 1] = id
    end
    local rankings = RankCurrentPlayerSpecsForItemsCached(selectedList, VCA.ContentType.RAID, encounterID, difficultyID)
    if not rankings or #rankings == 0 then
        return
    end
    local bestSpec = rankings[1]
    if not bestSpec or bestSpec.noItems or bestSpec.allObtained or (bestSpec.selectedOdds or 0) <= 0 then
        return
    end

    local currentLootSpecID = VCA.SpecInfo.GetEffectiveLootSpecID()
    popupIsBoss = true
    if currentLootSpecID == bestSpec.specID then
        if bestSpec.remainingCount == 1 then
            shownBosses[key] = true
            Reminder.ShowWarning(currentLootSpecID, bestSpec, rankings)
        end
        return
    end
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
    shownBosses[key] = true
    Reminder.Show(currentLootSpecID, bestSpec, #selectedList, rankings)
end

-- ── Event handler ─────────────────────────────────────────────────────────────

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
eventFrame:RegisterEvent("ENCOUNTER_END")
eventFrame:SetScript("OnEvent", function(self, event, isInitialLogin, isReloadingUi, _, _, success)
    if event == "ENCOUNTER_END" then
        -- encounterID, name, difficultyID, groupSize, success: after a wipe the next pull gets the popup again.
        if success == 0 then
            wipe(shownBosses)
        end
        return
    end
    if event == "PLAYER_TARGET_CHANGED" then
        C_Timer.After(0.3, Reminder.EvaluateBoss)
        return
    end
    wipe(shownBosses)
    -- Skip UI reloads to avoid repeated popups.
    if isReloadingUi then
        return
    end
    -- Short delay so instance info and loot pool caches are ready.
    C_Timer.After(2, function()
        Reminder.Evaluate()
    end)
end)

