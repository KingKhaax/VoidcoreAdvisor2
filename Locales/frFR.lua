-- VoidcoreAdvisor: Locale – French
local _, VCA = ...
if (VCA.ForcedLocale or GetLocale()) ~= "frFR" then
    return
end
local L = VCA.L

-- ── Panel UI ──────────────────────────────────────────────────────────────────

L["PANEL_TITLE"] = "|cff8fe36bVoidcore|r|cffffffffConseiller|r"

L["COL_LOOT"] = "BUTIN"
L["COL_SPEC_RANKING"] = "CLASSEMENT SPÉC."
L["COL_SPEC_FIT"] = "COMPAT. SPÉC."
L["COL_LOOT_FILTERED"] = "BUTIN (filtré)"
L["COL_LOOT_FILTERED_N"] = "BUTIN (filtré %d spéc.)"

L["CONTENT_RAID_BOSS"] = "Boss de raid"
L["CONTENT_MP_DUNGEON"] = "Donjon M+"
L["NEBULOUS_VOIDCORE"] = "Noyau du Vide nébuleux"
L["NEBULOUS_VOIDCORES"] = "Noyaux du Vide nébuleux"

L["NO_ITEMS_FOR_SPEC"] = "Aucun objet pour cette spécialisation"

L["LOOT_SPEC_LABEL"] = "Butin :"
L["ALL_OBTAINED"] = "✓ tous"

L["DETECTED_OBTAINED"] = "%s détecté automatiquement comme obtenu via un Noyau du Vide nébuleux."

L["CLEAR_SELECTED"] = "Effacer la sélection"

-- ── Slash commands ────────────────────────────────────────────────────────────

L["RESET_CONFIRM"] = "Toutes les données d'objets obtenus ont été réinitialisées."
L["NEW_SEASON_RESET"] = "Nouvelle saison détectée — les objets sélectionnés et obtenus ont été effacés."
L["COUNT_FORMAT"] = "%d objet(s) marqué(s) comme obtenu(s) via Noyau du Vide."
L["SPEC_FORMAT"] = "ID de spécialisation de butin active : %s%s"
L["FOLLOWS_ACTIVE_SPEC"] = " (suit la spécialisation active)"
L["SOURCE_FORMAT"] = "Source active — type : %s  IDsource : %s  difficulté : %s"
L["NO_ACTIVE_SOURCE"] = "Aucune source active définie."
L["VERSION_FORMAT"] = "Version %s"
L["HELP_HEADER"] = "Commandes :"
L["HELP_RESET"] = "  /void reset    – réinitialiser les données d'objets obtenus"
L["HELP_COUNT"] = "  /void count    – afficher le nombre total d'objets obtenus"
L["HELP_SPEC"] = "  /void spec     – afficher l'ID de spécialisation de butin"
L["HELP_SOURCE"] = "  /void source   – afficher la source de détection active"
L["HELP_VERSION"] = "  /void version  – afficher la version de l'addon"
L["HELP_RESTORE"] = "  /void restore  – restaurer les données de butin depuis la sauvegarde"

-- ── Panel UI (ajouts) ─────────────────────────────────────────────────────────

L["LFR_NOT_ELIGIBLE"] = "Indisponible en Recherche de raid"

L["TOGGLE_SHOW"] = "Cliquer pour afficher le panneau de conseils."
L["TOGGLE_HIDE"] = "Cliquer pour masquer le panneau de conseils."
L["TOGGLE_OVERVIEW_SHOW"] = "Cliquer pour afficher la vue d'ensemble des donjons."
L["TOGGLE_OVERVIEW_HIDE"] = "Cliquer pour masquer la vue d'ensemble des donjons."

-- ── Popup de rappel (Reminder.lua) ───────────────────────────────────────────

