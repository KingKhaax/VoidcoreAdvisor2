-- VoidcoreAdvisor: Locale – Spanish (Spain)
if GetLocale() ~= "esES" then
    return
end
local _, VCA = ...
local L = VCA.L

-- ── Panel UI ──────────────────────────────────────────────────────────────────

L["PANEL_TITLE"] = "|cffb048f8Voidcore|r|cffddddddAdvisor|r"

L["COL_LOOT"] = "BOTÍN"
L["COL_SPEC_RANKING"] = "RANKING DE ESPEC."
L["COL_SPEC_FIT"] = "AJUSTE DE ESPEC."
L["COL_LOOT_FILTERED"] = "BOTÍN (filtrado)"
L["COL_LOOT_FILTERED_N"] = "BOTÍN (filtrado %d espec.)"

L["CONTENT_RAID_BOSS"] = "Jefe de banda"
L["CONTENT_MP_DUNGEON"] = "Mazmorra M+"
L["NEBULOUS_VOIDCORE"] = "Núcleo del Vacío nebuloso"
L["NEBULOUS_VOIDCORES"] = "Núcleos del Vacío nebulosos"

L["NO_ITEMS_FOR_SPEC"] = "No hay objetos para esta especialización"

L["LOOT_SPEC_LABEL"] = "Botín:"
L["ALL_OBTAINED"] = "✓ todos"

L["DETECTED_OBTAINED"] = "%s detectado automáticamente como obtenido mediante Núcleo del Vacío nebuloso."

L["CLEAR_SELECTED"] = "Borrar selección"

-- ── Slash commands ────────────────────────────────────────────────────────────

L["RESET_CONFIRM"] = "Se han restablecido todos los datos de objetos obtenidos."
L["NEW_SEASON_RESET"] = "Nueva temporada detectada: los objetos seleccionados y obtenidos han sido eliminados."
L["COUNT_FORMAT"] = "%d objeto(s) marcado(s) como obtenido(s) mediante Núcleo del Vacío."
L["SPEC_FORMAT"] = "ID de especialización de botín activa: %s%s"
L["FOLLOWS_ACTIVE_SPEC"] = " (sigue la especialización activa)"
L["SOURCE_FORMAT"] = "Fuente activa — tipo: %s  IDfuente: %s  dificultad: %s"
L["NO_ACTIVE_SOURCE"] = "No hay ninguna fuente activa."
L["VERSION_FORMAT"] = "Versión %s"
L["HELP_HEADER"] = "Comandos:"
L["HELP_RESET"] = "  /vca2 reset    – restablecer todos los datos de objetos obtenidos"
L["HELP_COUNT"] = "  /vca2 count    – mostrar total de objetos marcados como obtenidos"
L["HELP_SPEC"] = "  /vca2 spec     – mostrar ID de especialización de botín activa"
L["HELP_SOURCE"] = "  /vca2 source   – mostrar fuente de detección activa"
L["HELP_VERSION"] = "  /vca2 version  – mostrar versión del addon"
L["HELP_RESTORE"] = "  /vca2 restore  – restaurar datos de botín del respaldo pre-escaneo"

-- ── Panel UI (adiciones) ──────────────────────────────────────────────────────

L["LFR_NOT_ELIGIBLE"] = "No disponible en el Buscador de banda"

L["TOGGLE_SHOW"] = "Haz clic para mostrar el panel de consejos."
L["TOGGLE_HIDE"] = "Haz clic para ocultar el panel de consejos."
L["TOGGLE_OVERVIEW_SHOW"] = "Haz clic para mostrar el resumen de mazmorras."
L["TOGGLE_OVERVIEW_HIDE"] = "Haz clic para ocultar el resumen de mazmorras."

-- ── Ventana de recordatorio (Reminder.lua) ────────────────────────────────────

L["REMINDER_TITLE"] = "|cffb048f8Voidcore|r|cffddddddAdvisor|r"
L["REMINDER_SUBTITLE"] =
    "¡Optimiza tu especialización de botín para las recompensas del Núcleo del Vacío nebuloso!"
