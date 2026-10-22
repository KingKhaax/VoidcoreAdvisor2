-- VoidcoreAdvisor: Locale – English (base / fallback)
-- All user-facing strings live here.  Other locale files override individual
-- keys; any key left nil falls back to this table via __index.
local _, VCA = ...

local L = {}
VCA.L = L

-- ── Panel UI ──────────────────────────────────────────────────────────────────

L["PANEL_TITLE"] = "|cff8fe36bVoidcore|r|cffffffffAdvisor|r"

L["COL_LOOT"] = "LOOT"
L["COL_SPEC_RANKING"] = "SPEC RANKING"
L["COL_SPEC_FIT"] = "SPEC FIT"
L["COL_LOOT_FILTERED"] = "LOOT (filtered)"
L["COL_LOOT_FILTERED_N"] = "LOOT (filtered %d specs)"

L["CONTENT_RAID_BOSS"] = "Raid Boss"
L["CONTENT_MP_DUNGEON"] = "M+ Dungeon"
L["NEBULOUS_VOIDCORE"] = "Nebulous Voidcore"
L["NEBULOUS_VOIDCORES"] = "Nebulous Voidcores"

L["NO_ITEMS_FOR_SPEC"] = "No items for this spec"
L["LFR_NOT_ELIGIBLE"] = "Not available in Raid Finder"

L["LOOT_SPEC_LABEL"] = "Loot:"
L["ALL_OBTAINED"] = "✓ all"

L["DETECTED_OBTAINED"] = "Auto-detected %s as obtained via Nebulous Voidcore."

L["CLEAR_SELECTED"] = "Clear selected"

L["TOGGLE_SHOW"] = "Click to show the advisor panel."
L["TOGGLE_HIDE"] = "Click to hide the advisor panel."
L["TOGGLE_OVERVIEW_SHOW"] = "Click to show the dungeon overview."
L["TOGGLE_OVERVIEW_HIDE"] = "Click to hide the dungeon overview."

-- ── Slash commands (Init.lua) ─────────────────────────────────────────────────

L["NEW_SEASON_RESET"] = "New season detected — selected items and obtained items have been cleared."
L["RESET_CONFIRM"] = "All obtained-item data has been reset."
L["COUNT_FORMAT"] = "%d item(s) marked as obtained via Voidcore."
L["SPEC_FORMAT"] = "Effective loot spec ID: %s%s"
L["FOLLOWS_ACTIVE_SPEC"] = " (follows active spec)"
L["SOURCE_FORMAT"] = "Active source — type: %s  sourceID: %s  difficulty: %s"
L["NO_ACTIVE_SOURCE"] = "No active source set."
L["VERSION_FORMAT"] = "Version %s"
L["HELP_HEADER"] = "Commands:"
L["HELP_RESET"] = "  /void reset    – clear all obtained-item data"
L["HELP_COUNT"] = "  /void count    – show total items marked as obtained"
L["HELP_SPEC"] = "  /void spec     – show effective loot spec ID"
L["HELP_SOURCE"] = "  /void source   – show active detection source"
L["HELP_VERSION"] = "  /void version   – show addon version"
L["HELP_REPLAYLOG"] = "  /void replaylog – re-apply all roll log entries as obtained"
L["HELP_RESTORE"] = "  /void restore  – restore obtained data from pre-scan backup"

L["RESTORE_COMPLETE"] = "%d item(s) restored from backup."
L["RESTORE_NO_BACKUP"] = "No backup available. Run a scan first."
L["RESTORE_FAILED"] = "Restore failed."

-- ── Reminder popup (Reminder.lua) ─────────────────────────────────────────────

L["REMINDER_TITLE"] = "|cff8fe36bVoidcore|r|cffffffffAdvisor|r"
L["REMINDER_SUBTITLE"] = "Optimize your loot spec for Nebulous Voidcore rewards!"
L["REMINDER_VOIDCORE_COUNT"] = "You have |cffffff00%d|r Nebulous Voidcore(s)"
L["REMINDER_CURRENT_SPEC"] = "Current loot spec:"
L["REMINDER_RECOMMENDED"] = "Recommended spec:"
L["REMINDER_ITEMS_SELECTED"] = "%d item(s) selected"
L["REMINDER_SELECTED_CHANCE"] = "%d%% chance for selected item(s)"
L["REMINDER_CHANGE_PROMPT"] = "Change loot spec to |cffffff00%s|r?"
L["REMINDER_YES"] = "Yes, Change"
L["REMINDER_NO"] = "No Thanks"
L["REMINDER_WARNING_ONE_ITEM"] =
    "|cffff8000Warning:|r This spec has |cffff0000only 1 item|r remaining in this dungeon. Using a Nebulous Voidcore as this spec will |cffff0000reset the loot pool for every specialization|r in this dungeon!"
