-- VoidcoreAdvisor: Locale – Portuguese (Brazil)
local _, VCA = ...
if (VCA.ForcedLocale or GetLocale()) ~= "ptBR" then
    return
end
local L = VCA.L

-- ── Panel UI ──────────────────────────────────────────────────────────────────

L["PANEL_TITLE"] = "|cff8fe36bVoidcore|r|cffffffffAdvisor|r"

L["COL_LOOT"] = "SAQUE"
L["COL_SPEC_RANKING"] = "RANKING DE ESPEC."
L["COL_SPEC_FIT"] = "AJUSTE DE ESPEC."
L["COL_LOOT_FILTERED"] = "SAQUE (filtrado)"
L["COL_LOOT_FILTERED_N"] = "SAQUE (filtrado %d espec.)"

L["CONTENT_RAID_BOSS"] = "Chefe de raide"
L["CONTENT_MP_DUNGEON"] = "Masmorra M+"
L["NEBULOUS_VOIDCORE"] = "Núcleo do Vazio Nebuloso"
L["NEBULOUS_VOIDCORES"] = "Núcleos do Vazio Nebulosos"

L["NO_ITEMS_FOR_SPEC"] = "Nenhum item para esta especialização"

L["LOOT_SPEC_LABEL"] = "Saque:"
L["ALL_OBTAINED"] = "|TInterface\\Buttons\\UI-CheckBox-Check:14:14|t todos"

L["DETECTED_OBTAINED"] = "%s detectado automaticamente como obtido via Núcleo do Vazio Nebuloso."

L["CLEAR_SELECTED"] = "Limpar seleção"

-- ── Slash commands ────────────────────────────────────────────────────────────

L["RESET_CONFIRM"] = "Todos os dados de itens obtidos foram redefinidos."
L["NEW_SEASON_RESET"] = "Nova temporada detectada — itens selecionados e obtidos foram apagados."
L["COUNT_FORMAT"] = "%d item(ns) marcado(s) como obtido(s) via Núcleo do Vazio."
L["SPEC_FORMAT"] = "ID de especialização de saque ativa: %s%s"
L["FOLLOWS_ACTIVE_SPEC"] = " (segue a especialização ativa)"
L["SOURCE_FORMAT"] = "Fonte ativa — tipo: %s  IDfonte: %s  dificuldade: %s"
L["NO_ACTIVE_SOURCE"] = "Nenhuma fonte ativa definida."
L["VERSION_FORMAT"] = "Versão %s"
L["HELP_HEADER"] = "Comandos:"
L["HELP_RESET"] = "  /void reset    – redefinir dados de itens obtidos"
L["HELP_COUNT"] = "  /void count    – mostrar total de itens marcados como obtidos"
L["HELP_SPEC"] = "  /void spec     – mostrar ID de especialização de saque"
L["HELP_SOURCE"] = "  /void source   – mostrar fonte de detecção ativa"
L["HELP_VERSION"] = "  /void version  – mostrar versão do addon"
L["HELP_RESTORE"] = "  /void restore  – restaurar dados de saque do backup pré-varredura"

-- ── Panel UI (adições) ────────────────────────────────────────────────────────

L["LFR_NOT_ELIGIBLE"] = "Não disponível no Buscador de raide"

L["TOGGLE_SHOW"] = "Clique para mostrar o painel de conselhos."
L["TOGGLE_HIDE"] = "Clique para ocultar o painel de conselhos."
L["TOGGLE_OVERVIEW_SHOW"] = "Clique para mostrar o resumo das masmorras."
L["TOGGLE_OVERVIEW_HIDE"] = "Clique para ocultar o resumo das masmorras."

-- ── Popup de lembrete (Reminder.lua) ─────────────────────────────────────────

L["REMINDER_TITLE"] = "|cff8fe36bVoidcore|r|cffffffffAdvisor|r"
L["REMINDER_SUBTITLE"] = "Otimize sua especialização de saque para as recompensas do Núcleo do Vazio Nebuloso!"
L["REMINDER_VOIDCORE_COUNT"] = "Você tem |cffffff00%d|r Núcleo(s) do Vazio Nebuloso"
L["REMINDER_CURRENT_SPEC"] = "Especialização de saque atual:"
L["REMINDER_RECOMMENDED"] = "Especialização recomendada:"
L["REMINDER_ITEMS_SELECTED"] = "%d item(ns) selecionado(s)"
L["REMINDER_SELECTED_CHANCE"] = "%d%% de chance para item(ns) selecionado(s)"
L["REMINDER_CHANGE_PROMPT"] = "Alterar especialização de saque para |cffffff00%s|r?"
L["REMINDER_YES"] = "Sim, alterar"
L["REMINDER_NO"] = "Não, obrigado"
L["REMINDER_WARNING_ONE_ITEM"] =
    "|cffff8000Aviso:|r Esta especialização tem |cffff0000apenas 1 item|r restante nesta masmorra. Usar um Núcleo do Vazio Nebuloso com esta especialização |cffff0000redefinirá o grupo de saque de todas as especializações|r nesta masmorra!"
