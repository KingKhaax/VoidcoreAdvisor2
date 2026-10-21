-- VoidcoreAdvisor: Locale – Russian
if GetLocale() ~= "ruRU" then
    return
end
local _, VCA = ...
local L = VCA.L

-- ── Panel UI ──────────────────────────────────────────────────────────────────

L["PANEL_TITLE"] = "|cffb048f8Voidcore|r|cffddddddСоветник|r"

L["COL_LOOT"] = "ДОБЫЧА"
L["COL_SPEC_RANKING"] = "РЕЙТИНГ СПЕКОВ"
L["COL_SPEC_FIT"] = "СОВМЕСТИМОСТЬ"
L["COL_LOOT_FILTERED"] = "ДОБЫЧА (фильтр)"
L["COL_LOOT_FILTERED_N"] = "ДОБЫЧА (фильтр %d спек.)"

L["CONTENT_RAID_BOSS"] = "Босс рейда"
L["CONTENT_MP_DUNGEON"] = "Подземелье М+"
L["NEBULOUS_VOIDCORE"] = "Туманное ядро Бездны"
L["NEBULOUS_VOIDCORES"] = "Туманные ядра Бездны"

L["NO_ITEMS_FOR_SPEC"] = "Нет предметов для этого спека"

L["LOOT_SPEC_LABEL"] = "Добыча:"
L["ALL_OBTAINED"] = "✓ все"

L["DETECTED_OBTAINED"] =
    "%s автоматически учтен как полученный через Туманное ядро Бездны."

L["CLEAR_SELECTED"] = "Очистить выбор"

-- ── Slash commands ────────────────────────────────────────────────────────────

L["RESET_CONFIRM"] = "Все данные о полученных предметах сброшены."
L["NEW_SEASON_RESET"] =
    "Обнаружен новый сезон — выбранные и полученные предметы очищены."
L["COUNT_FORMAT"] =
    "%d предмет(ов) отмечено как полученных через ядро Бездны."
L["SPEC_FORMAT"] = "ID спека добычи: %s%s"
L["FOLLOWS_ACTIVE_SPEC"] = " (следует за активным спеком)"
L["SOURCE_FORMAT"] =
    "Активный источник — тип: %s  ID источника: %s  сложность: %s"
L["NO_ACTIVE_SOURCE"] = "Активный источник не задан."
L["VERSION_FORMAT"] = "Версия %s"
L["HELP_HEADER"] = "Команды:"
L["HELP_RESET"] = "  /void reset    – сбросить данные о полученных предметах"
L["HELP_COUNT"] = "  /void count    – показать кол-во отмеченных предметов"
L["HELP_SPEC"] = "  /void spec     – показать ID спека добычи"
L["HELP_SOURCE"] = "  /void source   – показать активный источник обнаружения"
L["HELP_VERSION"] = "  /void version  – показать версию аддона"
L["HELP_RESTORE"] =
    "  /void restore  – восстановить данные добычи из резервной копии"

-- ── Панель UI (дополнения) ────────────────────────────────────────────────────

L["LFR_NOT_ELIGIBLE"] = "Недоступно в поиске рейда"

L["TOGGLE_SHOW"] = "Нажмите, чтобы показать панель советника."
L["TOGGLE_HIDE"] = "Нажмите, чтобы скрыть панель советника."
L["TOGGLE_OVERVIEW_SHOW"] = "Нажмите, чтобы показать обзор подземелий."
L["TOGGLE_OVERVIEW_HIDE"] = "Нажмите, чтобы скрыть обзор подземелий."

-- ── Всплывающее напоминание (Reminder.lua) ───────────────────────────────────

L["REMINDER_TITLE"] = "|cffb048f8Voidcore|r|cffddddddСоветник|r"
L["REMINDER_SUBTITLE"] =
    "Оптимизируйте специализацию добычи для наград Туманного ядра Бездны!"
L["REMINDER_VOIDCORE_COUNT"] = "У вас |cffffff00%d|r Туманное/ых ядер Бездны"
L["REMINDER_CURRENT_SPEC"] = "Текущая специализация добычи:"
L["REMINDER_RECOMMENDED"] = "Рекомендуемая специализация:"
L["REMINDER_ITEMS_SELECTED"] = "Выбрано предметов: %d"
L["REMINDER_SELECTED_CHANCE"] = "%d%% шанс на выбранные предметы"
L["REMINDER_CHANGE_PROMPT"] = "Сменить специализацию добычи на |cffffff00%s|r?"
L["REMINDER_YES"] = "Да, сменить"
L["REMINDER_NO"] = "Нет, спасибо"
L["REMINDER_WARNING_ONE_ITEM"] =
    "|cffff8000Внимание:|r Для этой специализации в данном подземелье остался |cffff0000только 1 предмет|r. Использование Туманного ядра Бездны с этой специализацией |cffff0000сбросит пул добычи для всех специализаций|r в этом подземелье!"
