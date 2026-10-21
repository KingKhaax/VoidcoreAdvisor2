-- VoidcoreAdvisor: Locale – Italian
if GetLocale() ~= "itIT" then
    return
end
local _, VCA = ...
local L = VCA.L

-- ── Panel UI ──────────────────────────────────────────────────────────────────

L["PANEL_TITLE"] = "|cffb048f8Voidcore|r|cffddddddAdvisor|r"

L["COL_LOOT"] = "BOTTINO"
L["COL_SPEC_RANKING"] = "CLASSIFICA SPEC."
L["COL_SPEC_FIT"] = "COMPAT. SPEC."
L["COL_LOOT_FILTERED"] = "BOTTINO (filtrato)"
L["COL_LOOT_FILTERED_N"] = "BOTTINO (filtrate %d spec.)"

L["CONTENT_RAID_BOSS"] = "Boss dell'incursione"
L["CONTENT_MP_DUNGEON"] = "Spedizione M+"
L["NEBULOUS_VOIDCORE"] = "Nucleo del Vuoto nebuloso"
L["NEBULOUS_VOIDCORES"] = "Nuclei del Vuoto nebulosi"

L["NO_ITEMS_FOR_SPEC"] = "Nessun oggetto per questa specializzazione"

L["LOOT_SPEC_LABEL"] = "Bottino:"
L["ALL_OBTAINED"] = "✓ tutti"

L["DETECTED_OBTAINED"] = "%s rilevato automaticamente come ottenuto tramite Nucleo del Vuoto nebuloso."

L["CLEAR_SELECTED"] = "Cancella selezione"

-- ── Slash commands ────────────────────────────────────────────────────────────

L["RESET_CONFIRM"] = "Tutti i dati degli oggetti ottenuti sono stati reimpostati."
L["NEW_SEASON_RESET"] = "Nuova stagione rilevata — gli oggetti selezionati e ottenuti sono stati cancellati."
L["COUNT_FORMAT"] = "%d oggetto/i contrassegnato/i come ottenuto/i tramite Nucleo del Vuoto."
L["SPEC_FORMAT"] = "ID specializzazione bottino attiva: %s%s"
L["FOLLOWS_ACTIVE_SPEC"] = " (segue la specializzazione attiva)"
L["SOURCE_FORMAT"] = "Fonte attiva — tipo: %s  IDfonte: %s  difficoltà: %s"
L["NO_ACTIVE_SOURCE"] = "Nessuna fonte attiva impostata."
L["VERSION_FORMAT"] = "Versione %s"
L["HELP_HEADER"] = "Comandi:"
L["HELP_RESET"] = "  /vca2 reset    – reimposta dati degli oggetti ottenuti"
L["HELP_COUNT"] = "  /vca2 count    – mostra il totale degli oggetti ottenuti"
L["HELP_SPEC"] = "  /vca2 spec     – mostra l'ID della specializzazione bottino"
L["HELP_SOURCE"] = "  /vca2 source   – mostra la fonte di rilevamento attiva"
L["HELP_VERSION"] = "  /vca2 version  – mostra la versione dell'addon"
L["HELP_RESTORE"] = "  /vca2 restore  – ripristina i dati del bottino dal backup pre-scansione"

-- ── Panel UI (aggiunte) ───────────────────────────────────────────────────────

L["LFR_NOT_ELIGIBLE"] = "Non disponibile nel Cercatore di incursione"

L["TOGGLE_SHOW"] = "Clic per mostrare il pannello di consigli."
L["TOGGLE_HIDE"] = "Clic per nascondere il pannello di consigli."
L["TOGGLE_OVERVIEW_SHOW"] = "Clic per mostrare il riepilogo delle spedizioni."
L["TOGGLE_OVERVIEW_HIDE"] = "Clic per nascondere il riepilogo delle spedizioni."

-- ── Popup di promemoria (Reminder.lua) ───────────────────────────────────────