L["REMINDER_SPEC_LIST_HEADER"] = "Itens restantes por especialização:"
L["REMINDER_SPEC_REMAINING"] = "%d restante(s)"
L["REMINDER_SPEC_NONE"] = "nenhum restante"
L["SPEC_LIST_TOOLTIP_TITLE"] = "Proteção de Saque"
L["SPEC_LIST_ITEM_ONE"] = "1 item restante"
L["SPEC_LIST_ITEM_MANY"] = "%d itens restantes"
L["SPEC_LIST_ALL_OBTAINED"] = "todos obtidos"

-- ── Popup de aviso de redefinição do grupo de saque (Reminder.lua) ───────────

L["WARNING_TITLE"] = "|cff8fe36bVoidcore|r|cffffffffAdvisor|r"
L["WARNING_SUBTITLE"] = "Risco de redefinição do grupo de saque"
L["WARNING_VOIDCORE_COUNT"] = "Você tem |cffffff00%d|r Núcleo(s) do Vazio Nebuloso"
L["WARNING_FAVORED_SPEC"] = "Você está usando a especialização de saque favorita:"
L["WARNING_ONE_ITEM"] =
    "|cffff8000Aviso:|r Esta especialização tem |cffff0000apenas %d item|r restante nesta masmorra. Usar um Núcleo do Vazio Nebuloso |cffff0000redefinirá o grupo de saque de todas as especializações|r nesta masmorra!"
L["WARNING_SPEC_LIST_HEADER"] = "Itens restantes por especialização:"
L["WARNING_CLOSE"] = "Fechar"

-- ── Painel de opções (Options.lua) ────────────────────────────────────────────

L["OPTIONS_CAT_REMINDER"] = "Lembrete de especialização de saque"
L["OPTIONS_CAT_BONUS_ROLL"] = "Rolagem bônus"

L["OPTIONS_REMINDER_ENABLE"] = "Lembrete de especialização de saque"
L["OPTIONS_REMINDER_TOOLTIP"] =
    "Exibe um popup ao entrar em uma masmorra mítica da temporada atual se uma especialização de saque diferente ofereceria melhores chances para os itens selecionados."
L["OPTIONS_PREVIEW_REMINDER"] = "Pré-visualizar"

-- ── Painel de resumo de masmorras (DungeonOverview.lua) ───────────────────────

L["DUNGEON_OVERVIEW_SUBTITLE"] = "Masmorras M+ — Chance de saque"
L["DUNGEON_OVERVIEW_COL_DUNGEON"] = "MASMORRA"
L["DUNGEON_OVERVIEW_COL_SPEC"] = "ESPEC."
L["DUNGEON_OVERVIEW_COL_LOOTED"] = "SAQUEADO"
L["DUNGEON_OVERVIEW_COL_CHANCE"] = "CHANCE"
L["DUNGEON_OVERVIEW_ALL_DONE"] = "Todos os itens de masmorra obtidos!"
L["DUNGEON_OVERVIEW_NO_DATA"] = "Dados de masmorras da temporada ainda não disponíveis."

L["RAID_OVERVIEW_SUBTITLE"] = "Chefes de raide — Chance de saque"
L["RAID_OVERVIEW_COL_BOSS"] = "CHEFE"
L["RAID_OVERVIEW_NO_DATA"] = "Nenhum dado de encontro de raide disponível."

-- ── Popup de seleção de especialização (PanelColumns.lua) ────────────────────

L["SPEC_PICKER_TITLE"] = "Obtido como:"
L["SPEC_PICKER_OK"] = "OK"
L["OBTAINED_UNKNOWN_SPEC"] = "Obtido (especialização desconhecida)"
L["UNKNOWN_KEYLEVEL"] = "nível de chave desconhecido"
L["MANUAL_ENTRY"] = "entrada manual"

-- ── Gaveta de slots (DungeonOverview.lua) ────────────────────────────────────

L["SLOT_FILTER_TOGGLE"] = "Filtrar por slot"
L["SLOT_FILTER_CLEAR"] = "Desmarcar todos os itens de slot"
L["SLOT_FILTER_CLEAR_CONFIRM"] = "Limpar todas as seleções de itens?"
L["SLOT_FILTER_CLEAR_CONFIRM_BODY"] = "Todos os itens selecionados serão desmarcados."