L["REMINDER_TITLE"] = "|cff8fe36bVoidcore|r|cffffffffConseiller|r"
L["REMINDER_SUBTITLE"] = "Optimisez votre spécialisation de butin pour les récompenses du Noyau du Vide nébuleux !"
L["REMINDER_VOIDCORE_COUNT"] = "Vous avez |cffffff00%d|r Noyau(x) du Vide nébuleux"
L["REMINDER_CURRENT_SPEC"] = "Spécialisation de butin actuelle :"
L["REMINDER_RECOMMENDED"] = "Spécialisation recommandée :"
L["REMINDER_ITEMS_SELECTED"] = "%d objet(s) sélectionné(s)"
L["REMINDER_SELECTED_CHANCE"] = "%d%% de chance pour l'objet sélectionné"
L["REMINDER_CHANGE_PROMPT"] = "Changer la spécialisation de butin pour |cffffff00%s|r ?"
L["REMINDER_YES"] = "Oui, changer"
L["REMINDER_NO"] = "Non merci"
L["REMINDER_WARNING_ONE_ITEM"] =
    "|cffff8000Avertissement :|r Cette spécialisation n'a plus que |cffff00001 objet|r restant dans ce donjon. Utiliser un Noyau du Vide nébuleux avec cette spécialisation |cffff0000réinitialisera le groupe de butin de toutes les spécialisations|r dans ce donjon !"
L["REMINDER_SPEC_LIST_HEADER"] = "Objets restants par spécialisation :"
L["REMINDER_SPEC_REMAINING"] = "%d restant(s)"
L["REMINDER_SPEC_NONE"] = "aucun restant"
L["SPEC_LIST_TOOLTIP_TITLE"] = "Protection du butin"
L["SPEC_LIST_ITEM_ONE"] = "1 objet restant"
L["SPEC_LIST_ITEM_MANY"] = "%d objets restants"
L["SPEC_LIST_ALL_OBTAINED"] = "tous obtenus"

-- ── Popup d'avertissement de réinitialisation du groupe de butin (Reminder.lua) ──

L["WARNING_TITLE"] = "|cff8fe36bVoidcore|r|cffffffffConseiller|r"
L["WARNING_SUBTITLE"] = "Risque de réinitialisation du groupe de butin"
L["WARNING_VOIDCORE_COUNT"] = "Vous avez |cffffff00%d|r Noyau(x) du Vide nébuleux"
L["WARNING_FAVORED_SPEC"] = "Vous utilisez la spécialisation de butin favorite :"
L["WARNING_ONE_ITEM"] =
    "|cffff8000Avertissement :|r Cette spécialisation n'a plus que |cffff0000%d objet|r restant dans ce donjon. Utiliser un Noyau du Vide nébuleux |cffff0000réinitialisera le groupe de butin de toutes les spécialisations|r dans ce donjon !"
L["WARNING_SPEC_LIST_HEADER"] = "Objets restants par spécialisation :"
L["WARNING_CLOSE"] = "Fermer"

-- ── Panneau d'options (Options.lua) ──────────────────────────────────────────

L["OPTIONS_CAT_REMINDER"] = "Rappel de spécialisation de butin"
L["OPTIONS_CAT_BONUS_ROLL"] = "Jet bonus"

L["OPTIONS_REMINDER_ENABLE"] = "Rappel de spécialisation de butin"
L["OPTIONS_REMINDER_TOOLTIP"] =
    "Affiche un popup lors de l'entrée dans un donjon mythique de la saison actuelle si une spécialisation de butin différente donnerait de meilleures chances pour vos objets sélectionnés."
L["OPTIONS_PREVIEW_REMINDER"] = "Aperçu"

-- ── Panneau de vue d'ensemble des donjons (DungeonOverview.lua) ──────────────

L["DUNGEON_OVERVIEW_SUBTITLE"] = "Donjons M+ — Chance de butin"
L["DUNGEON_OVERVIEW_COL_DUNGEON"] = "DONJON"
L["DUNGEON_OVERVIEW_COL_SPEC"] = "SPÉC."
L["DUNGEON_OVERVIEW_COL_LOOTED"] = "PILLÉ"
L["DUNGEON_OVERVIEW_COL_CHANCE"] = "CHANCE"
L["DUNGEON_OVERVIEW_ALL_DONE"] = "Tous les objets du donjon obtenus !"
L["DUNGEON_OVERVIEW_NO_DATA"] = "Données de donjon saisonnières pas encore disponibles."

L["RAID_OVERVIEW_SUBTITLE"] = "Boss de raid — Chance de butin"
L["RAID_OVERVIEW_COL_BOSS"] = "BOSS"
L["RAID_OVERVIEW_NO_DATA"] = "Aucune donnée d'affrontement de raid disponible."

-- ── Popup de sélection de spécialisation (PanelColumns.lua) ──────────────────