L["REMINDER_TITLE"] = "|cffb048f8Voidcore|r|cffddddddAdvisor|r"
L["REMINDER_SUBTITLE"] = "Ottimizza la tua specializzazione bottino per le ricompense del Nucleo del Vuoto nebuloso!"
L["REMINDER_VOIDCORE_COUNT"] = "Hai |cffffff00%d|r Nucleo/i del Vuoto nebuloso"
L["REMINDER_CURRENT_SPEC"] = "Spec. bottino corrente:"
L["REMINDER_RECOMMENDED"] = "Spec. consigliata:"
L["REMINDER_ITEMS_SELECTED"] = "%d oggetto/i selezionato/i"
L["REMINDER_SELECTED_CHANCE"] = "%d%% di probabilità per oggetti selezionati"
L["REMINDER_CHANGE_PROMPT"] = "Cambiare specializzazione bottino in |cffffff00%s|r?"
L["REMINDER_YES"] = "Sì, cambia"
L["REMINDER_NO"] = "No grazie"
L["REMINDER_WARNING_ONE_ITEM"] =
    "|cffff8000Attenzione:|r Questa specializzazione ha |cffff0000solo 1 oggetto|r rimanente in questa spedizione. Usare un Nucleo del Vuoto nebuloso con questa specializzazione |cffff0000azzererà il pool bottino per tutte le specializzazioni|r in questa spedizione!"
L["REMINDER_SPEC_LIST_HEADER"] = "Oggetti rimanenti per specializzazione:"
L["REMINDER_SPEC_REMAINING"] = "%d rimanente/i"
L["REMINDER_SPEC_NONE"] = "nessuno rimanente"
L["SPEC_LIST_TOOLTIP_TITLE"] = "Protezione del bottino"
L["SPEC_LIST_ITEM_ONE"] = "1 oggetto rimanente"
L["SPEC_LIST_ITEM_MANY"] = "%d oggetti rimanenti"
L["SPEC_LIST_ALL_OBTAINED"] = "tutti ottenuti"

-- ── Popup avviso reset pool bottino (Reminder.lua) ────────────────────────────

L["WARNING_TITLE"] = "|cffb048f8Voidcore|r|cffddddddAdvisor|r"
L["WARNING_SUBTITLE"] = "Rischio reset pool bottino"
L["WARNING_VOIDCORE_COUNT"] = "Hai |cffffff00%d|r Nucleo/i del Vuoto nebuloso"
L["WARNING_FAVORED_SPEC"] = "Stai usando la specializzazione bottino preferita:"
L["WARNING_ONE_ITEM"] =
    "|cffff8000Attenzione:|r Questa specializzazione ha |cffff0000solo %d oggetto|r rimanente in questa spedizione. Usare un Nucleo del Vuoto nebuloso |cffff0000azzererà il pool bottino per tutte le specializzazioni|r in questa spedizione!"
L["WARNING_SPEC_LIST_HEADER"] = "Oggetti rimanenti per specializzazione:"
L["WARNING_CLOSE"] = "Chiudi"

-- ── Pannello opzioni (Options.lua) ────────────────────────────────────────────

L["OPTIONS_CAT_REMINDER"] = "Promemoria specializzazione bottino"
L["OPTIONS_CAT_BONUS_ROLL"] = "Tiro bonus"

L["OPTIONS_REMINDER_ENABLE"] = "Promemoria specializzazione bottino"
L["OPTIONS_REMINDER_TOOLTIP"] =
    "Mostra un popup quando si entra in una spedizione mitica della stagione corrente se una specializzazione bottino diversa darebbe migliori probabilità per gli oggetti selezionati."
L["OPTIONS_PREVIEW_REMINDER"] = "Anteprima"

-- ── Pannello riepilogo spedizioni (DungeonOverview.lua) ───────────────────────

L["DUNGEON_OVERVIEW_SUBTITLE"] = "Spedizioni M+ — Probabilità bottino"
L["DUNGEON_OVERVIEW_COL_DUNGEON"] = "SPEDIZIONE"
L["DUNGEON_OVERVIEW_COL_SPEC"] = "SPEC."
L["DUNGEON_OVERVIEW_COL_LOOTED"] = "SACCHEGGIATO"
L["DUNGEON_OVERVIEW_COL_CHANCE"] = "CHANCE"
L["DUNGEON_OVERVIEW_ALL_DONE"] = "Tutti gli oggetti della spedizione ottenuti!"
L["DUNGEON_OVERVIEW_NO_DATA"] = "Dati stagionali delle spedizioni non ancora disponibili."

L["RAID_OVERVIEW_SUBTITLE"] = "Boss dell'incursione — Probabilità bottino"
L["RAID_OVERVIEW_COL_BOSS"] = "BOSS"
L["RAID_OVERVIEW_NO_DATA"] = "Nessun dato di scontro nell'incursione disponibile."

-- ── Popup selezione specializzazione (PanelColumns.lua) ──────────────────────

L["SPEC_PICKER_TITLE"] = "Ottenuto come:"
L["SPEC_PICKER_OK"] = "OK"
L["OBTAINED_UNKNOWN_SPEC"] = "Ottenuto (specializzazione sconosciuta)"
L["UNKNOWN_KEYLEVEL"] = "livello chiave sconosciuto"
L["MANUAL_ENTRY"] = "inserimento manuale"