L["SLOT_head"] = "Cabeça"
L["SLOT_neck"] = "Pescoço"
L["SLOT_shoulder"] = "Ombros"
L["SLOT_back"] = "Costas"
L["SLOT_chest"] = "Peito"
L["SLOT_wrist"] = "Pulso"
L["SLOT_hands"] = "Mãos"
L["SLOT_waist"] = "Cintura"
L["SLOT_legs"] = "Pernas"
L["SLOT_feet"] = "Pés"
L["SLOT_finger"] = "Dedo"
L["SLOT_trinket"] = "Bugiganga"
L["SLOT_SELECT_ALL"] = "Selecionar tudo"
L["SLOT_DESELECT_ALL"] = "Desmarcar tudo"
L["SLOT_NONE_SELECTED"] = "Nada selecionado"
L["SLOT_weapon"] = "Arma"
L["SLOT_offhand"] = "Mão secundária"

-- ── Escaneamento de Voidcache (VoidcacheScan.lua / DungeonOverview.lua) ───────

L["SCAN_BTN"] = "Escanear Specs de Saque"
L["SCAN_PROGRESS"] = "Escaneando %d/%d..."
L["SCAN_COMPLETE"] = "✓ Escaneamento Concluído"
L["SCAN_ABORTED"] = "Escaneamento Cancelado"
L["SCAN_CONFIRM_TITLE"] = "Escanear Specs de Saque?"
L["SCAN_CONFIRM_BODY"] =
    "Isso irá escanear o tooltip do Voidcache Nebuloso para cada uma de suas especializações de saque em todas as masmorras da temporada.\n\nDificuldade escaneada:\n|cffffff00Mítico+ nível de chave +10|r|cffaaaaaa\n\nOs dados de saque existentes serão redefinidos.\n\nNão entre em combate ou em uma masmorra durante o escaneamento."
L["SCAN_UNAVAILABLE_COMBAT"] = "Não é possível escanear em combate."
L["SCAN_UNAVAILABLE_INSTANCE"] = "Não é possível escanear dentro de uma masmorra."
L["RAID_SCAN_CONFIRM_TITLE"] = "Escanear Specs de Saque de Raide?"
L["RAID_SCAN_CONFIRM_BODY"] =
    "Isso irá escanear o tooltip do Voidcache Nebuloso para cada uma de suas especializações de saque em todos os encontros de Raide Mítico.\n\nDificuldade escaneada:\n|cffffff00Mítico|r|cffaaaaaa\n\nOs dados de Raide Mítico existentes serão redefinidos.\n\nNão entre em combate durante o escaneamento."

-- ── Comandos slash (adições) ──────────────────────────────────────────────────

L["HELP_REPLAYLOG"] = "  /void replaylog – reaplicar todas as entradas do registro de rolagens como obtidas"
L["RESTORE_COMPLETE"] = "%d item(ns) restaurado(s) do backup."
L["RESTORE_NO_BACKUP"] = "Nenhum backup disponível. Execute um escaneamento primeiro."
L["RESTORE_FAILED"] = "A restauração falhou."

-- ── Janela de confirmação de rolagem bônus (BonusRollConfirm.lua) ─────────────

L["BONUS_ROLL_CONFIRM_SUBTITLE"] = "Confirmar rolagem de Núcleo do Vazio Nebuloso"
L["BONUS_ROLL_CONFIRM_SPEC_LABEL"] = "Especialização de saque ativa:"
L["BONUS_ROLL_CONFIRM_POOL"] = "%d item(ns) restante(s) no grupo"
L["BONUS_ROLL_CONFIRM_CHANCE"] = "%d%% de chance (%d itens desejados)"
L["BONUS_ROLL_CONFIRM_CHANCE_ONE"] = "%d%% de chance (1 item desejado)"
L["BONUS_ROLL_CONFIRM_ALL_OBTAINED"] = "Todos os itens obtidos para esta espec."
L["BONUS_ROLL_CONFIRM_NO_ITEMS"] = "Nenhum item desejado para esta espec."
L["BONUS_ROLL_CONFIRM_NO_ITEMS_OTHER_SPECS"] = "Outras especializações têm itens desejados"
L["BONUS_ROLL_CONFIRM_NO_SELECTED"] = "Nenhum item desejado"
L["BONUS_ROLL_CONFIRM_NOT_TRACKED"] = "Fonte não rastreada — sem probabilidades disponíveis"
L["BONUS_ROLL_CONFIRM_WARNING_HEADER"] =
    "|A:Ping_Chat_Warning:14:14|a |cffffff00Rolar redefinirá a proteção contra má sorte|r"
