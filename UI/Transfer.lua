-- VoidcoreAdvisor Reborn: Transfer
-- Export the items you have marked as obtained on this character as plain
-- text, and import that text on another character (/void export, /void import).
local _, VCA = ...
local L = VCA.L

local Transfer = {}
VCA.Transfer = Transfer

local PREFIX = "VCAR1;"
local KEY_PATTERN = "^[A-Z_]+:%d+:%d+:%d+:%d+:?[HL]?$"

local frame = CreateFrame("Frame", "VCATransferFrame", UIParent, "BackdropTemplate")
frame:SetSize(480, 320)
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
tinsert(UISpecialFrames, "VCATransferFrame")

local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -14)

local hint = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
hint:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
hint:SetPoint("RIGHT", frame, "RIGHT", -16, 0)
hint:SetJustifyH("LEFT")

local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -4, -4)

local scroll = CreateFrame("ScrollFrame", "VCATransferScroll", frame, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -70)
scroll:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -34, 50)
local edit = CreateFrame("EditBox", nil, scroll)
edit:SetMultiLine(true)
edit:SetAutoFocus(false)
edit:SetFontObject("ChatFontNormal")
edit:SetWidth(420)
edit:SetMaxLetters(0)
edit:SetScript("OnEscapePressed", function(self)
    self:ClearFocus()
end)
scroll:SetScrollChild(edit)

local importBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
importBtn:SetSize(110, 24)
importBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -16, 14)
importBtn:SetText(L["IMPORT_BUTTON"])

local function Say(text)
    print(VCA.Theme.title .. "VoidcoreAdvisor Reborn:|r " .. text)
end

function Transfer.Export()
    local db = _G[VCA.CHAR_DB_NAME]
    local keys = {}
    for key, value in pairs(db and db.obtained or {}) do
        if value == true and key:match(KEY_PATTERN) then
            keys[#keys + 1] = key
        end
    end
    table.sort(keys)
    title:SetText(VCA.Theme.title .. L["EXPORT_TITLE"] .. "|r")
    hint:SetText(L["TRANSFER_COPY_HINT"])
    importBtn:Hide()
    edit:SetText(PREFIX .. table.concat(keys, ";"))
    frame:Show()
    edit:SetFocus()
    edit:HighlightText()
end

function Transfer.Import()
    title:SetText(VCA.Theme.title .. L["IMPORT_TITLE"] .. "|r")
    hint:SetText(L["TRANSFER_PASTE_HINT"])
    importBtn:Show()
    edit:SetText("")
    frame:Show()
    edit:SetFocus()
end

importBtn:SetScript("OnClick", function()
    local text = (edit:GetText() or ""):gsub("%s+", "")
    if text:sub(1, #PREFIX) ~= PREFIX then
        Say(L["IMPORT_BAD"])
        return
    end
    local db = _G[VCA.CHAR_DB_NAME]
    if not db then
        return
    end
    db.obtained = db.obtained or {}
    local count = 0
    for key in text:sub(#PREFIX + 1):gmatch("[^;]+") do
        if key:match(KEY_PATTERN) and not db.obtained[key] then
            db.obtained[key] = true
            count = count + 1
        end
    end
    Say(string.format(L["IMPORT_OK"], count))
    frame:Hide()
    if VCA.Panel and VCA.Panel.Refresh then
        VCA.Panel.Refresh()
    end
end)
