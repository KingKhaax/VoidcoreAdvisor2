-- VoidcoreAdvisor: EJHook
-- Post-hooks into the Encounter Journal to auto-show/hide the panel when the
-- player navigates to a boss or dungeon.
--
-- Hook strategy:
--   hooksecurefunc("EJ_SelectEncounter", ...)  → raid boss view
--   hooksecurefunc("EJ_SelectInstance",  ...)  → dungeon / raid overview
--   hooksecurefunc("EJ_SetDifficulty",   ...)  → difficulty change while panel is open
--
-- The re-entry guard (LootPool._reentryGuard) is checked so that internal EJ
-- calls made during pool reads do not retrigger panel updates.
--
-- Season filter:
--   Only current-season M+ dungeons (from C_ChallengeMode rotation) and
--   current-tier raids trigger the panel.  Old-expansion content is ignored.
--   Filter logic lives in LootPool so the cache warmup can share it.
local _, VCA = ...

VCA.EJHook = {}

local EJHook = VCA.EJHook
EJHook._s = EJHook._s or {}
local _s = EJHook._s
_s.pendingReevaluate = _s.pendingReevaluate or false
_s.forcedRaidOverviewInstanceID = _s.forcedRaidOverviewInstanceID or nil
local EJ_TAB_DUNGEONS = 4
local EJ_TAB_RAIDS = 5

local function IsEJOnInstanceListView()
    return EncounterJournal and EncounterJournal.instanceSelect and EncounterJournal.instanceSelect:IsShown()
end

local function IsEJDungeonsTabSelected()
    if not EncounterJournal or not EncounterJournal:IsShown() then
        return false
    end
    if not PanelTemplates_GetSelectedTab then
        return false
    end
    local selected = PanelTemplates_GetSelectedTab(EncounterJournal)
    return selected == EJ_TAB_DUNGEONS
end

local function IsEJRaidsTabSelected()
    if not EncounterJournal or not EncounterJournal:IsShown() then
        return false
    end
    if not PanelTemplates_GetSelectedTab then
        return false
    end
    local selected = PanelTemplates_GetSelectedTab(EncounterJournal)
    return selected == EJ_TAB_RAIDS
end

local function IsCurrentSeasonRaidInstance(instanceID)
    return instanceID and instanceID > 0 and VCA.LootPool.IsCurrentSeasonRaid(instanceID)
end

local function IsCurrentSeasonDungeonInstance(instanceID)
    return instanceID and instanceID > 0 and VCA.LootPool.IsCurrentSeasonDungeon(instanceID)
end

-- Shared helper refs consumed by EJHookView.lua.
_s.IsEJOnInstanceListView = IsEJOnInstanceListView
_s.IsEJDungeonsTabSelected = IsEJDungeonsTabSelected
_s.IsEJRaidsTabSelected = IsEJRaidsTabSelected
_s.IsCurrentSeasonRaidInstance = IsCurrentSeasonRaidInstance
_s.IsCurrentSeasonDungeonInstance = IsCurrentSeasonDungeonInstance

-- ── Hook: boss encounter selected ────────────────────────────────────────────

local _warnedRaidIDs = {}