L["SPEC_PICKER_TITLE"] = "Obtenu en tant que :"
L["SPEC_PICKER_OK"] = "OK"
L["OBTAINED_UNKNOWN_SPEC"] = "Obtenu (spécialisation inconnue)"
L["UNKNOWN_KEYLEVEL"] = "niveau de clé inconnu"
L["MANUAL_ENTRY"] = "entrée manuelle"

-- ── Tiroir d'emplacements (DungeonOverview.lua) ──────────────────────────────

L["SLOT_FILTER_TOGGLE"] = "Filtrer par emplacement"
L["SLOT_FILTER_CLEAR"] = "Désélectionner tous les objets d'emplacement"
L["SLOT_FILTER_CLEAR_CONFIRM"] = "Effacer toutes les sélections d'objets ?"
L["SLOT_FILTER_CLEAR_CONFIRM_BODY"] = "Tous les objets sélectionnés seront désélectionnés."

L["SLOT_head"] = "Tête"
L["SLOT_neck"] = "Cou"
L["SLOT_shoulder"] = "Épaules"
L["SLOT_back"] = "Dos"
L["SLOT_chest"] = "Torse"
L["SLOT_wrist"] = "Poignets"
L["SLOT_hands"] = "Mains"
L["SLOT_waist"] = "Taille"
L["SLOT_legs"] = "Jambes"
L["SLOT_feet"] = "Pieds"
L["SLOT_finger"] = "Doigt"
L["SLOT_trinket"] = "Bijou"
L["SLOT_SELECT_ALL"] = "Tout sélectionner"
L["SLOT_DESELECT_ALL"] = "Tout désélectionner"
L["SLOT_NONE_SELECTED"] = "Rien de sélectionné"
L["SLOT_weapon"] = "Arme"
L["SLOT_offhand"] = "Main secondaire"

-- ── Scan de Voidcache (VoidcacheScan.lua / DungeonOverview.lua) ───────────────

L["SCAN_BTN"] = "Scanner les specs de butin"
L["SCAN_PROGRESS"] = "Scan en cours %d/%d..."
L["SCAN_COMPLETE"] = "✓ Scan terminé"
L["SCAN_ABORTED"] = "Scan annulé"
L["SCAN_CONFIRM_TITLE"] = "Scanner les specs de butin ?"
L["SCAN_CONFIRM_BODY"] =
    "Cela analysera l'infobulle du Voidcache nébuleux pour chacune de vos spécialisations de butin dans tous les donjons de la saison.\n\nDifficulté analysée :\n|cffffff00Mythique+ niveau de clé +10|r|cffaaaaaa\n\nLes données de butin existantes seront réinitialisées.\n\nN'entrez pas en combat ni dans un donjon pendant le scan."
L["SCAN_UNAVAILABLE_COMBAT"] = "Impossible de scanner en combat."
L["SCAN_UNAVAILABLE_INSTANCE"] = "Impossible de scanner dans un donjon."
L["RAID_SCAN_CONFIRM_TITLE"] = "Scanner les specs de butin du raid ?"
L["RAID_SCAN_CONFIRM_BODY"] =
    "Cela analysera l'infobulle du Voidcache nébuleux pour chacune de vos spécialisations de butin dans tous les affrontements de raid Mythique.\n\nDifficulté analysée :\n|cffffff00Mythique|r|cffaaaaaa\n\nLes données de raid Mythique existantes seront réinitialisées.\n\nN'entrez pas en combat pendant le scan."

-- ── Commandes slash (ajouts) ──────────────────────────────────────────────────

L["HELP_REPLAYLOG"] = "  /void replaylog – réappliquer toutes les entrées du journal de jets comme obtenues"
L["RESTORE_COMPLETE"] = "%d objet(s) restauré(s) depuis la sauvegarde."
L["RESTORE_NO_BACKUP"] = "Aucune sauvegarde disponible. Effectuez d'abord un scan."
L["RESTORE_FAILED"] = "La restauration a échoué."

-- ── Fenêtre de confirmation de jet bonus (BonusRollConfirm.lua) ───────────────