L["REMINDER_SPEC_LIST_HEADER"] = "Remaining loot by spec:"
L["SPEC_LIST_TOOLTIP"] = "Remaining loot for each loot specialization"
L["SPEC_LIST_TOOLTIP_TITLE"] = "Loot Protection"
L["SPEC_LIST_ITEM_ONE"] = "1 item remaining"
L["SPEC_LIST_ITEM_MANY"] = "%d items remaining"
L["SPEC_LIST_ALL_OBTAINED"] = "all obtained"
L["REMINDER_SPEC_REMAINING"] = "%d remaining"
L["REMINDER_SPEC_NONE"] = "none remaining"

-- ── Voidcore Pool Reset warning popup (Reminder.lua) ─────────────────────────
L["WARNING_TITLE"] = "|cff8fe36bVoidcore|r|cffffffffAdvisor|r"
L["WARNING_SUBTITLE"] = "Loot Pool Reset Risk"
L["WARNING_VOIDCORE_COUNT"] = "You have |cffffff00%d|r Nebulous Voidcore(s)"
L["WARNING_FAVORED_SPEC"] = "You are using the favored loot spec:"
L["WARNING_ONE_ITEM"] =
    "|cffff8000Warning:|r This spec has |cffff0000only %d item|r remaining in this dungeon. Using a Nebulous Voidcore will |cffff0000reset the loot pool for every specialization|r in this dungeon!"
L["WARNING_SPEC_LIST_HEADER"] = "Items remaining per spec:"
L["WARNING_CLOSE"] = "Close"

-- ── Bonus Roll Confirm overlay (BonusRollConfirm.lua) ────────────────────────

L["BONUS_ROLL_CONFIRM_SUBTITLE"] = "Confirm Nebulous Voidcore Roll"
L["BONUS_ROLL_CONFIRM_SPEC_LABEL"] = "Active loot spec:"
L["BONUS_ROLL_CONFIRM_POOL"] = "%d item(s) remaining in pool"
L["BONUS_ROLL_CONFIRM_CHANCE"] = "%d%% chance (%d wanted items)"
L["BONUS_ROLL_CONFIRM_CHANCE_ONE"] = "%d%% chance (1 wanted item)"
L["BONUS_ROLL_WANTED_TOOLTIP_TITLE"] = "Wanted Items"
L["BONUS_ROLL_CONFIRM_ALL_OBTAINED"] = "All items obtained for this spec"
L["BONUS_ROLL_CONFIRM_NO_ITEMS"] = "No wanted items for this spec"
L["BONUS_ROLL_CONFIRM_NO_ITEMS_OTHER_SPECS"] = "Other specs have wanted items"
L["BONUS_ROLL_CONFIRM_NO_SELECTED"] = "No wanted items"
L["BONUS_ROLL_CONFIRM_NOT_TRACKED"] = "Source not tracked — no odds available"
L["BONUS_ROLL_CONFIRM_WARNING_HEADER"] = "|A:Ping_Chat_Warning:14:14|a |cffffff00Rolling will reset loot protection|r"
L["BONUS_ROLL_CONFIRM_WARNING_BODY"] = "Previously looted items may drop again for all specs."
L["BONUS_ROLL_CONFIRM_QUESTION"] = "Do you want to roll for loot?"
L["BONUS_ROLL_CONFIRM_ROLL"] = "Roll"
L["BONUS_ROLL_CONFIRM_PASS"] = "Pass"
L["BONUS_ROLL_CONFIRM_CONFIRM"] = "Confirm Roll"
L["BONUS_ROLL_CONFIRM_PASS_CONFIRM"] = "Confirm Pass"
L["BONUS_ROLL_CONFIRM_CLOSE"] = "Close"
L["BONUS_ROLL_POPUP_ROLL"] = "Spend your Nebulous Voidcore on a bonus roll?"
L["BONUS_ROLL_POPUP_PASS"] = "Pass on this bonus roll?"

-- ── Options panel (Options.lua) ───────────────────────────────────────────────

L["OPTIONS_CAT_REMINDER"] = "Loot Spec Reminder"
L["OPTIONS_CAT_BONUS_ROLL"] = "Bonus Roll"

L["OPTIONS_REMINDER_ENABLE"] = "Loot spec reminder"
L["OPTIONS_REMINDER_TOOLTIP"] =
    "Show a popup when entering a current-season mythic dungeon if a different loot specialization would give better odds for your selected items."