L["BONUS_ROLL_CONFIRM_WARNING_BODY"] =
    "Após esta rolagem, itens previamente saqueados podem cair novamente para todas as especializações."
L["BONUS_ROLL_CONFIRM_QUESTION"] = "Deseja rolar por saque?"
L["BONUS_ROLL_CONFIRM_ROLL"] = "Rolar"
L["BONUS_ROLL_CONFIRM_PASS"] = "Passar"
L["BONUS_ROLL_CONFIRM_CONFIRM"] = "Confirmar rolagem"
L["BONUS_ROLL_CONFIRM_PASS_CONFIRM"] = "Confirmar passagem"
L["BONUS_ROLL_CONFIRM_CLOSE"] = "Fechar"
L["BONUS_ROLL_POPUP_ROLL"] = "Gastar seu Núcleo do Vazio Nebuloso em uma rolagem bônus?"
L["BONUS_ROLL_POPUP_PASS"] = "Passar esta rolagem bônus?"

-- ── Painel de opções (adições) ────────────────────────────────────────────────

L["OPTIONS_PREVIEW_BONUS_ROLL"] = "Pré-visualizar"
L["BONUS_ROLL_CONFIRM_COST"] = "Custo: |cffffff00%d|r  \194\183  Você tem |cffffff00%d|r"
L["OPTIONS_BONUS_ROLL_CONFIRM"] = "Janela de rolagem bônus"
L["OPTIONS_BONUS_ROLL_CONFIRM_TOOLTIP"] =
    "Exibe informações do VoidcoreAdvisor quando a janela de rolagem bônus do Núcleo do Vazio Nebuloso aparece, incluindo sua especialização de saque ativa e as probabilidades de itens."
L["OPTIONS_BRC_SPEC_LIST"] = "Mostrar itens restantes por especialização"
L["OPTIONS_BRC_SPEC_LIST_TOOLTIP"] =
    "Exibe uma lista de itens restantes para cada uma de suas especializações na janela de rolagem bônus."
L["BRC_SWITCH_SPEC_TIP"] = "Switch specialization to %s"

-- ── VoidcoreAdvisor Reborn additions ─────────────────────────────────────────────
L["BRC_SWITCH_SPEC_TIP"] = "Trocar para a especialização %s"
L["SPEC_LIST_TOOLTIP"] = "Saque restante de cada especialização de saque"
L["BONUS_ROLL_WANTED_TOOLTIP_TITLE"] = "Itens desejados"
L["DIFFICULTY_NORMAL"] = "Normal"
L["DIFFICULTY_HEROIC"] = "Heroico"
L["DIFFICULTY_MYTHIC"] = "Mítico"
L["MARK_MODE_BUTTON"] = "Marcar item obtido"
L["MARK_MODE_ACTIVE"] = "Clique em um item para marcá-lo (clique aqui para parar)"
L["MARK_MODE_TIP"] = "Use para itens que você obteve com uma rolagem de Núcleo do Vazio e que o addon não registrou. Enquanto ativo, clique em um item para marcá-lo como obtido em todas as especializações, ou clique de novo para desmarcar."
L["RAID_NOT_IN_DATA"] = "Esta raide ainda não está nos dados de saque do addon. Ela é carregada automaticamente quando possível; caso contrário, atualize o VoidcoreAdvisor Reborn."
L["ORIGINAL_ADDON_LOADED"] = "O VoidcoreAdvisor original também está ativado. Desative-o: as duas versões não podem funcionar juntas."
L["BONUS_ROLL_POPUP_ROLL"] = "Tem certeza de que deseja gastar seu Núcleo do Vazio nebuloso em uma rolagem bônus?"
L["BONUS_ROLL_POPUP_PASS"] = "Tem certeza de que deseja passar esta rolagem bônus?"
L["OPTIONS_BRC_CONFIRM"] = "Pedir confirmação ao rolar ou passar"
L["OPTIONS_BRC_CONFIRM_TOOLTIP"] = "Mostra uma mensagem \"Tem certeza?\" ao clicar em Rolar ou Passar."