-- ── Cassetto slot (DungeonOverview.lua) ──────────────────────────────────────

L["SLOT_FILTER_TOGGLE"] = "Filtra per slot"
L["SLOT_FILTER_CLEAR"] = "Deseleziona tutti gli oggetti dello slot"
L["SLOT_FILTER_CLEAR_CONFIRM"] = "Cancellare tutte le selezioni di oggetti?"
L["SLOT_FILTER_CLEAR_CONFIRM_BODY"] = "Tutti gli oggetti selezionati verranno deselezionati."

L["SLOT_head"] = "Testa"
L["SLOT_neck"] = "Collo"
L["SLOT_shoulder"] = "Spalle"
L["SLOT_back"] = "Schiena"
L["SLOT_chest"] = "Busto"
L["SLOT_wrist"] = "Polso"
L["SLOT_hands"] = "Mani"
L["SLOT_waist"] = "Vita"
L["SLOT_legs"] = "Gambe"
L["SLOT_feet"] = "Piedi"
L["SLOT_finger"] = "Dito"
L["SLOT_trinket"] = "Gingillo"
L["SLOT_SELECT_ALL"] = "Seleziona tutto"
L["SLOT_DESELECT_ALL"] = "Deseleziona tutto"
L["SLOT_NONE_SELECTED"] = "Nessuna selezione"
L["SLOT_weapon"] = "Arma"
L["SLOT_offhand"] = "Mano secondaria"

-- ── Scansione Voidcache (VoidcacheScan.lua / DungeonOverview.lua) ─────────────

L["SCAN_BTN"] = "Scansione spec. bottino"
L["SCAN_PROGRESS"] = "Scansione %d/%d..."
L["SCAN_COMPLETE"] = "✓ Scansione completata"
L["SCAN_ABORTED"] = "Scansione annullata"
L["SCAN_CONFIRM_TITLE"] = "Scansionare spec. di bottino?"
L["SCAN_CONFIRM_BODY"] =
    "Verranno analizzati i tooltip del Voidcache Nebuloso per ogni specializzazione bottino in tutti i dungeon della stagione.\n\nDifficoltà analizzata:\n|cffffff00Mitico+ livello chiave +10|r|cffaaaaaa\n\nI dati esistenti sugli oggetti ottenuti saranno reimpostati.\n\nNon entrare in combattimento o in un dungeon durante la scansione."
L["SCAN_UNAVAILABLE_COMBAT"] = "Impossibile eseguire la scansione in combattimento."
L["SCAN_UNAVAILABLE_INSTANCE"] = "Impossibile eseguire la scansione all'interno di un dungeon."
L["RAID_SCAN_CONFIRM_TITLE"] = "Scansionare spec. di bottino dell'incursione?"
L["RAID_SCAN_CONFIRM_BODY"] =
    "Verranno analizzati i tooltip del Voidcache Nebuloso per ogni specializzazione bottino in tutti gli scontri Mitico dell'incursione.\n\nDifficoltà analizzata:\n|cffffff00Mitico|r|cffaaaaaa\n\nI dati esistenti degli oggetti Mitico dell'incursione saranno reimpostati.\n\nNon entrare in combattimento durante la scansione."

-- ── Comandi slash (aggiunte) ──────────────────────────────────────────────────

L["HELP_REPLAYLOG"] = "  /vca2 replaylog – riapplica tutte le voci del registro dei tiri come ottenute"
L["RESTORE_COMPLETE"] = "%d oggetto/i ripristinato/i dal backup."
L["RESTORE_NO_BACKUP"] = "Nessun backup disponibile. Esegui prima una scansione."
L["RESTORE_FAILED"] = "Ripristino fallito."

-- ── Finestra di conferma tiro bonus (BonusRollConfirm.lua) ───────────────────

