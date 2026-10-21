-- VoidcoreAdvisor: Locale – German
if GetLocale() ~= "deDE" then
    return
end
local _, VCA = ...
local L = VCA.L

-- ── Panel UI ──────────────────────────────────────────────────────────────────

L["PANEL_TITLE"] = "|cff8fe36bVoidcore|r|cffffffffBerater|r"

L["COL_LOOT"] = "BEUTE"
L["COL_SPEC_RANKING"] = "SPEZ.-RANKING"
L["COL_SPEC_FIT"] = "SPEZ.-EIGNUNG"
L["COL_LOOT_FILTERED"] = "BEUTE (gefiltert)"
L["COL_LOOT_FILTERED_N"] = "BEUTE (gefiltert %d Spez.)"

L["CONTENT_RAID_BOSS"] = "Raidboss"
L["CONTENT_MP_DUNGEON"] = "M+-Dungeon"
L["NEBULOUS_VOIDCORE"] = "Nebulöser Leerenkern"
L["NEBULOUS_VOIDCORES"] = "Nebulöse Leerenkerne"

L["NO_ITEMS_FOR_SPEC"] = "Keine Gegenstände für diese Spezialisierung"

L["LOOT_SPEC_LABEL"] = "Beute:"
L["ALL_OBTAINED"] = "✓ alle"

L["DETECTED_OBTAINED"] = "%s automatisch als über Nebulösen Leerenkern erhalten erkannt."

L["CLEAR_SELECTED"] = "Auswahl aufheben"

-- ── Slash commands ────────────────────────────────────────────────────────────

L["RESET_CONFIRM"] = "Alle erhaltenen Gegenstände wurden zurückgesetzt."
L["NEW_SEASON_RESET"] = "Neue Saison erkannt — ausgewählte und erhaltene Gegenstände wurden gelöscht."
L["COUNT_FORMAT"] = "%d Gegenstand/Gegenstände als über Leerenkern erhalten markiert."
L["SPEC_FORMAT"] = "Aktive Beutespezialisierungs-ID: %s%s"
L["FOLLOWS_ACTIVE_SPEC"] = " (folgt aktiver Spezialisierung)"
L["SOURCE_FORMAT"] = "Aktive Quelle — Typ: %s  QuellenID: %s  Schwierigkeit: %s"
L["NO_ACTIVE_SOURCE"] = "Keine aktive Quelle gesetzt."
L["VERSION_FORMAT"] = "Version %s"
L["HELP_HEADER"] = "Befehle:"
L["HELP_RESET"] = "  /void reset    – alle erhaltenen Gegenstände zurücksetzen"
L["HELP_COUNT"] = "  /void count    – Gesamtzahl erhaltener Gegenstände anzeigen"
L["HELP_SPEC"] = "  /void spec     – aktive Beutespezialisierungs-ID anzeigen"
L["HELP_SOURCE"] = "  /void source   – aktive Erkennungsquelle anzeigen"
L["HELP_VERSION"] = "  /void version  – Addon-Version anzeigen"
L["HELP_RESTORE"] = "  /void restore  – Beutedaten aus Scan-Backup wiederherstellen"

-- ── Panel UI (Ergänzungen) ────────────────────────────────────────────────────

L["LFR_NOT_ELIGIBLE"] = "Im Schlachtzugssucher nicht verfügbar"

L["TOGGLE_SHOW"] = "Klicken, um das Beraterpanel anzuzeigen."
L["TOGGLE_HIDE"] = "Klicken, um das Beraterpanel zu verbergen."
L["TOGGLE_OVERVIEW_SHOW"] = "Klicken, um die Dungeon-Übersicht anzuzeigen."
L["TOGGLE_OVERVIEW_HIDE"] = "Klicken, um die Dungeon-Übersicht zu verbergen."

-- ── Erinnerungs-Popup (Reminder.lua) ─────────────────────────────────────────