L["REMINDER_SPEC_LIST_HEADER"] = "Остаток предметов по специализациям:"
L["REMINDER_SPEC_REMAINING"] = "%d осталось"
L["REMINDER_SPEC_NONE"] = "не осталось"
L["SPEC_LIST_TOOLTIP_TITLE"] = "Защита добычи"
L["SPEC_LIST_ITEM_ONE"] = "1 предмет остался"
L["SPEC_LIST_ITEM_MANY"] = "%d предмета(ов) осталось"
L["SPEC_LIST_ALL_OBTAINED"] = "все получено"

-- ── Всплывающее предупреждение о сбросе пула добычи (Reminder.lua) ─────────

L["WARNING_TITLE"] = "|cffb048f8Voidcore|r|cffddddddСоветник|r"
L["WARNING_SUBTITLE"] = "Риск сброса пула добычи"
L["WARNING_VOIDCORE_COUNT"] = "У вас |cffffff00%d|r Туманное/ых ядер Бездны"
L["WARNING_FAVORED_SPEC"] =
    "Вы используете приоритетную специализацию добычи:"
L["WARNING_ONE_ITEM"] =
    "|cffff8000Внимание:|r Для этой специализации в данном подземелье осталось |cffff0000только %d предмет|r. Использование Туманного ядра Бездны |cffff0000сбросит пул добычи для всех специализаций|r в этом подземелье!"
L["WARNING_SPEC_LIST_HEADER"] = "Остаток предметов по специализациям:"
L["WARNING_CLOSE"] = "Закрыть"

-- ── Панель настроек (Options.lua) ─────────────────────────────────────────────

L["OPTIONS_CAT_REMINDER"] = "Напоминание о специализации добычи"
L["OPTIONS_CAT_BONUS_ROLL"] = "Бонусный бросок"

L["OPTIONS_REMINDER_ENABLE"] = "Напоминание о специализации добычи"
L["OPTIONS_REMINDER_TOOLTIP"] =
    "Показывает всплывающее окно при входе в мифическое подземелье текущего сезона, если другая специализация добычи даст лучшие шансы на выбранные предметы."
L["OPTIONS_PREVIEW_REMINDER"] = "Предпросмотр"

-- ── Панель обзора подземелий (DungeonOverview.lua) ───────────────────────────

L["DUNGEON_OVERVIEW_SUBTITLE"] = "Подземелья М+ — Шанс добычи"
L["DUNGEON_OVERVIEW_COL_DUNGEON"] = "ПОДЗЕМЕЛЬЕ"
L["DUNGEON_OVERVIEW_COL_SPEC"] = "СПЕК"
L["DUNGEON_OVERVIEW_COL_LOOTED"] = "ПОЛУЧЕНО"
L["DUNGEON_OVERVIEW_COL_CHANCE"] = "ШАНС"
L["DUNGEON_OVERVIEW_ALL_DONE"] = "Все предметы подземелья получены!"
L["DUNGEON_OVERVIEW_NO_DATA"] = "Данные о подземельях сезона пока недоступны."

L["RAID_OVERVIEW_SUBTITLE"] = "Боссы рейда — Шанс добычи"
L["RAID_OVERVIEW_COL_BOSS"] = "БОСС"
L["RAID_OVERVIEW_NO_DATA"] = "Нет данных о встречах в рейде."

-- ── Всплывающий выбор специализации (PanelColumns.lua) ───────────────────────

L["SPEC_PICKER_TITLE"] = "Получено как:"
L["SPEC_PICKER_OK"] = "OK"
L["OBTAINED_UNKNOWN_SPEC"] = "Получено (специализация неизвестна)"
L["UNKNOWN_KEYLEVEL"] = "неизвестный уровень ключа"
L["MANUAL_ENTRY"] = "ручной ввод"

-- ── Панель слотов (DungeonOverview.lua) ──────────────────────────────────────