-- ── VoidcoreAdvisor Reborn 2.1 additions ──────────────────────────────────────
L["MISSING_TITLE"] = "Itens que faltam"
L["MISSING_EMPTY"] = "Você tem todos os itens desta especialização de saque."
L["PANEL_NOT_FOUND"] = "Nenhum chefe ou masmorra corresponde a \"%s\"."
L["EXPORT_TITLE"] = "Exportar itens marcados"
L["IMPORT_TITLE"] = "Importar itens marcados"
L["IMPORT_BUTTON"] = "Importar"
L["IMPORT_OK"] = "%d itens importados."
L["IMPORT_BAD"] = "Esse texto não é uma exportação válida."
L["TRANSFER_COPY_HINT"] = "Pressione Ctrl+C para copiar este texto."
L["TRANSFER_PASTE_HINT"] = "Cole aqui o texto exportado e pressione Importar."
L["OPTIONS_THEME"] = "Tema de cor"
L["OPTIONS_THEME_TOOLTIP"] = "Muda a cor de todas as janelas do VoidcoreAdvisor."
L["THEME_GREEN"] = "Verde veneno"
L["THEME_PURPLE"] = "Roxo do Vazio"
L["THEME_BLUE"] = "Azul arcano"
L["ONE_ITEM_WARN"] = "Resta apenas 1 item para esta especialização: rolar vai reiniciar sua proteção de saque!"
L["MARK_MODE_SHIFT_TIP"] = "Segure Shift e clique em um segundo item para marcar todos os do meio."
L["DATA_OUTDATED"] = "Nova raide ainda não está nos dados de saque: %s. O desenvolvedor precisa atualizar o VoidcoreAdvisor Reborn."
L["HELP_PANEL"] = "  /void panel [nome] – abrir o Guia de aventuras em um chefe ou masmorra"
L["HELP_MISSING"] = "  /void missing [14|15|16] – listar todos os itens que faltam"
L["HELP_EXPORT"] = "  /void export – copiar seus itens marcados como texto"
L["HELP_IMPORT"] = "  /void import – colar itens marcados de outro personagem"
L["HELP_THEME"] = "  /void theme <name> – mudar as cores das janelas"
L["HELP_RESETPANEL"] = "  /void resetpanel – colocar o painel de volta ao lado do guia"
L["THEME_LIGHT"] = "Luz"
L["THEME_FIRE"] = "Fogo"
L["THEME_FROST"] = "Gelo"
L["THEME_RED"] = "Vermelho"
L["THEME_CLASS"] = "Estilo da minha classe"
L["HELP_SCAN"] = "  /void scan [raid 14|15|16] – ler seu Cofre do Vazio para marcar os itens das moedas já usadas"
L["SCAN_TIP"] = "Dica: digite /void scan para marcar os itens das moedas de Núcleo do Vazio que você já usou."
L["MARK_MODE_ACTIVE"] = "Clique nos itens e depois aqui para salvar"
L["MARK_MODE_TIP"] = "Clique nesta barra e depois nos itens obtidos com uma rolagem de Núcleo do Vazio que o addon não registrou: eles escurecem na hora. Clique na barra de novo para salvá-los."
L["THEME_CURRENT"] = "O mesmo que uso"
L["OPTIONS_ROLL_THEME"] = "Tema da janela de rolagem bônus"
L["OPTIONS_ROLL_THEME_TOOLTIP"] = "Escolha o tema de cores da janela de rolagem bônus, independente do tema do resto do addon."
L["REMINDER_WARNING_ONE_ITEM_BOSS"] = "|cffff8000Aviso:|r Esta especialização tem |cffff0000apenas 1 item|r restante neste chefe. Usar um Núcleo do Vazio nebuloso com esta especialização |cffff0000reiniciará o saque de todas as especializações|r neste chefe!"
L["WARNING_ONE_ITEM_BOSS"] = "|cffff8000Aviso:|r Esta especialização tem |cffff0000apenas %d item|r restante neste chefe. Usar um Núcleo do Vazio nebuloso |cffff0000reiniciará o saque de todas as especializações|r neste chefe!"
L["OPTIONS_REMINDER_BOSS"] = "Lembrar também diante de chefes de raide"
L["OPTIONS_REMINDER_BOSS_TOOLTIP"] = "Mostra o mesmo aviso uma vez por chefe quando você seleciona um chefe de raide da temporada atual antes do pull."
L["OPTIONS_REMINDER_THEME"] = "Tema do lembrete"
L["OPTIONS_REMINDER_THEME_TOOLTIP"] = "Escolha o tema de cores dos avisos de especialização de saque, independente do resto do addon."
L["HELP_OPEN"] = "  /void open – abrir a página de opções (temas e pré-visualizações)"
L["MARK_MODE_ACTIVE"] = "Clique para salvar"
L["RAID_OVERVIEW_EMPTY_HINT"] = "Nenhum item escolhido ainda.\nClique em um chefe da lista e depois nos itens que quer: aqui aparecerá sua chance para cada chefe."