L["OPTIONS_PREVIEW_REMINDER"] = "Preview"
L["OPTIONS_PREVIEW_BONUS_ROLL"] = "Preview"
L["BONUS_ROLL_CONFIRM_COST"] = "Cost: |cffffff00%d|r  \194\183  You have |cffffff00%d|r"
L["OPTIONS_BONUS_ROLL_CONFIRM"] = "Bonus roll window"
L["OPTIONS_BONUS_ROLL_CONFIRM_TOOLTIP"] =
    "Show VoidcoreAdvisor information when the Nebulous Voidcore bonus roll window appears, including your active loot spec and item odds."
L["OPTIONS_BRC_SPEC_LIST"] = "Show items remaining per spec"
L["OPTIONS_BRC_SPEC_LIST_TOOLTIP"] =
    "Show a list of remaining items for each of your specializations in the bonus roll window."
L["BRC_SWITCH_SPEC_TIP"] = "Switch specialization to %s"

-- ── Dungeon Overview panel (DungeonOverview.lua) ─────────────────────────────

L["DUNGEON_OVERVIEW_SUBTITLE"] = "M+ Dungeons — Loot Chance"
L["DUNGEON_OVERVIEW_COL_DUNGEON"] = "DUNGEON"
L["DUNGEON_OVERVIEW_COL_SPEC"] = "SPEC"
L["DUNGEON_OVERVIEW_COL_LOOTED"] = "LOOTED"
L["DUNGEON_OVERVIEW_COL_CHANCE"] = "CHANCE"
L["DUNGEON_OVERVIEW_ALL_DONE"] = "All dungeon items obtained!"
L["DUNGEON_OVERVIEW_NO_DATA"] = "Season dungeon data not yet available."

-- ── Slot Filter Drawer ────────────────────────────────────────────────────────
L["SLOT_FILTER_TOGGLE"] = "Select by slot"
L["SLOT_FILTER_CLEAR"] = "Deselect all slot items"
L["SLOT_FILTER_CLEAR_CONFIRM"] = "Clear all item selections?"
L["SLOT_FILTER_CLEAR_CONFIRM_BODY"] = "All selected items will be deselected."

L["SLOT_head"] = "Head"
L["SLOT_neck"] = "Neck"
L["SLOT_shoulder"] = "Shoulder"
L["SLOT_back"] = "Back"
L["SLOT_chest"] = "Chest"
L["SLOT_wrist"] = "Wrist"
L["SLOT_hands"] = "Hands"
L["SLOT_waist"] = "Waist"
L["SLOT_legs"] = "Legs"
L["SLOT_feet"] = "Feet"
L["SLOT_finger"] = "Finger"
L["SLOT_trinket"] = "Trinket"
L["SLOT_SELECT_ALL"] = "Select All"
L["SLOT_DESELECT_ALL"] = "Deselect All"
L["SLOT_NONE_SELECTED"] = "Nothing selected"
L["SLOT_weapon"] = "Weapon"
L["SLOT_offhand"] = "Off-Hand"

-- ── Voidcache Scan (VoidcacheScan.lua / DungeonOverview.lua) ─────────────────

L["SCAN_BTN"] = "Scan Loot Specs"
L["SCAN_PROGRESS"] = "Scanning %d/%d..."
L["SCAN_COMPLETE"] = "✓ Scan Done"
L["SCAN_ABORTED"] = "Scan Cancelled"
L["SCAN_CONFIRM_TITLE"] = "Scan Loot Specs?"
L["SCAN_CONFIRM_BODY"] =
    "This will scan the Nebulous Voidcache tooltip for each of your loot specializations across all season dungeons.\n\nScanning the following difficulty:\n|cffffff00Mythic+ keylevel +10|r|cffaaaaaa\n\nExisting dungeon obtained data will be backed up and reset.\n\nDo not enter combat or a dungeon during the scan."
L["SCAN_UNAVAILABLE_COMBAT"] = "Cannot scan while in combat."
L["SCAN_UNAVAILABLE_INSTANCE"] = "Cannot scan while inside a dungeon."
L["RAID_SCAN_CONFIRM_TITLE"] = "Scan Raid Loot Specs?"
L["RAID_SCAN_CONFIRM_BODY"] =
    "This will scan the Nebulous Voidcache tooltip for each of your loot specializations across all raid encounters.\n\nScanning the following difficulty:\n|cffffff00%s|r|cffaaaaaa\n\nExisting %s raid obtained data will be reset.\n\nDo not enter combat during the scan."

L["DIFFICULTY_NORMAL"] = "Normal"
L["DIFFICULTY_HEROIC"] = "Heroic"
L["DIFFICULTY_MYTHIC"] = "Mythic"