hooksecurefunc("EJ_SelectEncounter", function(encounterID)
    if VCA.LootPool._reentryGuard then
        return
    end
    if not EncounterJournal or not EncounterJournal:IsShown() then
        return
    end

    local isRaid = EJ_InstanceIsRaid() == true

    if isRaid then
        local name, _, _, _, _, journalInstanceID = EJ_GetEncounterInfo(encounterID)
        if not name then
            return
        end

        if not VCA.LootPool.IsCurrentSeasonRaid(journalInstanceID) then
            if not _warnedRaidIDs[journalInstanceID] and EJ_GetNumTiers and EJ_GetCurrentTier() == EJ_GetNumTiers() then
                _warnedRaidIDs[journalInstanceID] = true
                print(VCA.Theme.title .. "VoidcoreAdvisor Reborn:|r " .. VCA.L["RAID_NOT_IN_DATA"])
            end
            VCA.Panel.Hide()
            EJHook.UpdateToggleVisibility()
            return
        end

        _s.forcedRaidOverviewInstanceID = nil
        VCA.RaidOverview.Hide()
        if VCA.EJHook.overviewToggleBtn then
            VCA.EJHook.overviewToggleBtn:Hide()
        end

        local difficultyID = EJ_GetDifficulty() or VCA.Difficulty.RAID_NORMAL
        VCA.Panel.SetContext(VCA.ContentType.RAID, encounterID, difficultyID, name, true -- is raid
        )
        if not VCA.Panel.IsMinimized() then
            VCA.Panel.Show()
        end
        if VCA.EJHook.toggleBtn then
            VCA.EJHook.toggleBtn:Show()
        end
        EJHook.UpdateToggleVisibility()
    else
        -- Dungeon boss clicked: show entire instance loot pool, not just this boss.
        local _, _, _, _, _, journalInstanceID = EJ_GetEncounterInfo(encounterID)
        if not journalInstanceID then
            return
        end

        if not VCA.LootPool.IsCurrentSeasonDungeon(journalInstanceID) then
            VCA.Panel.Hide()
            EJHook.UpdateToggleVisibility()
            return
        end

        _s.forcedRaidOverviewInstanceID = nil
        VCA.RaidOverview.Hide()
        if VCA.EJHook.overviewToggleBtn then
            VCA.EJHook.overviewToggleBtn:Hide()
        end

        local instanceName = EJ_GetInstanceInfo(journalInstanceID)
        if not instanceName then
            return
        end

        VCA.Panel.SetContext(VCA.ContentType.MYTHIC_PLUS, journalInstanceID, VCA.MythicPlusEJDifficulty, instanceName,
            false -- not a raid
        )
        if not VCA.Panel.IsMinimized() then
            VCA.Panel.Show()
        end
        if VCA.EJHook.toggleBtn then
            VCA.EJHook.toggleBtn:Show()
        end
        EJHook.UpdateToggleVisibility()
    end
end)

-- ── Hook: instance (dungeon / raid overview) selected ────────────────────────

hooksecurefunc("EJ_SelectInstance", function(instanceID)
    if VCA.LootPool._reentryGuard then
        return
    end
    if not EncounterJournal or not EncounterJournal:IsShown() then
        return
    end

    local name = EJ_GetInstanceInfo(instanceID)
    if not name then
        return
    end

    VCA.RaidOverview.Hide()

    local isRaid = IsCurrentSeasonRaidInstance(instanceID) or (EJ_InstanceIsRaid() == true)

    if isRaid then
        -- Raid overview page: show the boss overview panel (not the per-boss panel).
        _s.forcedRaidOverviewInstanceID = instanceID
        VCA.Panel.Hide()
        if IsCurrentSeasonRaidInstance(instanceID) and not VCA.DungeonOverview.IsMinimized() then
            local difficultyID = EJ_GetDifficulty() or VCA.Difficulty.RAID_NORMAL
            VCA.RaidOverview.Show(instanceID, difficultyID)
        end
        if VCA.EJHook.toggleBtn then
            VCA.EJHook.toggleBtn:Hide()
        end
        if VCA.EJHook.overviewToggleBtn then
            if IsCurrentSeasonRaidInstance(instanceID) then
                VCA.EJHook.overviewToggleBtn:Show()
            else
                VCA.EJHook.overviewToggleBtn:Hide()
            end
        end
        EJHook.UpdateToggleVisibility()
        return
    end

    _s.forcedRaidOverviewInstanceID = nil

    if not IsCurrentSeasonDungeonInstance(instanceID) then
        VCA.Panel.Hide()
        EJHook.UpdateToggleVisibility()
        return
    end

    -- M+ / dungeon overview: show the panel for the whole instance pool.
    VCA.Panel.SetContext(VCA.ContentType.MYTHIC_PLUS, instanceID, VCA.MythicPlusEJDifficulty, name, false -- not a raid
    )
    if not VCA.Panel.IsMinimized() then
        VCA.Panel.Show()
    end
    if VCA.EJHook.toggleBtn then
        VCA.EJHook.toggleBtn:Show()
    end
    if VCA.EJHook.overviewToggleBtn then
        VCA.EJHook.overviewToggleBtn:Hide()
    end
    EJHook.UpdateToggleVisibility()
end)

-- ── Hook: difficulty changed while panel is open ──────────────────────────────
-- When the user changes the EJ difficulty dropdown for a raid, refresh the
-- panel's stored difficultyID so later probability reads use the right pool.

hooksecurefunc("EJ_SetDifficulty", function(difficultyID)
    if VCA.LootPool._reentryGuard then
        return
    end
    if VCA.RaidOverview.IsShown() then
        local instanceID = EncounterJournal and EncounterJournal.instanceID
        if instanceID and instanceID > 0 then
            VCA.RaidOverview.Show(instanceID, difficultyID)
        end
    end
    if not VCA.Panel.IsShown() then
        return
    end
    if VCA.Panel.sourceType ~= VCA.ContentType.RAID then
        return
    end

    -- Update stored difficulty and re-apply context with the same source.
    if VCA.Panel.sourceID then
        local name = VCA.Panel.sourceName or ""
        VCA.Panel.SetContext(VCA.ContentType.RAID, VCA.Panel.sourceID, difficultyID, name, true)
    end
end)