L["REMINDER_VOIDCORE_COUNT"] = "Tienes |cffffff00%d|r Núcleo(s) del Vacío nebuloso"
L["REMINDER_CURRENT_SPEC"] = "Especialización de botín actual:"
L["REMINDER_RECOMMENDED"] = "Especialización recomendada:"
L["REMINDER_ITEMS_SELECTED"] = "%d objeto(s) seleccionado(s)"
L["REMINDER_SELECTED_CHANCE"] = "%d%% de probabilidad para objeto(s) seleccionado(s)"
L["REMINDER_CHANGE_PROMPT"] = "¿Cambiar especialización de botín a |cffffff00%s|r?"
L["REMINDER_YES"] = "Sí, cambiar"
L["REMINDER_NO"] = "No, gracias"
L["REMINDER_WARNING_ONE_ITEM"] =
    "|cffff8000Advertencia:|r Esta especialización solo tiene |cffff00001 objeto|r restante en esta mazmorra. Usar un Núcleo del Vacío nebuloso con esta especialización |cffff0000reiniciará el grupo de botín de todas las especializaciones|r en esta mazmorra."
L["REMINDER_SPEC_LIST_HEADER"] = "Objetos restantes por especialización:"
L["REMINDER_SPEC_REMAINING"] = "%d restante(s)"
L["REMINDER_SPEC_NONE"] = "ninguno restante"
L["SPEC_LIST_TOOLTIP_TITLE"] = "Protección de botín"
L["SPEC_LIST_ITEM_ONE"] = "1 objeto restante"
L["SPEC_LIST_ITEM_MANY"] = "%d objetos restantes"
L["SPEC_LIST_ALL_OBTAINED"] = "todos obtenidos"

-- ── Popup de aviso de reinicio del grupo de botín (Reminder.lua) ─────────────

L["WARNING_TITLE"] = "|cffb048f8Voidcore|r|cffddddddAdvisor|r"
L["WARNING_SUBTITLE"] = "Riesgo de reinicio del grupo de botín"
L["WARNING_VOIDCORE_COUNT"] = "Tienes |cffffff00%d|r Núcleo(s) del Vacío nebuloso"
L["WARNING_FAVORED_SPEC"] = "Estás usando la especialización de botín favorita:"
L["WARNING_ONE_ITEM"] =
    "|cffff8000Advertencia:|r Esta especialización solo tiene |cffff0000%d objeto|r restante en esta mazmorra. Usar un Núcleo del Vacío nebuloso |cffff0000reiniciará el grupo de botín de todas las especializaciones|r en esta mazmorra."
L["WARNING_SPEC_LIST_HEADER"] = "Objetos restantes por especialización:"
L["WARNING_CLOSE"] = "Cerrar"

-- ── Panel de opciones (Options.lua) ──────────────────────────────────────────

L["OPTIONS_CAT_REMINDER"] = "Recordatorio de especialización de botín"
L["OPTIONS_CAT_BONUS_ROLL"] = "Tirada extra"

L["OPTIONS_REMINDER_ENABLE"] = "Recordatorio de especialización de botín"
L["OPTIONS_REMINDER_TOOLTIP"] =
    "Muestra un popup al entrar en una mazmorra mítica de la temporada actual si una especialización de botín diferente daría mejores probabilidades para los objetos seleccionados."
L["OPTIONS_PREVIEW_REMINDER"] = "Vista previa"

-- ── Panel de resumen de mazmorras (DungeonOverview.lua) ───────────────────────

L["DUNGEON_OVERVIEW_SUBTITLE"] = "Mazmorras M+ — Probabilidad de botín"
L["DUNGEON_OVERVIEW_COL_DUNGEON"] = "MAZMORRA"
L["DUNGEON_OVERVIEW_COL_SPEC"] = "ESPEC."
L["DUNGEON_OVERVIEW_COL_LOOTED"] = "SAQUEADO"
L["DUNGEON_OVERVIEW_COL_CHANCE"] = "PROB."
L["DUNGEON_OVERVIEW_ALL_DONE"] = "¡Todos los objetos de mazmorra obtenidos!"
L["DUNGEON_OVERVIEW_NO_DATA"] = "Datos de mazmorras de temporada aún no disponibles."

L["RAID_OVERVIEW_SUBTITLE"] = "Jefes de banda — Probabilidad de botín"
L["RAID_OVERVIEW_COL_BOSS"] = "JEFE"
L["RAID_OVERVIEW_NO_DATA"] = "No hay datos de encuentros de banda disponibles."

-- ── Ventana de selección de especialización (PanelColumns.lua) ───────────────

L["SPEC_PICKER_TITLE"] = "Obtenido como:"
L["SPEC_PICKER_OK"] = "Aceptar"
L["OBTAINED_UNKNOWN_SPEC"] = "Obtenido (especialización desconocida)"
L["UNKNOWN_KEYLEVEL"] = "nivel de clave desconocido"
L["MANUAL_ENTRY"] = "entrada manual"

-- ── Cajón de ranuras (DungeonOverview.lua) ───────────────────────────────────

