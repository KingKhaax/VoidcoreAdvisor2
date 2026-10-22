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

    -- ── Also remind in front of raid bosses ───────────────────────────────
    do
        local setting = Settings.RegisterAddOnSetting(reminderCategory, "VoidcoreAdvisor_ReminderBossEnabled",
            "reminderBossEnabled", _G[VCA.GLOBAL_DB_NAME], "boolean", L["OPTIONS_REMINDER_BOSS"], true)
        Settings.CreateCheckbox(reminderCategory, setting, L["OPTIONS_REMINDER_BOSS_TOOLTIP"])
    end

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

    -- ── Theme selectors: one row each, with a "Preview" button on the right ──
    local previewActions = {} -- initializer -> function run by that row's button
    if SettingsDropdownControlMixin and hooksecurefunc then
        hooksecurefunc(SettingsDropdownControlMixin, "Init", function(self, init)
            local action = previewActions[init]
            if action then
                if not self.VCAPreviewButton then
                    local btn = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
                    btn:SetSize(100, 22)
                    btn:SetPoint("RIGHT", self, "RIGHT", -16, 0)
                    btn:SetText(L["OPTIONS_PREVIEW_REMINDER"])
                    btn:SetScript("OnClick", function(button)
                        if button.vcaAction then
                            button.vcaAction()
                        end
                    end)
                    self.VCAPreviewButton = btn
                end
                self.VCAPreviewButton.vcaAction = action
                self.VCAPreviewButton:Show()
            elseif self.VCAPreviewButton then
                self.VCAPreviewButton:Hide()
            end
        end)
    end

    local function ThemeRow(variable, key, labelKey, tooltipKey, default, withCurrent, onChange, onPreview)
        pcall(function()
            local tbl = _G[VCA.GLOBAL_DB_NAME]
            local setting = Settings.RegisterAddOnSetting(category, variable, key, tbl, "string", L[labelKey], default)
            local function GetOptions()
                local container = Settings.CreateControlTextContainer()
                if withCurrent then
                    container:Add("current", L["THEME_CURRENT"])
                end
                for _, themeKey in ipairs(VCA.THEME_ORDER) do
                    container:Add(themeKey, VCA.ThemeLabel(themeKey))
                end
                return container:GetData()
            end
            Settings.SetOnValueChangedCallback(variable, function()
                onChange(tbl)
            end)
            previewActions[Settings.CreateDropdown(category, setting, GetOptions, L[tooltipKey])] = onPreview
        end)
    end

    -- 1. The color theme of the addon; its button shows that theme in the sample window.
    ThemeRow("VoidcoreAdvisor_Theme", "theme", "OPTIONS_THEME", "OPTIONS_THEME_TOOLTIP", "green", false, function(tbl)
        VCA.ApplyTheme(tbl.theme)
        if VCA.Panel and VCA.Panel.Refresh then
            VCA.Panel.Refresh()
        end
    end, function()
        VCA.ThemePreview.SetTheme("current", false)
        VCA.ThemePreview.Show()
    end)

    -- 2. The theme the sample window shows.
    ThemeRow("VoidcoreAdvisor_PreviewTheme", "previewTheme", "OPTIONS_PREVIEW_THEME", "OPTIONS_PREVIEW_THEME_TOOLTIP",
        "class", true, function(tbl)
            VCA.ThemePreview.SetTheme(tbl.previewTheme)
            VCA.ThemePreview.Show()
        end, function()
            local gdb = _G[VCA.GLOBAL_DB_NAME]
            VCA.ThemePreview.SetTheme(gdb and gdb.previewTheme or "class")
            VCA.ThemePreview.Show()
        end)

    -- 3. The theme of the bonus roll window; its button opens the roll window preview.
    ThemeRow("VoidcoreAdvisor_RollTheme", "rollTheme", "OPTIONS_ROLL_THEME", "OPTIONS_ROLL_THEME_TOOLTIP", "class", true,
        function(tbl)
            VCA.ApplyTheme(tbl.theme)
        end, function()
            if VCARollWindow and VCARollWindow:IsShown() then
                VCA.BonusRollConfirm.Hide()
            else
                VCA.BonusRollConfirm.ShowPreview()
            end
        end)

    -- 4. The theme of the loot spec reminder popups; its button opens the example popup.
    ThemeRow("VoidcoreAdvisor_ReminderTheme", "reminderTheme", "OPTIONS_REMINDER_THEME",
        "OPTIONS_REMINDER_THEME_TOOLTIP", "class", true, function(tbl)
            VCA.ApplyTheme(tbl.theme)
        end, function()
            if VoidcoreAdvisorReminder and VoidcoreAdvisorReminder:IsShown() then
                VCA.Reminder.Hide()
            else
                VCA.Reminder.ShowExample()
            end
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

    -- /void open: jumps straight to this page (themes and previews).
    function VCA.OpenOptions()
        if Settings and Settings.OpenToCategory then
            local id = category.GetID and category:GetID() or category.ID
            if pcall(Settings.OpenToCategory, id) then
                return
            end
        end
        if SettingsPanel and SettingsPanel.Open then
            SettingsPanel:Open()
        end
    end
end)