L["BONUS_ROLL_CONFIRM_SUBTITLE"] = "Conferma tiro Nucleo del Vuoto nebuloso"
L["BONUS_ROLL_CONFIRM_SPEC_LABEL"] = "Spec. bottino attiva:"
L["BONUS_ROLL_CONFIRM_POOL"] = "%d oggetto/i rimanente/i nel gruppo"
L["BONUS_ROLL_CONFIRM_CHANCE"] = "%d%% di probabilità (%d oggetti desiderati)"
L["BONUS_ROLL_CONFIRM_CHANCE_ONE"] = "%d%% di probabilità (1 oggetto desiderato)"
L["BONUS_ROLL_CONFIRM_ALL_OBTAINED"] = "Tutti gli oggetti ottenuti per questa spec"
L["BONUS_ROLL_CONFIRM_NO_ITEMS"] = "Nessun oggetto desiderato per questa spec"
L["BONUS_ROLL_CONFIRM_NO_ITEMS_OTHER_SPECS"] = "Altre specializzazioni hanno oggetti desiderati"
L["BONUS_ROLL_CONFIRM_NO_SELECTED"] = "Nessun oggetto desiderato"
L["BONUS_ROLL_CONFIRM_NOT_TRACKED"] = "Fonte non tracciata — nessuna probabilità disponibile"
L["BONUS_ROLL_CONFIRM_WARNING_HEADER"] =
    "|A:Ping_Chat_Warning:14:14|a |cffffff00Tirare azzererà la protezione dalla sfortuna|r"
L["BONUS_ROLL_CONFIRM_WARNING_BODY"] =
    "Dopo questo tiro, oggetti precedentemente ottenuti possono droppare di nuovo per tutte le specializzazioni."
L["BONUS_ROLL_CONFIRM_QUESTION"] = "Vuoi tirare per il bottino?"
L["BONUS_ROLL_CONFIRM_ROLL"] = "Tira"
L["BONUS_ROLL_CONFIRM_PASS"] = "Passa"
L["BONUS_ROLL_CONFIRM_CONFIRM"] = "Conferma tiro"
L["BONUS_ROLL_CONFIRM_PASS_CONFIRM"] = "Conferma passaggio"
L["BONUS_ROLL_CONFIRM_CLOSE"] = "Chiudi"
L["BONUS_ROLL_POPUP_ROLL"] = "Usare il Nucleo del Vuoto nebuloso per un tiro bonus?"
L["BONUS_ROLL_POPUP_PASS"] = "Passare questo tiro bonus?"

-- ── Pannello opzioni (aggiunte) ───────────────────────────────────────────────

L["OPTIONS_PREVIEW_BONUS_ROLL"] = "Anteprima"
L["BONUS_ROLL_CONFIRM_COST"] = "Costo: |cffffff00%d|r  \194\183  Hai |cffffff00%d|r"
L["OPTIONS_BONUS_ROLL_CONFIRM"] = "Finestra tiro bonus"
L["OPTIONS_BONUS_ROLL_CONFIRM_TOOLTIP"] =
    "Mostra le informazioni di VoidcoreAdvisor quando appare la finestra di tiro bonus del Nucleo del Vuoto nebuloso, inclusa la specializzazione bottino attiva e le probabilità degli oggetti."
L["OPTIONS_BRC_SPEC_LIST"] = "Mostra oggetti rimanenti per specializzazione"
L["OPTIONS_BRC_SPEC_LIST_TOOLTIP"] =
    "Mostra un elenco di oggetti rimanenti per ciascuna delle tue specializzazioni nella finestra di tiro bonus."
L["BRC_SWITCH_SPEC_TIP"] = "Switch specialization to %s"

-- ── VoidcoreAdvisor 2.0 additions ─────────────────────────────────────────────
L["BRC_SWITCH_SPEC_TIP"] = "Passa alla specializzazione %s"
L["SPEC_LIST_TOOLTIP"] = "Bottino rimanente per ogni specializzazione del bottino"
L["BONUS_ROLL_WANTED_TOOLTIP_TITLE"] = "Oggetti desiderati"
L["DIFFICULTY_NORMAL"] = "Normale"
L["DIFFICULTY_HEROIC"] = "Eroico"
L["DIFFICULTY_MYTHIC"] = "Mitico"
L["MARK_MODE_BUTTON"] = "Segna oggetto ottenuto"
L["MARK_MODE_ACTIVE"] = "Clicca su un oggetto per segnarlo (clicca qui per terminare)"
L["MARK_MODE_TIP"] = "Usalo per gli oggetti ottenuti con un tiro Nucleo del Vuoto che l'addon non ha registrato. Finché è attivo, clicca su un oggetto per segnarlo come ottenuto per tutte le specializzazioni, o clicca di nuovo per rimuovere il segno."
L["RAID_NOT_IN_DATA"] = "Questa incursione non è ancora nei dati di bottino dell'addon. Si carica automaticamente quando possibile; altrimenti aggiorna VoidcoreAdvisor 2.0."
L["ORIGINAL_ADDON_LOADED"] = "Anche il VoidcoreAdvisor originale è attivo. Disattivalo: le due versioni non possono funzionare insieme."