L["BONUS_ROLL_CONFIRM_SUBTITLE"] = "Confirmer le jet de Noyau du Vide nébuleux"
L["BONUS_ROLL_CONFIRM_SPEC_LABEL"] = "Spécialisation de butin active :"
L["BONUS_ROLL_CONFIRM_POOL"] = "%d objet(s) restant dans le groupe"
L["BONUS_ROLL_CONFIRM_CHANCE"] = "%d%% de chance (%d objets désirés)"
L["BONUS_ROLL_CONFIRM_CHANCE_ONE"] = "%d%% de chance (1 objet désiré)"
L["BONUS_ROLL_CONFIRM_ALL_OBTAINED"] = "Tous les objets obtenus pour cette spéc"
L["BONUS_ROLL_CONFIRM_NO_ITEMS"] = "Aucun objet souhaité pour cette spéc"
L["BONUS_ROLL_CONFIRM_NO_ITEMS_OTHER_SPECS"] = "D'autres spécialisations ont des objets souhaités"
L["BONUS_ROLL_CONFIRM_NO_SELECTED"] = "Aucun objet désiré"
L["BONUS_ROLL_CONFIRM_NOT_TRACKED"] = "Source non suivie — aucune estimation disponible"
L["BONUS_ROLL_CONFIRM_WARNING_HEADER"] =
    "|A:Ping_Chat_Warning:14:14|a |cffffff00Lancer les dés réinitialisera la protection contre la malchance|r"
L["BONUS_ROLL_CONFIRM_WARNING_BODY"] =
    "Après ce jet, les objets précédemment pillés peuvent à nouveau tomber pour toutes les spécialisations."
L["BONUS_ROLL_CONFIRM_QUESTION"] = "Voulez-vous lancer pour du butin ?"
L["BONUS_ROLL_CONFIRM_ROLL"] = "Lancer"
L["BONUS_ROLL_CONFIRM_PASS"] = "Passer"
L["BONUS_ROLL_CONFIRM_CONFIRM"] = "Confirmer le lancer"
L["BONUS_ROLL_CONFIRM_PASS_CONFIRM"] = "Confirmer le passage"
L["BONUS_ROLL_CONFIRM_CLOSE"] = "Fermer"
L["BONUS_ROLL_POPUP_ROLL"] = "Dépenser votre Noyau du Vide nébuleux pour un jet bonus ?"
L["BONUS_ROLL_POPUP_PASS"] = "Passer ce jet bonus ?"

-- ── Panneau d'options (ajouts) ────────────────────────────────────────────────

L["OPTIONS_PREVIEW_BONUS_ROLL"] = "Aperçu"
L["BONUS_ROLL_CONFIRM_COST"] = "Coût : |cffffff00%d|r  \194\183  Vous avez |cffffff00%d|r"
L["OPTIONS_BONUS_ROLL_CONFIRM"] = "Fenêtre de jet bonus"
L["OPTIONS_BONUS_ROLL_CONFIRM_TOOLTIP"] =
    "Affiche les informations de VoidcoreAdvisor lorsque la fenêtre de jet bonus du Noyau du Vide nébuleux apparaît, incluant votre spécialisation de butin active et les probabilités d'objets."
L["OPTIONS_BRC_SPEC_LIST"] = "Afficher les objets restants par spécialisation"
L["OPTIONS_BRC_SPEC_LIST_TOOLTIP"] =
    "Affiche une liste des objets restants pour chacune de vos spécialisations dans la fenêtre de jet bonus."
L["BRC_SWITCH_SPEC_TIP"] = "Switch specialization to %s"

-- ── VoidcoreAdvisor Reborn additions ─────────────────────────────────────────────
L["BRC_SWITCH_SPEC_TIP"] = "Passer à la spécialisation %s"
L["SPEC_LIST_TOOLTIP"] = "Butin restant pour chaque spécialisation de butin"
L["BONUS_ROLL_WANTED_TOOLTIP_TITLE"] = "Objets souhaités"
L["DIFFICULTY_NORMAL"] = "Normal"
L["DIFFICULTY_HEROIC"] = "Héroïque"
L["DIFFICULTY_MYTHIC"] = "Mythique"
L["MARK_MODE_BUTTON"] = "Marquer un objet obtenu"
L["MARK_MODE_ACTIVE"] = "Cliquez sur un objet pour le marquer (cliquez ici pour arrêter)"
L["MARK_MODE_TIP"] = "À utiliser pour les objets obtenus avec un jet de Noyau du Vide que l'addon n'a pas suivis. Tant que le mode est actif, cliquez sur un objet pour le marquer comme obtenu pour toutes les spécialisations, ou cliquez de nouveau pour le démarquer."
L["RAID_NOT_IN_DATA"] = "Ce raid n'est pas encore dans les données de butin de l'addon. Il se charge automatiquement quand c'est possible ; sinon, mettez à jour VoidcoreAdvisor Reborn."
L["ORIGINAL_ADDON_LOADED"] = "Le VoidcoreAdvisor d'origine est aussi activé. Désactivez-le : les deux versions ne peuvent pas fonctionner ensemble."
L["BONUS_ROLL_POPUP_ROLL"] = "Voulez-vous vraiment dépenser votre Noyau du Vide nébuleux pour un jet bonus ?"
L["BONUS_ROLL_POPUP_PASS"] = "Voulez-vous vraiment passer ce jet bonus ?"
L["OPTIONS_BRC_CONFIRM"] = "Demander confirmation avant de lancer ou de passer"
L["OPTIONS_BRC_CONFIRM_TOOLTIP"] = "Affiche un message « Êtes-vous sûr ? » quand vous cliquez sur Lancer ou Passer."