L["REMINDER_TITLE"] = "|cff8fe36bVoidcore|r|cffffffffBerater|r"
L["REMINDER_SUBTITLE"] = "Optimiere deine Beutespezialisierung für Nebulöse Leerenkerne!"
L["REMINDER_VOIDCORE_COUNT"] = "Du hast |cffffff00%d|r Nebulösen Leerenkern(e)"
L["REMINDER_CURRENT_SPEC"] = "Aktuelle Beutespezialisierung:"
L["REMINDER_RECOMMENDED"] = "Empfohlene Spezialisierung:"
L["REMINDER_ITEMS_SELECTED"] = "%d Gegenstand/Gegenstände ausgewählt"
L["REMINDER_SELECTED_CHANCE"] = "%d%% Chance für ausgewählte Gegenstände"
L["REMINDER_CHANGE_PROMPT"] = "Beutespezialisierung zu |cffffff00%s|r wechseln?"
L["REMINDER_YES"] = "Ja, wechseln"
L["REMINDER_NO"] = "Nein danke"
L["REMINDER_WARNING_ONE_ITEM"] =
    "|cffff8000Warnung:|r Diese Spezialisierung hat in diesem Dungeon |cffff0000nur noch 1 Gegenstand|r übrig. Die Verwendung eines Nebulösen Leerkerns mit dieser Spezialisierung |cffff0000setzt den Beutepool für alle Spezialisierungen|r in diesem Dungeon zurück!"
L["REMINDER_SPEC_LIST_HEADER"] = "Verbleibende Gegenstände pro Spezialisierung:"
L["REMINDER_SPEC_REMAINING"] = "%d übrig"
L["REMINDER_SPEC_NONE"] = "nichts übrig"
L["SPEC_LIST_TOOLTIP_TITLE"] = "Beuteschutz"
L["SPEC_LIST_ITEM_ONE"] = "1 Gegenstand übrig"
L["SPEC_LIST_ITEM_MANY"] = "%d Gegenstände übrig"
L["SPEC_LIST_ALL_OBTAINED"] = "alle erhalten"

-- ── Voidcore-Pool-Reset-Warnungs-Popup (Reminder.lua) ────────────────────────

L["WARNING_TITLE"] = "|cff8fe36bVoidcore|r|cffffffffBerater|r"
L["WARNING_SUBTITLE"] = "Risiko: Beutepool-Rücksetzung"
L["WARNING_VOIDCORE_COUNT"] = "Du hast |cffffff00%d|r Nebulösen Leerenkern(e)"
L["WARNING_FAVORED_SPEC"] = "Du verwendest die bevorzugte Beutespezialisierung:"
L["WARNING_ONE_ITEM"] =
    "|cffff8000Warnung:|r Diese Spezialisierung hat in diesem Dungeon |cffff0000nur noch %d Gegenstand|r übrig. Die Verwendung eines Nebulösen Leerkerns |cffff0000setzt den Beutepool für alle Spezialisierungen|r in diesem Dungeon zurück!"
L["WARNING_SPEC_LIST_HEADER"] = "Verbleibende Gegenstände pro Spezialisierung:"
L["WARNING_CLOSE"] = "Schließen"

-- ── Optionspanel (Options.lua) ────────────────────────────────────────────────

L["OPTIONS_CAT_REMINDER"] = "Beutespezialisierungs-Erinnerung"
L["OPTIONS_CAT_BONUS_ROLL"] = "Bonuswurf"

L["OPTIONS_REMINDER_ENABLE"] = "Beutespezialisierungs-Erinnerung"
L["OPTIONS_REMINDER_TOOLTIP"] =
    "Zeigt ein Popup beim Betreten eines aktuellen saisonalen mythischen Dungeons, wenn eine andere Beutespezialisierung bessere Chancen für deine ausgewählten Gegenstände bietet."
L["OPTIONS_PREVIEW_REMINDER"] = "Vorschau"

-- ── Dungeon-Übersichtspanel (DungeonOverview.lua) ────────────────────────────

L["DUNGEON_OVERVIEW_SUBTITLE"] = "M+-Dungeons — Beutechance"
L["DUNGEON_OVERVIEW_COL_DUNGEON"] = "DUNGEON"
L["DUNGEON_OVERVIEW_COL_SPEC"] = "SPEZ."
L["DUNGEON_OVERVIEW_COL_LOOTED"] = "GEPLÜNDERT"
L["DUNGEON_OVERVIEW_COL_CHANCE"] = "CHANCE"
L["DUNGEON_OVERVIEW_ALL_DONE"] = "Alle Dungeon-Gegenstände erhalten!"
L["DUNGEON_OVERVIEW_NO_DATA"] = "Saisonale Dungeon-Daten noch nicht verfügbar."

