-- VoidcoreAdvisor: Options
-- Registers the addon in the Game Menu → Options → AddOns panel using the
-- Settings API (added in 10.0).
local addonName, VCA = ...
local L = VCA.L

-- ── Register settings on ADDON_LOADED ─────────────────────────────────────────
-- The Settings API must be called after the addon's SavedVariables are loaded.

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, loadedAddon)
    if loadedAddon ~= addonName then
        return
    end
    self:UnregisterEvent("ADDON_LOADED")

    -- Create a vertical-layout category for the AddOns tab.
    local category = Settings.RegisterVerticalLayoutCategory("VoidcoreAdvisor Reborn")
    local reminderCategory = Settings.RegisterVerticalLayoutSubcategory(category, L["OPTIONS_CAT_REMINDER"])
    local bonusRollCategory = Settings.RegisterVerticalLayoutSubcategory(category, L["OPTIONS_CAT_BONUS_ROLL"])

    -- ── Loot Spec Reminder toggle ─────────────────────────────────────────
    do
        local variable = "VoidcoreAdvisor_ReminderEnabled"
        local name = L["OPTIONS_REMINDER_ENABLE"]
        local variableKey = "reminderEnabled"
        local variableTbl = _G[VCA.GLOBAL_DB_NAME]
        local default = true

        local setting = Settings.RegisterAddOnSetting(reminderCategory, variable, variableKey, variableTbl,
            type(default), name, default)

        local initializer = Settings.CreateCheckbox(reminderCategory, setting, L["OPTIONS_REMINDER_TOOLTIP"])

        -- Add a "Preview" button on the same row as the checkbox.
        hooksecurefunc(SettingsCheckboxControlMixin, "Init", function(self, init)
            if init == initializer then
                if not self.VCAPreviewButton then
                    local btn = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
                    btn:SetSize(100, 22)
                    btn:SetPoint("RIGHT", self, "RIGHT", -16, 0)
                    btn:SetText(L["OPTIONS_PREVIEW_REMINDER"])
                    btn:SetScript("OnClick", function()
                        if VoidcoreAdvisorReminder:IsShown() then
                            VCA.Reminder.Hide()
                        else
                            VCA.Reminder.ShowExample()
                        end
                    end)
                    self.VCAPreviewButton = btn
                end
                self.VCAPreviewButton:Show()
            elseif self.VCAPreviewButton then
                self.VCAPreviewButton:Hide()
            end
        end)
    end

    -- ── Bonus Roll confirmation overlay toggle ────────────────────────────
    do
        local variable = "VoidcoreAdvisor_BonusRollConfirmEnabled"
        local name = L["OPTIONS_BONUS_ROLL_CONFIRM"]
        local variableKey = "bonusRollConfirmEnabled"
        local variableTbl = _G[VCA.GLOBAL_DB_NAME]
        local default = true

        local setting = Settings.RegisterAddOnSetting(bonusRollCategory, variable, variableKey, variableTbl,
            type(default), name, default)
        local brcInitializer = Settings.CreateCheckbox(bonusRollCategory, setting,
            L["OPTIONS_BONUS_ROLL_CONFIRM_TOOLTIP"])

        hooksecurefunc(SettingsCheckboxControlMixin, "Init", function(self, init)
            if init == brcInitializer then
                if not self.VCABRCPreviewButton then
                    local btn = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
                    btn:SetSize(100, 22)
                    btn:SetPoint("RIGHT", self, "RIGHT", -16, 0)
                    btn:SetText(L["OPTIONS_PREVIEW_BONUS_ROLL"])
                    btn:SetScript("OnClick", function()
                        if VCARollWindow and VCARollWindow:IsShown() then
                            VCA.BonusRollConfirm.Hide()
                        else
                            VCA.BonusRollConfirm.ShowPreview()
                        end
                    end)
                    self.VCABRCPreviewButton = btn
                end
                self.VCABRCPreviewButton:Show()
            elseif self.VCABRCPreviewButton then
                self.VCABRCPreviewButton:Hide()
            end
        end)
    end

    -- ── Show items remaining per spec toggle ─────────────────────────────
    do
        local variable = "VoidcoreAdvisor_BRCSpecList"
        local name = L["OPTIONS_BRC_SPEC_LIST"]
        local variableKey = "brcSpecListEnabled"
        local variableTbl = _G[VCA.GLOBAL_DB_NAME]
        local default = false

        local setting = Settings.RegisterAddOnSetting(bonusRollCategory, variable, variableKey, variableTbl,
            type(default), name, default)
        Settings.CreateCheckbox(bonusRollCategory, setting, L["OPTIONS_BRC_SPEC_LIST_TOOLTIP"])
    end

    -- ── Color theme ───────────────────────────────────────────────────────
    pcall(function()
        local variable = "VoidcoreAdvisor_Theme"
        local variableTbl = _G[VCA.GLOBAL_DB_NAME]
        local setting = Settings.RegisterAddOnSetting(category, variable, "theme", variableTbl, "string",
            L["OPTIONS_THEME"], "green")
        local function GetOptions()
            local container = Settings.CreateControlTextContainer()
            for _, key in ipairs(VCA.THEME_ORDER) do
                container:Add(key, VCA.ThemeLabel(key))
            end
            return container:GetData()
        end
        Settings.SetOnValueChangedCallback(variable, function()
            VCA.ApplyTheme(variableTbl.theme)
            if VCA.Panel and VCA.Panel.Refresh then
                VCA.Panel.Refresh()
            end
        end)
        Settings.CreateDropdown(category, setting, GetOptions, L["OPTIONS_THEME_TOOLTIP"])
    end)

    -- ── Ask for confirmation before rolling or passing ───────────────────
    do
        local variable = "VoidcoreAdvisor_BRCConfirm"
        local name = L["OPTIONS_BRC_CONFIRM"]
        local variableKey = "brcConfirmEnabled"
        local variableTbl = _G[VCA.GLOBAL_DB_NAME]
        local default = true

        local setting = Settings.RegisterAddOnSetting(bonusRollCategory, variable, variableKey, variableTbl,
            type(default), name, default)
        Settings.CreateCheckbox(bonusRollCategory, setting, L["OPTIONS_BRC_CONFIRM_TOOLTIP"])
    end

    -- ── Finish ────────────────────────────────────────────────────────────
    Settings.RegisterAddOnCategory(category)
end)