L["SLOT_FILTER_TOGGLE"] = "Фильтр по слоту"
L["SLOT_FILTER_CLEAR"] = "Снять выбор со всех предметов слота"
L["SLOT_FILTER_CLEAR_CONFIRM"] = "Очистить весь выбор предметов?"
L["SLOT_FILTER_CLEAR_CONFIRM_BODY"] =
    "Все выбранные предметы будут сняты с выбора."

L["SLOT_head"] = "Голова"
L["SLOT_neck"] = "Шея"
L["SLOT_shoulder"] = "Плечи"
L["SLOT_back"] = "Спина"
L["SLOT_chest"] = "Грудь"
L["SLOT_wrist"] = "Запястья"
L["SLOT_hands"] = "Руки"
L["SLOT_waist"] = "Пояс"
L["SLOT_legs"] = "Ноги"
L["SLOT_feet"] = "Ступни"
L["SLOT_finger"] = "Палец"
L["SLOT_trinket"] = "Аксессуар"
L["SLOT_SELECT_ALL"] = "Выбрать все"
L["SLOT_DESELECT_ALL"] = "Снять все"
L["SLOT_NONE_SELECTED"] = "Ничего не выбрано"
L["SLOT_weapon"] = "Оружие"
L["SLOT_offhand"] = "Вторая рука"

-- ── Сканирование Туманного кэша (VoidcacheScan.lua / DungeonOverview.lua) ─────

L["SCAN_BTN"] = "Сканировать спеки добычи"
L["SCAN_PROGRESS"] = "Сканирование %d/%d..."
L["SCAN_COMPLETE"] = "✓ Сканирование завершено"
L["SCAN_ABORTED"] = "Сканирование отменено"
L["SCAN_CONFIRM_TITLE"] = "Сканировать спеки добычи?"
L["SCAN_CONFIRM_BODY"] =
    "Будет выполнено сканирование подсказки Туманного кэша Пустоты для каждой специализации добычи во всех подземельях сезона.\n\nСканируемая сложность:\n|cffffff00Мифический+ уровень ключа +10|r|cffaaaaaa\n\nСуществующие данные о полученных предметах в подземельях будут сброшены.\n\nНе входите в бой и подземелье во время сканирования."
L["SCAN_UNAVAILABLE_COMBAT"] = "Сканирование невозможно в бою."
L["SCAN_UNAVAILABLE_INSTANCE"] = "Сканирование невозможно внутри подземелья."
L["RAID_SCAN_CONFIRM_TITLE"] = "Сканировать спеки добычи рейда?"
L["RAID_SCAN_CONFIRM_BODY"] =
    "Будет выполнено сканирование подсказки Туманного кэша Пустоты для каждой специализации добычи во всех Мифических столкновениях рейда.\n\nСканируемая сложность:\n|cffffff00Мифический|r|cffaaaaaa\n\nСуществующие данные о Мифических рейдовых предметах будут сброшены.\n\nНе входите в бой во время сканирования."

-- ── Команды (дополнения) ──────────────────────────────────────────────────────

L["HELP_REPLAYLOG"] =
    "  /void replaylog – повторно применить все записи журнала бросков как полученные"
L["RESTORE_COMPLETE"] = "Из резервной копии восстановлено %d предмет(ов)."
L["RESTORE_NO_BACKUP"] =
    "Резервная копия отсутствует. Сначала выполните сканирование."
L["RESTORE_FAILED"] = "Восстановление не удалось."

-- ── Окно подтверждения бонусного броска (BonusRollConfirm.lua) ───────────────

L["BONUS_ROLL_CONFIRM_SUBTITLE"] = "Подтвердить бросок Туманного ядра Бездны"
L["BONUS_ROLL_CONFIRM_SPEC_LABEL"] = "Активная специализация добычи:"
L["BONUS_ROLL_CONFIRM_POOL"] = "Осталось %d предмет(ов) в пуле"
L["BONUS_ROLL_CONFIRM_CHANCE"] = "%d%% шанс (%d нужных предмета(ов))"
L["BONUS_ROLL_CONFIRM_CHANCE_ONE"] = "%d%% шанс (1 нужный предмет)"
L["BONUS_ROLL_CONFIRM_ALL_OBTAINED"] =
    "Все предметы получены для данной специализации"
L["BONUS_ROLL_CONFIRM_NO_ITEMS"] =
    "Нет желаемых предметов для данной специализации"
L["BONUS_ROLL_CONFIRM_NO_ITEMS_OTHER_SPECS"] =
    "У других специализаций есть желаемые предметы"