L["RAID_OVERVIEW_SUBTITLE"] = "Raidbosse — Beutechance"
L["RAID_OVERVIEW_COL_BOSS"] = "BOSS"
L["RAID_OVERVIEW_NO_DATA"] = "Keine Raidbegegnungsdaten verfügbar."

-- ── Spezialisierungsauswahl-Popup (PanelColumns.lua) ─────────────────────────

L["SPEC_PICKER_TITLE"] = "Erhalten als:"
L["SPEC_PICKER_OK"] = "OK"
L["OBTAINED_UNKNOWN_SPEC"] = "Erhalten (Spezialisierung unbekannt)"
L["UNKNOWN_KEYLEVEL"] = "Unbekannte Schlüsselstufe"
L["MANUAL_ENTRY"] = "Manueller Eintrag"

-- ── Slot-Filter-Schublade (DungeonOverview.lua) ──────────────────────────────

L["SLOT_FILTER_TOGGLE"] = "Nach Ausrüstungsplatz filtern"
L["SLOT_FILTER_CLEAR"] = "Alle Platz-Gegenstände abwählen"
L["SLOT_FILTER_CLEAR_CONFIRM"] = "Alle Gegenstandsauswahlen aufheben?"
L["SLOT_FILTER_CLEAR_CONFIRM_BODY"] = "Alle ausgewählten Gegenstände werden abgewählt."

L["SLOT_head"] = "Kopf"
L["SLOT_neck"] = "Hals"
L["SLOT_shoulder"] = "Schulter"
L["SLOT_back"] = "Rücken"
L["SLOT_chest"] = "Brust"
L["SLOT_wrist"] = "Handgelenk"
L["SLOT_hands"] = "Hände"
L["SLOT_waist"] = "Taille"
L["SLOT_legs"] = "Beine"
L["SLOT_feet"] = "Füße"
L["SLOT_finger"] = "Finger"
L["SLOT_trinket"] = "Schmuckstück"
L["SLOT_SELECT_ALL"] = "Alle auswählen"
L["SLOT_DESELECT_ALL"] = "Alle abwählen"
L["SLOT_NONE_SELECTED"] = "Nichts ausgewählt"
L["SLOT_weapon"] = "Waffe"
L["SLOT_offhand"] = "Nebenhand"

-- ── Voidcache-Scan (VoidcacheScan.lua / DungeonOverview.lua) ──────────────────

L["SCAN_BTN"] = "Beutespeccs scannen"
L["SCAN_PROGRESS"] = "Scanne %d/%d..."
L["SCAN_COMPLETE"] = "✓ Scan abgeschlossen"
L["SCAN_ABORTED"] = "Scan abgebrochen"
L["SCAN_CONFIRM_TITLE"] = "Beutespeccs scannen?"
L["SCAN_CONFIRM_BODY"] =
    "Dabei wird der Nebulöse-Leerencache-Tooltip für jede Beutespezialisierung in allen Saisondungeons gescannt.\n\nFolgende Schwierigkeit wird gescannt:\n|cffffff00Mythic+ Schlüsselstufe +10|r|cffaaaaaa\n\nVorhandene Dungeon-Beutedaten werden zurückgesetzt.\n\nWähre des Scans nicht in Kampf oder Dungeon eintreten."
L["SCAN_UNAVAILABLE_COMBAT"] = "Scan während des Kampfes nicht möglich."
L["SCAN_UNAVAILABLE_INSTANCE"] = "Scan innerhalb eines Dungeons nicht möglich."
L["RAID_SCAN_CONFIRM_TITLE"] = "Raidbeutespeccs scannen?"
L["RAID_SCAN_CONFIRM_BODY"] =
    "Dabei wird der Nebulöse-Leerencache-Tooltip für jede Beutespezialisierung in allen mythischen Raidbegegnungen gescannt.\n\nFolgende Schwierigkeit wird gescannt:\n|cffffff00Mythisch|r|cffaaaaaa\n\nVorhandene mythische Raid-Beutedaten werden zurückgesetzt.\n\nWähre des Scans nicht in den Kampf eintreten."

-- ── Slash-Befehle (Ergänzungen) ───────────────────────────────────────────────

L["HELP_REPLAYLOG"] = "  /void replaylog – alle Roll-Protokolleinträge erneut als erhalten anwenden"
L["RESTORE_COMPLETE"] = "%d Gegenstand/Gegenstände aus Backup wiederhergestellt."
L["RESTORE_NO_BACKUP"] = "Kein Backup verfügbar. Führe zuerst einen Scan durch."
L["RESTORE_FAILED"] = "Wiederherstellung fehlgeschlagen."