L["SLOT_FILTER_TOGGLE"] = "Filtrar por ranura"
L["SLOT_FILTER_CLEAR"] = "Deseleccionar todos los objetos de ranura"
L["SLOT_FILTER_CLEAR_CONFIRM"] = "¿Borrar todas las selecciones de objetos?"
L["SLOT_FILTER_CLEAR_CONFIRM_BODY"] = "Se anulará la selección de todos los objetos seleccionados."

L["SLOT_head"] = "Cabeza"
L["SLOT_neck"] = "Cuello"
L["SLOT_shoulder"] = "Hombros"
L["SLOT_back"] = "Espalda"
L["SLOT_chest"] = "Pecho"
L["SLOT_wrist"] = "Muñeca"
L["SLOT_hands"] = "Manos"
L["SLOT_waist"] = "Cintura"
L["SLOT_legs"] = "Piernas"
L["SLOT_feet"] = "Pies"
L["SLOT_finger"] = "Dedo"
L["SLOT_trinket"] = "Abalorio"
L["SLOT_SELECT_ALL"] = "Seleccionar todo"
L["SLOT_DESELECT_ALL"] = "Deseleccionar todo"
L["SLOT_NONE_SELECTED"] = "Nada seleccionado"
L["SLOT_weapon"] = "Arma"
L["SLOT_offhand"] = "Mano secundaria"

-- ── Escán de Vacíocache (VoidcacheScan.lua / DungeonOverview.lua) ─────────────

L["SCAN_BTN"] = "Escanear espec. de botín"
L["SCAN_PROGRESS"] = "Escaneando %d/%d..."
L["SCAN_COMPLETE"] = "✓ Escaneo completado"
L["SCAN_ABORTED"] = "Escaneo cancelado"
L["SCAN_CONFIRM_TITLE"] = "¿Escanear espec. de botín?"
L["SCAN_CONFIRM_BODY"] =
    "Se escaneará el texto del Vacíocache nebuloso para cada una de tus especializaciones de botín en todas las mazmorras de la temporada.\n\nDificultad analizada:\n|cffffff00Mítica+ nivel de llave +10|r|cffaaaaaa\n\nLos datos de botín existentes serán restablecidos.\n\nNo entres en combate ni en una mazmorra durante el escán."
L["SCAN_UNAVAILABLE_COMBAT"] = "No se puede escanear en combate."
L["SCAN_UNAVAILABLE_INSTANCE"] = "No se puede escanear dentro de una mazmorra."
L["RAID_SCAN_CONFIRM_TITLE"] = "¿Escanear espec. de botín de banda?"
L["RAID_SCAN_CONFIRM_BODY"] =
    "Se escaneará el texto del Vacíocache nebuloso para cada una de tus especializaciones de botín en todos los encuentros de banda Mítica.\n\nDificultad analizada:\n|cffffff00Mítica|r|cffaaaaaa\n\nLos datos de banda Mítica existentes serán restablecidos.\n\nNo entres en combate durante el escán."

-- ── Comandos slash (adiciones) ────────────────────────────────────────────────

L["HELP_REPLAYLOG"] = "  /vca2 replaylog – reaplicar todas las entradas del registro de tiradas como obtenidas"
L["RESTORE_COMPLETE"] = "%d objeto(s) restaurado(s) desde el respaldo."
L["RESTORE_NO_BACKUP"] = "No hay respaldo disponible. Realiza un escaneo primero."
L["RESTORE_FAILED"] = "La restauración falló."

-- ── Ventana de confirmación de tirada extra (BonusRollConfirm.lua) ────────────

L["BONUS_ROLL_CONFIRM_SUBTITLE"] = "Confirmar tirada de Núcleo del Vacío nebuloso"
L["BONUS_ROLL_CONFIRM_SPEC_LABEL"] = "Especialización de botín activa:"
L["BONUS_ROLL_CONFIRM_POOL"] = "%d objeto(s) restante(s) en el grupo"
L["BONUS_ROLL_CONFIRM_CHANCE"] = "%d%% de probabilidad (%d objetos deseados)"
L["BONUS_ROLL_CONFIRM_CHANCE_ONE"] = "%d%% de probabilidad (1 objeto deseado)"
L["BONUS_ROLL_CONFIRM_ALL_OBTAINED"] = "Todos los objetos obtenidos para esta espec."
L["BONUS_ROLL_CONFIRM_NO_ITEMS"] = "No hay objetos deseados para esta espec."
L["BONUS_ROLL_CONFIRM_NO_ITEMS_OTHER_SPECS"] = "Otras especializaciones tienen objetos deseados"
L["BONUS_ROLL_CONFIRM_NO_SELECTED"] = "Sin objetos deseados"
L["BONUS_ROLL_CONFIRM_NOT_TRACKED"] = "Fuente no rastreada — sin probabilidades disponibles"
L["BONUS_ROLL_CONFIRM_WARNING_HEADER"] =
    "|A:Ping_Chat_Warning:14:14|a |cffffff00Tirar reiniciará la protección de mala suerte|r"