-- ── VoidcoreAdvisor Reborn 2.1 additions ──────────────────────────────────────
L["MISSING_TITLE"] = "Objets manquants"
L["MISSING_EMPTY"] = "Vous avez tous les objets de cette spécialisation de butin."
L["PANEL_NOT_FOUND"] = "Aucun boss ni donjon ne correspond à \"%s\"."
L["EXPORT_TITLE"] = "Exporter les objets marqués"
L["IMPORT_TITLE"] = "Importer les objets marqués"
L["IMPORT_BUTTON"] = "Importer"
L["IMPORT_OK"] = "%d objets importés."
L["IMPORT_BAD"] = "Ce texte n'est pas une exportation valide."
L["TRANSFER_COPY_HINT"] = "Appuyez sur Ctrl+C pour copier ce texte."
L["TRANSFER_PASTE_HINT"] = "Collez ici le texte exporté, puis cliquez sur Importer."
L["OPTIONS_THEME"] = "Thème de couleur"
L["OPTIONS_THEME_TOOLTIP"] = "Change la couleur de toutes les fenêtres de VoidcoreAdvisor."
L["THEME_GREEN"] = "Vert venin"
L["THEME_PURPLE"] = "Violet du Vide"
L["THEME_BLUE"] = "Bleu arcanique"
L["ONE_ITEM_WARN"] = "Il ne reste qu'1 objet pour cette spécialisation : lancer réinitialisera votre protection de butin !"
L["MARK_MODE_SHIFT_TIP"] = "Maintenez Maj et cliquez sur un second objet pour marquer tous ceux entre les deux."
L["DATA_OUTDATED"] = "Nouveau raid pas encore dans les données de butin : %s. Le développeur doit mettre à jour VoidcoreAdvisor Reborn."
L["HELP_PANEL"] = "  /void panel [nom] – ouvrir le Journal des aventures sur un boss ou un donjon"
L["HELP_MISSING"] = "  /void missing [14|15|16] – lister tous les objets qu'il vous manque"
L["HELP_EXPORT"] = "  /void export – copier vos objets marqués sous forme de texte"
L["HELP_IMPORT"] = "  /void import – coller les objets marqués d'un autre personnage"
L["HELP_THEME"] = "  /void theme <name> – changer les couleurs des fenêtres"
L["HELP_RESETPANEL"] = "  /void resetpanel – remettre le panneau à côté du journal"
L["THEME_LIGHT"] = "Lumière"
L["THEME_FIRE"] = "Feu"
L["THEME_FROST"] = "Givre"
L["THEME_RED"] = "Rouge"
L["THEME_CLASS"] = "Style de ma classe"
L["THEME_SPEC"] = "Style de ma spécialisation"
L["HELP_SCAN"] = "  /void scan [raid 14|15|16] – lire votre cache du Vide pour marquer les objets des pièces déjà utilisées"
L["SCAN_TIP"] = "Astuce : tapez /void scan pour marquer les objets des pièces de Noyau du Vide déjà utilisées."
L["MARK_MODE_ACTIVE"] = "Cliquez sur les objets, puis ici pour enregistrer"
L["MARK_MODE_TIP"] = "Cliquez sur cette barre, puis sur les objets obtenus avec un jet de Noyau du Vide que l'addon n'a pas suivis : ils s'estompent aussitôt. Cliquez de nouveau sur la barre pour les enregistrer."