-- ── Bonuswurf-Bestätigungsfenster (BonusRollConfirm.lua) ─────────────────────

L["BONUS_ROLL_CONFIRM_SUBTITLE"] = "Nebulösen Leerenkern-Zug bestätigen"
L["BONUS_ROLL_CONFIRM_SPEC_LABEL"] = "Aktive Beutespezialisierung:"
L["BONUS_ROLL_CONFIRM_POOL"] = "%d Gegenstand/Gegenstände im Pool übrig"
L["BONUS_ROLL_CONFIRM_CHANCE"] = "%d%% Chance (%d gewünschte Gegenstände)"
L["BONUS_ROLL_CONFIRM_CHANCE_ONE"] = "%d%% Chance (1 gewünschter Gegenstand)"
L["BONUS_ROLL_CONFIRM_ALL_OBTAINED"] = "Alle Gegenstände für diese Spec erhalten"
L["BONUS_ROLL_CONFIRM_NO_ITEMS"] = "Keine gewünschten Gegenstände für diese Spec"
L["BONUS_ROLL_CONFIRM_NO_ITEMS_OTHER_SPECS"] = "Andere Specs haben gewünschte Gegenstände"
L["BONUS_ROLL_CONFIRM_NO_SELECTED"] = "Keine gewünschten Gegenstände"
L["BONUS_ROLL_CONFIRM_NOT_TRACKED"] = "Quelle nicht verfolgt — keine Chancenangaben verfügbar"
L["BONUS_ROLL_CONFIRM_WARNING_HEADER"] =
    "|A:Ping_Chat_Warning:14:14|a |cffffff00Das Würfeln setzt den Pechschutz zurück|r"
L["BONUS_ROLL_CONFIRM_WARNING_BODY"] =
    "Nach diesem Zug können vorher geplünderte Gegenstände wieder für alle Spezialisierungen fallen."
L["BONUS_ROLL_CONFIRM_QUESTION"] = "Möchtest du auf Beute würfeln?"
L["BONUS_ROLL_CONFIRM_ROLL"] = "Würfeln"
L["BONUS_ROLL_CONFIRM_PASS"] = "Passen"
L["BONUS_ROLL_CONFIRM_CONFIRM"] = "Würfeln bestätigen"
L["BONUS_ROLL_CONFIRM_PASS_CONFIRM"] = "Passen bestätigen"
L["BONUS_ROLL_CONFIRM_CLOSE"] = "Schließen"
L["BONUS_ROLL_POPUP_ROLL"] = "Nebulösen Leerenkern für einen Bonuswurf ausgeben?"
L["BONUS_ROLL_POPUP_PASS"] = "Diesen Bonuswurf passen?"

-- ── Optionspanel (Ergänzungen) ────────────────────────────────────────────────

L["OPTIONS_PREVIEW_BONUS_ROLL"] = "Vorschau"
L["BONUS_ROLL_CONFIRM_COST"] = "Kosten: |cffffff00%d|r  \194\183  Du hast |cffffff00%d|r"
L["OPTIONS_BONUS_ROLL_CONFIRM"] = "Bonuswurf-Fenster"
L["OPTIONS_BONUS_ROLL_CONFIRM_TOOLTIP"] =
    "Zeigt VoidcoreAdvisor-Informationen an, wenn das Nebulöse Leerenkern-Bonuswurffenster erscheint, einschließlich der aktiven Beutespezialisierung und Gegenstandschancen."
L["OPTIONS_BRC_SPEC_LIST"] = "Verbleibende Gegenstände pro Spezialisierung anzeigen"
L["OPTIONS_BRC_SPEC_LIST_TOOLTIP"] =
    "Zeigt eine Liste verbleibender Gegenstände für jede deiner Spezialisierungen im Bonuswurffenster an."
L["BRC_SWITCH_SPEC_TIP"] = "Switch specialization to %s"