L["RAID_OVERVIEW_SUBTITLE"] = "Raid Bosses — Loot Chance"
L["RAID_OVERVIEW_COL_BOSS"] = "BOSS"
L["RAID_OVERVIEW_NO_DATA"] = "No raid encounter data available."

-- ── Spec Picker Popup (PanelColumns.lua) ──────────────────────────────────────

L["SPEC_PICKER_TITLE"] = "Mark as Looted"
L["SPEC_PICKER_OK"] = "OK"
L["OBTAINED_UNKNOWN_SPEC"] = "Obtained (spec unknown)"
L["UNKNOWN_KEYLEVEL"] = "unknown keylevel"
L["MANUAL_ENTRY"] = "manual entry"

-- ── VoidcoreAdvisor Reborn additions ─────────────────────────────────────────────
L["MARK_MODE_BUTTON"] = "Mark rolled item"
L["MARK_MODE_ACTIVE"] = "Click an item to mark it (click here to stop)"
L["MARK_MODE_TIP"] = "Use this for items you got from a Voidcore roll that the addon did not track. While active, click an item to mark it as obtained for all specs, or click it again to unmark it."
L["RAID_NOT_IN_DATA"] = "This raid is not in the addon loot data yet. It loads automatically when possible; otherwise update VoidcoreAdvisor Reborn."
L["ORIGINAL_ADDON_LOADED"] = "The original VoidcoreAdvisor is also enabled. Disable it: both versions cannot run together."
L["BONUS_ROLL_POPUP_ROLL"] = "Are you sure you want to spend your Nebulous Voidcore on a bonus roll?"
L["BONUS_ROLL_POPUP_PASS"] = "Are you sure you want to pass on this bonus roll?"
L["OPTIONS_BRC_CONFIRM"] = "Ask for confirmation before rolling or passing"
L["OPTIONS_BRC_CONFIRM_TOOLTIP"] = "Shows an \"Are you sure?\" message when you click Roll or Pass."

-- ── VoidcoreAdvisor Reborn 2.1 additions ──────────────────────────────────────
L["MISSING_TITLE"] = "Missing items"
L["MISSING_EMPTY"] = "You have every item for this loot spec."
L["PANEL_NOT_FOUND"] = "No boss or dungeon matches \"%s\"."
L["EXPORT_TITLE"] = "Export marked items"
L["IMPORT_TITLE"] = "Import marked items"
L["IMPORT_BUTTON"] = "Import"
L["IMPORT_OK"] = "%d items imported."
L["IMPORT_BAD"] = "That text is not a valid export."
L["TRANSFER_COPY_HINT"] = "Press Ctrl+C to copy this text."
L["TRANSFER_PASTE_HINT"] = "Paste the exported text here, then press Import."
L["OPTIONS_THEME"] = "Color theme"
L["OPTIONS_THEME_TOOLTIP"] = "Changes the color of every VoidcoreAdvisor window."
L["THEME_GREEN"] = "Venom green"
L["THEME_PURPLE"] = "Void purple"
L["THEME_BLUE"] = "Arcane blue"
L["ONE_ITEM_WARN"] = "Only 1 item left for this spec: rolling will reset your loot protection!"
L["MARK_MODE_SHIFT_TIP"] = "Hold Shift and click a second item to mark everything in between."
L["DATA_OUTDATED"] = "New raid not in the loot data yet: %s. The developer needs to update VoidcoreAdvisor Reborn."
L["HELP_PANEL"] = "  /void panel [name] – open the Adventure Guide on a boss or dungeon"
L["HELP_MISSING"] = "  /void missing [14|15|16] – list every item you still need"
L["HELP_EXPORT"] = "  /void export – copy your marked items as text"
L["HELP_IMPORT"] = "  /void import – paste marked items from another character"
L["HELP_THEME"] = "  /void theme <name> – change the window colors"
L["HELP_RESETPANEL"] = "  /void resetpanel – put the panel back next to the guide"
L["THEME_LIGHT"] = "Light"
L["THEME_FIRE"] = "Fire"
L["THEME_FROST"] = "Frost"
L["THEME_RED"] = "Red"
L["THEME_CLASS"] = "Style of my class"
L["HELP_SCAN"] = "  /void scan [raid 14|15|16] – read your Voidcache to mark the items from coins you already used"
L["SCAN_TIP"] = "Tip: type /void scan to mark the items from the Voidcore coins you already used."
L["MARK_MODE_ACTIVE"] = "Click the items, then click here to save"
L["MARK_MODE_TIP"] = "Click this bar, then click the items you got from a Voidcore roll that the addon did not track: they dim right away. Click the bar again to save them."