-- ── Toggle button visibility ─────────────────────────────────────────────────

local syncFrame = CreateFrame("Frame")
syncFrame:RegisterEvent("PLAYER_LOGIN")
syncFrame:RegisterEvent("CHALLENGE_MODE_MAPS_UPDATE")
syncFrame:SetScript("OnEvent", function(self, event)
    if event == "CHALLENGE_MODE_MAPS_UPDATE" then
        -- M+ rotation may have changed (new season); rebuild season state and
        -- invalidate in-session loot cache so future reads repopulate from fresh data.
        VCA.LootPool.InvalidateCache()
        VCA.LootPool.BuildSeasonFilter()
        return
    end

    -- PLAYER_LOGIN
    self:UnregisterEvent("PLAYER_LOGIN")

    if not EncounterJournal and EncounterJournal_LoadUI then
        EncounterJournal_LoadUI()
    end

    if not EncounterJournal then
        return
    end

    -- When the EJ closes, hide our panel with it.
    EncounterJournal:HookScript("OnHide", function()
        _s.forcedRaidOverviewInstanceID = nil
        VCA.Panel.Hide()
        VCA.DungeonOverview.Hide()
        VCA.RaidOverview.Hide()
        EJHook.UpdateToggleVisibility()
    end)

    -- When the EJ opens (or reopens), re-evaluate the current instance/encounter
    -- so the panel shows even if EJ_SelectInstance / EJ_SelectEncounter didn't fire.
    EncounterJournal:HookScript("OnShow", function()
        VCA.Panel.AnchorToEJ()
        EJHook.UpdateToggleVisibility()
        EJHook.ShowOverviewIfAllowed()
        if VCA.Panel.IsMinimized() then
            return
        end
        EJHook.QueueReevaluateAndShow()
    end)

    -- Initial open / navigation can update instance state one frame later.
    -- Hook this to keep the panel in sync on the first EJ open in instances.
    if type(EncounterJournal_DisplayInstance) == "function" then
        hooksecurefunc("EncounterJournal_DisplayInstance", function()
            if not EncounterJournal or not EncounterJournal:IsShown() then
                return
            end
            EJHook.QueueReevaluateAndShow()
        end)
    end

    -- When the user navigates back to the instance list, hide the main panel
    -- and show the dungeon overview instead.
    if EncounterJournal.instanceSelect then
        EncounterJournal.instanceSelect:HookScript("OnShow", function()
            _s.forcedRaidOverviewInstanceID = nil
            VCA.Panel.Hide()
            if VCA.EJHook.toggleBtn then
                VCA.EJHook.toggleBtn:Hide()
            end
            EJHook.ShowOverviewIfAllowed()
            EJHook.UpdateToggleVisibility()
        end)
        EncounterJournal.instanceSelect:HookScript("OnHide", function()
            VCA.DungeonOverview.Hide()
            EJHook.UpdateToggleVisibility()
        end)
    end

    -- When the user switches EJ tabs (Dungeons & Raids, Loot, Journeys, etc.),
    -- hide the panel and button directly. EJ state (instanceID) is still stale
    -- when this fires, so UpdateToggleVisibility would immediately re-show it.
    EventRegistry:RegisterCallback("EncounterJournal.TabSet", function()
        _s.forcedRaidOverviewInstanceID = nil
        VCA.Panel.Hide()
        VCA.DungeonOverview.Hide()
        VCA.RaidOverview.Hide()
        if VCA.EJHook.toggleBtn then
            VCA.EJHook.toggleBtn:Hide()
        end

        -- Tab switching updates EJ state asynchronously; re-check next frame.
        C_Timer.After(0, function()
            if not EncounterJournal or not EncounterJournal:IsShown() then
                return
            end

            if _s.IsEJDungeonsTabSelected() or _s.IsEJRaidsTabSelected() then
                if _s.IsEJOnInstanceListView() then
                    EJHook.ShowOverviewIfAllowed()
                elseif not VCA.Panel.IsMinimized() then
                    EJHook.QueueReevaluateAndShow()
                end
            end

            EJHook.UpdateToggleVisibility()
        end)
    end, "VoidcoreAdvisor")

    -- ── Toggle button (BonusLoot-Chest) ──────────────────────────────────────
    -- Small chest icon in the top-right of the Encounter Journal that lets
    -- the user show/hide the VoidcoreAdvisor panel.
    local toggleBtn = CreateFrame("Button", nil, EncounterJournal)
    toggleBtn:SetSize(36, 36)
    toggleBtn:SetFrameStrata("HIGH")
    toggleBtn:SetPoint("RIGHT", EncounterJournal.CloseButton, "LEFT", -4, 0)

    local toggleIcon = toggleBtn:CreateTexture(nil, "ARTWORK")
    toggleIcon:SetAllPoints()
    toggleIcon:SetAtlas("azeritereforger-glow")
    toggleIcon:SetDesaturated(true)
    VCA.OnTheme(function()
        local t = VCA.Theme.accent
        toggleIcon:SetVertexColor(t[1], t[2], t[3], 1)
    end)

    local toggleHighlight = toggleBtn:CreateTexture(nil, "HIGHLIGHT")
    toggleHighlight:SetSize(32, 32)
    toggleHighlight:SetPoint("CENTER")
    toggleHighlight:SetAtlas("azeritereforger-glow")
    toggleHighlight:SetVertexColor(1, 0.82, 0, 0.7)

    toggleBtn:SetScript("OnClick", function()
        if VCA.Panel.IsMinimized() then
            VCA.Panel.SetMinimized(false)
            EJHook.ReevaluateAndShow()
        else
            VCA.Panel.SetMinimized(true)
            VCA.Panel.Hide()
        end
    end)

    toggleBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("VoidcoreAdvisor")
        if VCA.Panel.IsMinimized() then
            GameTooltip:AddLine(VCA.L["TOGGLE_SHOW"], 1, 1, 1)
        else
            GameTooltip:AddLine(VCA.L["TOGGLE_HIDE"], 1, 1, 1)
        end
        GameTooltip:Show()
    end)
    toggleBtn:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    toggleBtn:Hide() -- hidden by default; shown when viewing relevant content
    VCA.EJHook.toggleBtn = toggleBtn

    -- ── Overview toggle button (instance-list view) ─────────────────────────
    -- Chest icon near the panel toggle; controls dungeon overview visibility.
    local overviewToggleBtn = CreateFrame("Button", nil, EncounterJournal)
    overviewToggleBtn:SetSize(36, 36)
    overviewToggleBtn:SetFrameStrata("HIGH")
    overviewToggleBtn:SetPoint("RIGHT", EncounterJournal.CloseButton, "LEFT", -4, 0)

    local overviewIcon = overviewToggleBtn:CreateTexture(nil, "ARTWORK")
    overviewIcon:SetAllPoints()
    overviewIcon:SetAtlas("azeritereforger-glow")
    overviewIcon:SetDesaturated(true)
    VCA.OnTheme(function()
        local t = VCA.Theme.accent
        overviewIcon:SetVertexColor(t[1], t[2], t[3], 1)
    end)

    local overviewHighlight = overviewToggleBtn:CreateTexture(nil, "HIGHLIGHT")
    overviewHighlight:SetSize(32, 32)
    overviewHighlight:SetPoint("CENTER")
    overviewHighlight:SetAtlas("azeritereforger-glow")
    overviewHighlight:SetVertexColor(1, 0.82, 0, 0.7)

    overviewToggleBtn:SetScript("OnClick", function()
        if VCA.DungeonOverview.IsMinimized() then
            VCA.DungeonOverview.SetMinimized(false)
            EJHook.ShowOverviewIfAllowed()
        else
            VCA.DungeonOverview.SetMinimized(true)
            VCA.DungeonOverview.Hide()
            VCA.RaidOverview.Hide()
        end
        EJHook.UpdateToggleVisibility()
    end)

    overviewToggleBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("VoidcoreAdvisor")
        if VCA.DungeonOverview.IsMinimized() then
            GameTooltip:AddLine(VCA.L["TOGGLE_OVERVIEW_SHOW"], 1, 1, 1)
        else
            GameTooltip:AddLine(VCA.L["TOGGLE_OVERVIEW_HIDE"], 1, 1, 1)
        end
        GameTooltip:Show()
    end)
    overviewToggleBtn:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    overviewToggleBtn:Hide()
    VCA.EJHook.overviewToggleBtn = overviewToggleBtn

    -- If the EJ is already open on login (rare), lock the anchor in now.
    if EncounterJournal:IsShown() then
        VCA.Panel.AnchorToEJ()
        EJHook.UpdateToggleVisibility()
    end
end)
