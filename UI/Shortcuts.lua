-- VoidcoreAdvisor Reborn: Shortcuts
-- /void panel [boss or dungeon]: opens the Adventure Guide on that boss or
-- dungeon with the VoidcoreAdvisor panel showing. Without a name it just opens
-- the guide and the panel.
local _, VCA = ...
local L = VCA.L

local function Lower(s)
    return (s or ""):lower()
end

-- Returns kind ("raid"|"dungeon"), encounterID (raids only), EJ instanceID.
local function FindTarget(query)
    local q = Lower(query)
    local sd = VCA.SeasonData
    if not sd then
        return
    end
    for encounterID in pairs(sd.raids or {}) do
        local name, _, _, _, _, instanceID = EJ_GetEncounterInfo(encounterID)
        if name and Lower(name):find(q, 1, true) then
            return "raid", encounterID, instanceID
        end
    end
    for instanceID in pairs(sd.dungeons or {}) do
        local name = EJ_GetInstanceInfo(instanceID)
        if name and Lower(name):find(q, 1, true) then
            return "dungeon", nil, instanceID
        end
    end
end

function VCA.OpenPanel(query)
    if not EncounterJournal and EncounterJournal_LoadUI then
        EncounterJournal_LoadUI()
    end
    if VCA.Panel and VCA.Panel.SetMinimized then
        VCA.Panel.SetMinimized(false)
    end

    local q = query and query:match("%S") and query or nil
    if not q then
        if EncounterJournal and not EncounterJournal:IsShown() and ToggleEncounterJournal then
            ToggleEncounterJournal()
        end
        if VCA.EJHook and VCA.EJHook.ReevaluateAndShow then
            VCA.EJHook.ReevaluateAndShow()
        end
        return
    end

    local kind, encounterID, instanceID = FindTarget(q)
    if not kind then
        print(VCA.Theme.title .. "VoidcoreAdvisor Reborn:|r " .. string.format(L["PANEL_NOT_FOUND"], q))
        return
    end
    local difficulty
    if kind == "raid" then
        difficulty = EJ_GetDifficulty()
        if not (difficulty == 14 or difficulty == 15 or difficulty == 16) then
            difficulty = 15
        end
    else
        difficulty = VCA.MythicPlusEJDifficulty
    end
    if EncounterJournal_OpenJournal then
        EncounterJournal_OpenJournal(difficulty, instanceID, encounterID)
    end
end