-- ── VoidcoreAdvisor Reborn additions ─────────────────────────────────────────────
L["BRC_SWITCH_SPEC_TIP"] = "Zu Spezialisierung %s wechseln"
L["SPEC_LIST_TOOLTIP"] = "Verbleibende Beute für jede Beutespezialisierung"
L["BONUS_ROLL_WANTED_TOOLTIP_TITLE"] = "Gewünschte Gegenstände"
L["DIFFICULTY_NORMAL"] = "Normal"
L["DIFFICULTY_HEROIC"] = "Heroisch"
L["DIFFICULTY_MYTHIC"] = "Mythisch"
L["MARK_MODE_BUTTON"] = "Erhaltenen Gegenstand markieren"
L["MARK_MODE_ACTIVE"] = "Gegenstand anklicken, um ihn zu markieren (hier klicken zum Beenden)"
L["MARK_MODE_TIP"] = "Für Gegenstände aus einem Leerenkern-Wurf, die das Addon nicht erfasst hat. Solange aktiv, markiert ein Klick den Gegenstand für alle Spezialisierungen als erhalten; erneut klicken hebt die Markierung auf."
L["RAID_NOT_IN_DATA"] = "Dieser Schlachtzug ist noch nicht in den Beutedaten des Addons. Er wird nach Möglichkeit automatisch geladen; andernfalls aktualisiere VoidcoreAdvisor Reborn."
L["ORIGINAL_ADDON_LOADED"] = "Das originale VoidcoreAdvisor ist ebenfalls aktiv. Deaktiviere es: beide Versionen können nicht zusammen laufen."
L["BONUS_ROLL_POPUP_ROLL"] = "Bist du sicher, dass du deinen Nebulösen Leerenkern für einen Bonuswurf ausgeben möchtest?"
L["BONUS_ROLL_POPUP_PASS"] = "Bist du sicher, dass du diesen Bonuswurf auslassen möchtest?"
L["OPTIONS_BRC_CONFIRM"] = "Vor Würfeln oder Passen nachfragen"
L["OPTIONS_BRC_CONFIRM_TOOLTIP"] = "Zeigt eine Sicherheitsabfrage, wenn du auf Würfeln oder Passen klickst."

-- ── VoidcoreAdvisor Reborn 2.1 additions ──────────────────────────────────────
L["MISSING_TITLE"] = "Fehlende Gegenstände"
L["MISSING_EMPTY"] = "Du hast alle Gegenstände dieser Beutespezialisierung."
L["PANEL_NOT_FOUND"] = "Kein Boss und kein Dungeon passt zu \"%s\"."
L["EXPORT_TITLE"] = "Markierte Gegenstände exportieren"
L["IMPORT_TITLE"] = "Markierte Gegenstände importieren"
L["IMPORT_BUTTON"] = "Importieren"
L["IMPORT_OK"] = "%d Gegenstände importiert."
L["IMPORT_BAD"] = "Dieser Text ist kein gültiger Export."
L["TRANSFER_COPY_HINT"] = "Drücke Strg+C, um diesen Text zu kopieren."
L["TRANSFER_PASTE_HINT"] = "Füge hier den exportierten Text ein und klicke auf Importieren."
L["OPTIONS_THEME"] = "Farbthema"
L["OPTIONS_THEME_TOOLTIP"] = "Ändert die Farbe aller VoidcoreAdvisor-Fenster."
L["THEME_GREEN"] = "Giftgrün"
L["THEME_PURPLE"] = "Leerenlila"
L["THEME_BLUE"] = "Arkanblau"
L["ONE_ITEM_WARN"] = "Nur noch 1 Gegenstand für diese Spezialisierung: Würfeln setzt deinen Beuteschutz zurück!"
L["MARK_MODE_SHIFT_TIP"] = "Halte Umschalt und klicke einen zweiten Gegenstand, um alles dazwischen zu markieren."
L["DATA_OUTDATED"] = "Neuer Schlachtzug noch nicht in den Beutedaten: %s. Der Entwickler muss VoidcoreAdvisor Reborn aktualisieren."
L["HELP_PANEL"] = "  /void panel [Name] – Abenteuerführer bei einem Boss oder Dungeon öffnen"
L["HELP_MISSING"] = "  /void missing [14|15|16] – alle noch fehlenden Gegenstände auflisten"
L["HELP_EXPORT"] = "  /void export – markierte Gegenstände als Text kopieren"
L["HELP_IMPORT"] = "  /void import – markierte Gegenstände eines anderen Charakters einfügen"
L["HELP_THEME"] = "  /void theme green|purple|blue – Fensterfarben ändern"
L["HELP_RESETPANEL"] = "  /void resetpanel – Panel wieder neben den Abenteuerführer setzen"