L["BONUS_ROLL_CONFIRM_NO_SELECTED"] = "Нет желаемых предметов"
L["BONUS_ROLL_CONFIRM_NOT_TRACKED"] =
    "Источник не отслеживается — шансы недоступны"
L["BONUS_ROLL_CONFIRM_WARNING_HEADER"] =
    "|A:Ping_Chat_Warning:14:14|a |cffffff00Бросок сбросит защиту от неудач|r"
L["BONUS_ROLL_CONFIRM_WARNING_BODY"] =
    "После этого броска ранее полученные предметы снова могут упасть для всех специализаций."
L["BONUS_ROLL_CONFIRM_QUESTION"] = "Хотите бросить кубик на добычу?"
L["BONUS_ROLL_CONFIRM_ROLL"] = "Бросить"
L["BONUS_ROLL_CONFIRM_PASS"] = "Пропустить"
L["BONUS_ROLL_CONFIRM_CONFIRM"] = "Подтвердить бросок"
L["BONUS_ROLL_CONFIRM_PASS_CONFIRM"] = "Подтвердить пропуск"
L["BONUS_ROLL_CONFIRM_CLOSE"] = "Закрыть"
L["BONUS_ROLL_POPUP_ROLL"] =
    "Потратить Туманное ядро Бездны на бонусный бросок?"
L["BONUS_ROLL_POPUP_PASS"] = "Пропустить этот бонусный бросок?"

-- ── Панель настроек (дополнения) ─────────────────────────────────────────────

L["OPTIONS_PREVIEW_BONUS_ROLL"] = "Предпросмотр"
L["BONUS_ROLL_CONFIRM_COST"] = "Стоимость: |cffffff00%d|r  \194\183  У вас: |cffffff00%d|r"
L["OPTIONS_BONUS_ROLL_CONFIRM"] = "Окно бонусного броска"
L["OPTIONS_BONUS_ROLL_CONFIRM_TOOLTIP"] =
    "Показывает информацию VoidcoreAdvisor при появлении окна бонусного броска Туманного ядра Бездны, включая активную специализацию добычи и шансы на предметы."
L["OPTIONS_BRC_SPEC_LIST"] =
    "Показывать оставшиеся предметы по специализациям"
L["OPTIONS_BRC_SPEC_LIST_TOOLTIP"] =
    "Показывает список оставшихся предметов для каждой из ваших специализаций в окне бонусного броска."
L["BRC_SWITCH_SPEC_TIP"] = "Switch specialization to %s"

-- ── VoidcoreAdvisor Reborn additions ─────────────────────────────────────────────
L["BRC_SWITCH_SPEC_TIP"] = "Сменить специализацию на %s"
L["SPEC_LIST_TOOLTIP"] = "Оставшаяся добыча для каждой специализации добычи"
L["BONUS_ROLL_WANTED_TOOLTIP_TITLE"] = "Желаемые предметы"
L["DIFFICULTY_NORMAL"] = "Обычный"
L["DIFFICULTY_HEROIC"] = "Героический"
L["DIFFICULTY_MYTHIC"] = "Эпохальный"
L["MARK_MODE_BUTTON"] = "Отметить полученный предмет"
L["MARK_MODE_ACTIVE"] = "Нажмите на предмет, чтобы отметить его (нажмите здесь, чтобы закончить)"
L["MARK_MODE_TIP"] = "Используйте для предметов, полученных за бонусный бросок Ядра Бездны, которые аддон не отследил. Пока режим включён, нажмите на предмет, чтобы отметить его полученным для всех специализаций, или нажмите ещё раз, чтобы снять отметку."
L["RAID_NOT_IN_DATA"] = "Этого рейда пока нет в данных о добыче аддона. Он загружается автоматически, когда это возможно; иначе обновите VoidcoreAdvisor Reborn."
L["ORIGINAL_ADDON_LOADED"] = "Оригинальный VoidcoreAdvisor тоже включён. Отключите его: обе версии не могут работать вместе."
L["BONUS_ROLL_POPUP_ROLL"] = "Вы уверены, что хотите потратить Туманное ядро Бездны на бонусный бросок?"
L["BONUS_ROLL_POPUP_PASS"] = "Вы уверены, что хотите отказаться от этого бонусного броска?"
L["OPTIONS_BRC_CONFIRM"] = "Спрашивать подтверждение перед броском или отказом"
L["OPTIONS_BRC_CONFIRM_TOOLTIP"] = "Показывает сообщение «Вы уверены?» при нажатии «Бросить» или «Пропустить»."