L["BONUS_ROLL_CONFIRM_WARNING_BODY"] =
    "Tras esta tirada, los objetos previamente saqueados pueden volver a caer para todas las especializaciones."
L["BONUS_ROLL_CONFIRM_QUESTION"] = "¿Deseas tirar por botín?"
L["BONUS_ROLL_CONFIRM_ROLL"] = "Tirar"
L["BONUS_ROLL_CONFIRM_PASS"] = "Pasar"
L["BONUS_ROLL_CONFIRM_CONFIRM"] = "Confirmar tirada"
L["BONUS_ROLL_CONFIRM_PASS_CONFIRM"] = "Confirmar pasar"
L["BONUS_ROLL_CONFIRM_CLOSE"] = "Cerrar"
L["BONUS_ROLL_POPUP_ROLL"] = "¿Gastar tu Núcleo del Vacío nebuloso en una tirada extra?"
L["BONUS_ROLL_POPUP_PASS"] = "¿Pasar esta tirada extra?"

-- ── Panel de opciones (adiciones) ────────────────────────────────────────────

L["OPTIONS_PREVIEW_BONUS_ROLL"] = "Vista previa"
L["BONUS_ROLL_CONFIRM_COST"] = "Coste: |cffffff00%d|r  \194\183  Tienes |cffffff00%d|r"
L["OPTIONS_BONUS_ROLL_CONFIRM"] = "Ventana de tirada extra"
L["OPTIONS_BONUS_ROLL_CONFIRM_TOOLTIP"] =
    "Muestra información de VoidcoreAdvisor cuando aparece la ventana de tirada extra del Núcleo del Vacío nebuloso, incluyendo tu especialización de botín activa y las probabilidades de objetos."
L["OPTIONS_BRC_SPEC_LIST"] = "Mostrar objetos restantes por especialización"
L["OPTIONS_BRC_SPEC_LIST_TOOLTIP"] =
    "Muestra una lista de objetos restantes para cada una de tus especializaciones en la ventana de tirada extra."
L["BRC_SWITCH_SPEC_TIP"] = "Switch specialization to %s"

-- ── VoidcoreAdvisor 2.0 additions ─────────────────────────────────────────────
L["BRC_SWITCH_SPEC_TIP"] = "Cambiar especialización a %s"
L["SPEC_LIST_TOOLTIP"] = "Botín restante de cada especialización de botín"
L["BONUS_ROLL_WANTED_TOOLTIP_TITLE"] = "Objetos deseados"
L["DIFFICULTY_NORMAL"] = "Normal"
L["DIFFICULTY_HEROIC"] = "Heroico"
L["DIFFICULTY_MYTHIC"] = "Mítico"
L["MARK_MODE_BUTTON"] = "Marcar objeto obtenido"
L["MARK_MODE_ACTIVE"] = "Haz clic en un objeto para marcarlo (clic aquí para terminar)"
L["MARK_MODE_TIP"] = "Úsalo para objetos que conseguiste con una tirada de Núcleo del Vacío y que el addon no registró. Mientras esté activo, haz clic en un objeto para marcarlo como obtenido en todas las especializaciones, o de nuevo para desmarcarlo."
L["RAID_NOT_IN_DATA"] = "Esta banda aún no está en los datos de botín del addon. Se carga sola cuando es posible; si no, actualiza VoidcoreAdvisor 2.0."
L["ORIGINAL_ADDON_LOADED"] = "El VoidcoreAdvisor original también está activado. Desactívalo: no pueden funcionar a la vez."
L["BONUS_ROLL_POPUP_ROLL"] = "¿Estás seguro de que quieres gastar tu Núcleo del Vacío nebuloso en una tirada extra?"
L["BONUS_ROLL_POPUP_PASS"] = "¿Estás seguro de que quieres pasar esta tirada extra?"
L["OPTIONS_BRC_CONFIRM"] = "Pedir confirmación al tirar o pasar"
L["OPTIONS_BRC_CONFIRM_TOOLTIP"] = "Muestra un mensaje de «¿Estás seguro?» al pulsar Tirar o Pasar."
