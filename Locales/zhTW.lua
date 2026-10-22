-- VoidcoreAdvisor: Locale – Chinese (Traditional)
local _, VCA = ...
if (VCA.ForcedLocale or GetLocale()) ~= "zhTW" then
    return
end
local L = VCA.L

-- ── Panel UI ──────────────────────────────────────────────────────────────────

L["PANEL_TITLE"] = "|cff9fe08a虛無核心|r|cffdddddd助手|r"

L["COL_LOOT"] = "拾取"
L["COL_SPEC_RANKING"] = "專精排名"
L["COL_SPEC_FIT"] = "專精適配"
L["COL_LOOT_FILTERED"] = "拾取（已篩選）"
L["COL_LOOT_FILTERED_N"] = "拾取（已篩選 %d 個專精）"

L["CONTENT_RAID_BOSS"] = "團隊首領"
L["CONTENT_MP_DUNGEON"] = "傳奇鑰石地城"
L["NEBULOUS_VOIDCORE"] = "星雲虛無核心"
L["NEBULOUS_VOIDCORES"] = "星雲虛無核心"

L["NO_ITEMS_FOR_SPEC"] = "此專精沒有可用物品"

L["LOOT_SPEC_LABEL"] = "拾取："
L["ALL_OBTAINED"] = "|TInterface\\Buttons\\UI-CheckBox-Check:14:14|t 全部"

L["DETECTED_OBTAINED"] = "已自動偵測到 %s 透過星雲虛無核心取得。"

L["CLEAR_SELECTED"] = "清除選擇"

-- ── Slash commands ────────────────────────────────────────────────────────────

L["RESET_CONFIRM"] = "所有已取得物品資料已重設。"
L["NEW_SEASON_RESET"] = "偵測到新賽季——已選擇及已取得的物品已清除。"
L["COUNT_FORMAT"] = "已標記 %d 件物品為透過虛無核心取得。"
L["SPEC_FORMAT"] = "目前拾取專精 ID：%s%s"
L["FOLLOWS_ACTIVE_SPEC"] = "（跟隨目前專精）"
L["SOURCE_FORMAT"] = "目前來源 - 類型：%s  來源ID：%s  難度：%s"
L["NO_ACTIVE_SOURCE"] = "未設定活動來源。"
L["VERSION_FORMAT"] = "版本 %s"
L["HELP_HEADER"] = "指令："
L["HELP_RESET"] = "  /void reset    – 重設所有已取得物品資料"
L["HELP_COUNT"] = "  /void count    – 顯示已取得物品總數"
L["HELP_SPEC"] = "  /void spec     – 顯示拾取專精 ID"
L["HELP_SOURCE"] = "  /void source   – 顯示目前偵測來源"
L["HELP_VERSION"] = "  /void version  – 顯示插件版本"
L["HELP_RESTORE"] = "  /void restore  – 從掃描前備份還原已獲得資料"

-- ── 面板 UI（補充）────────────────────────────────────────────────────────────

L["LFR_NOT_ELIGIBLE"] = "在尋找團隊中不可用"

L["TOGGLE_SHOW"] = "點擊顯示顧問面板。"
L["TOGGLE_HIDE"] = "點擊隱藏顧問面板。"
L["TOGGLE_OVERVIEW_SHOW"] = "點擊顯示地城概覽。"
L["TOGGLE_OVERVIEW_HIDE"] = "點擊隱藏地城概覽。"

-- ── 提醒彈窗（Reminder.lua）──────────────────────────────────────────────────

L["REMINDER_TITLE"] = "|cff9fe08a虛無核心|r|cffdddddd助手|r"
L["REMINDER_SUBTITLE"] = "優化您的拾取專精以獲得星雲虛無核心獎勵！"
L["REMINDER_VOIDCORE_COUNT"] = "您有 |cffffff00%d|r 個星雲虛無核心"
L["REMINDER_CURRENT_SPEC"] = "目前拾取專精："
L["REMINDER_RECOMMENDED"] = "推薦專精："
L["REMINDER_ITEMS_SELECTED"] = "已選擇 %d 件物品"
L["REMINDER_SELECTED_CHANCE"] = "選中物品的機率 %d%%"
L["REMINDER_CHANGE_PROMPT"] = "將拾取專精更改為 |cffffff00%s|r？"
L["REMINDER_YES"] = "是，更改"
L["REMINDER_NO"] = "不，謝謝"
L["REMINDER_WARNING_ONE_ITEM"] =
    "|cffff8000警告：|r 該專精在本地城中|cffff0000只剩1件物品|r。以該專精使用星雲虛無核心將|cffff0000重置本地城所有專精的戰利品池|r！"
L["REMINDER_SPEC_LIST_HEADER"] = "各專精剩餘物品："
L["REMINDER_SPEC_REMAINING"] = "剩餘 %d 件"
L["REMINDER_SPEC_NONE"] = "無剩餘"
L["SPEC_LIST_TOOLTIP_TITLE"] = "戰利品保護"
L["SPEC_LIST_ITEM_ONE"] = "還有1件物品"
L["SPEC_LIST_ITEM_MANY"] = "還有%d件物品"
L["SPEC_LIST_ALL_OBTAINED"] = "全部已獲得"

-- ── 戰利品池重置警告彈窗（Reminder.lua）─────────────────────────────────────

L["WARNING_TITLE"] = "|cff9fe08a虛無核心|r|cffdddddd助手|r"
L["WARNING_SUBTITLE"] = "戰利品池重置風險"
L["WARNING_VOIDCORE_COUNT"] = "你有 |cffffff00%d|r 個星雲虛無核心"
L["WARNING_FAVORED_SPEC"] = "你正在使用首選拾取專精："
L["WARNING_ONE_ITEM"] =
    "|cffff8000警告：|r 該專精在本地城中|cffff0000只剩 %d 件物品|r。使用星雲虛無核心將|cffff0000重置本地城所有專精的戰利品池|r！"
L["WARNING_SPEC_LIST_HEADER"] = "各專精剩餘物品："
L["WARNING_CLOSE"] = "關閉"

-- ── 選項面板（Options.lua）───────────────────────────────────────────────────

L["OPTIONS_CAT_REMINDER"] = "拾取專精提醒"
L["OPTIONS_CAT_BONUS_ROLL"] = "額外擲骰"

L["OPTIONS_REMINDER_ENABLE"] = "拾取專精提醒"
L["OPTIONS_REMINDER_TOOLTIP"] =
    "當進入當前賽季傳奇鑰石地城時，如果其他拾取專精能為選定物品提供更好的機率，則顯示彈出視窗。"
L["OPTIONS_PREVIEW_REMINDER"] = "預覽"

-- ── 地城概覽面板（DungeonOverview.lua）───────────────────────────────────────

L["DUNGEON_OVERVIEW_SUBTITLE"] = "傳奇鑰石地城 — 拾取機率"
L["DUNGEON_OVERVIEW_COL_DUNGEON"] = "地城"
L["DUNGEON_OVERVIEW_COL_SPEC"] = "專精"
L["DUNGEON_OVERVIEW_COL_LOOTED"] = "已取得"
L["DUNGEON_OVERVIEW_COL_CHANCE"] = "機率"
L["DUNGEON_OVERVIEW_ALL_DONE"] = "所有地城物品均已取得！"
L["DUNGEON_OVERVIEW_NO_DATA"] = "賽季地城資料暫不可用。"

L["RAID_OVERVIEW_SUBTITLE"] = "團隊首領 — 拾取機率"
L["RAID_OVERVIEW_COL_BOSS"] = "首領"
L["RAID_OVERVIEW_NO_DATA"] = "沒有團隊遭遇資料可用。"

-- ── 專精選擇彈窗（PanelColumns.lua）──────────────────────────────────────────

L["SPEC_PICKER_TITLE"] = "取得方式："
L["SPEC_PICKER_OK"] = "確定"
L["OBTAINED_UNKNOWN_SPEC"] = "已取得（專精未知）"
L["UNKNOWN_KEYLEVEL"] = "未知鑰石等級"
L["MANUAL_ENTRY"] = "手動輸入"

-- ── 欄位抽屜（DungeonOverview.lua）──────────────────────────────────────────

L["SLOT_FILTER_TOGGLE"] = "依部位篩選"
L["SLOT_FILTER_CLEAR"] = "取消選擇所有部位物品"
L["SLOT_FILTER_CLEAR_CONFIRM"] = "清除所有物品選擇？"
L["SLOT_FILTER_CLEAR_CONFIRM_BODY"] = "所有已選擇的物品將被取消選擇。"

L["SLOT_head"] = "頭部"
L["SLOT_neck"] = "頸部"
L["SLOT_shoulder"] = "肩部"
L["SLOT_back"] = "背部"
L["SLOT_chest"] = "胸部"
L["SLOT_wrist"] = "手腕"
L["SLOT_hands"] = "手部"
L["SLOT_waist"] = "腰部"
L["SLOT_legs"] = "腿部"
L["SLOT_feet"] = "腳部"
L["SLOT_finger"] = "指環"
L["SLOT_trinket"] = "飾品"
L["SLOT_SELECT_ALL"] = "全選"
L["SLOT_DESELECT_ALL"] = "取消全選"
L["SLOT_NONE_SELECTED"] = "未選擇任何內容"
L["SLOT_weapon"] = "武器"
L["SLOT_offhand"] = "副手"

-- ── 虛空緩存掃描 (VoidcacheScan.lua / DungeonOverview.lua) ────────────────────

L["SCAN_BTN"] = "掃描拾取專精"
L["SCAN_PROGRESS"] = "掃描中 %d/%d..."
L["SCAN_COMPLETE"] = "✓ 掃描完成"
L["SCAN_ABORTED"] = "掃描已取消"
L["SCAN_CONFIRM_TITLE"] = "掃描拾取專精？"
L["SCAN_CONFIRM_BODY"] =
    "將掃描本賽季所有副本中每個拾取專精的星雲虛空緩存提示。\n\n掃描的難度：\n|cffffff00神話+ 鑰匙等級 +10|r|cffaaaaaa\n\n現有副本已獲得數據將被重置。\n\n掃描期間請勿進入戰鬥或副本。"
L["SCAN_UNAVAILABLE_COMBAT"] = "戰鬥中無法掃描。"
L["SCAN_UNAVAILABLE_INSTANCE"] = "副本中無法掃描。"
L["RAID_SCAN_CONFIRM_TITLE"] = "掃描團隊副本拾取專精？"
L["RAID_SCAN_CONFIRM_BODY"] =
    "將掃描所有神話團隊副本遭遇中每個拾取專精的星雲虛空緩存提示。\n\n掃描的難度：\n|cffffff00神話|r|cffaaaaaa\n\n現有神話團隊副本已獲得數據將被重置。\n\n掃描期間請勿進入戰鬥。"

-- ── 斜線指令（補充）──────────────────────────────────────────────────────────

L["HELP_REPLAYLOG"] = "  /void replaylog – 重新將所有擲骰記錄條目標記為已取得"
L["RESTORE_COMPLETE"] = "已從備份還原 %d 件物品。"
L["RESTORE_NO_BACKUP"] = "沒有可用備份。請先執行掃描。"
L["RESTORE_FAILED"] = "還原失敗。"

-- ── 額外擲骰確認視窗（BonusRollConfirm.lua）─────────────────────────────────

L["BONUS_ROLL_CONFIRM_SUBTITLE"] = "確認星雲虛無核心擲骰"
L["BONUS_ROLL_CONFIRM_SPEC_LABEL"] = "活躍拾取專精："
L["BONUS_ROLL_CONFIRM_POOL"] = "池中剩餘 %d 件物品"
L["BONUS_ROLL_CONFIRM_CHANCE"] = "%d%% 機率（%d 件想要的物品）"
L["BONUS_ROLL_CONFIRM_CHANCE_ONE"] = "%d%% 機率（1 件想要的物品）"
L["BONUS_ROLL_CONFIRM_ALL_OBTAINED"] = "該專精的所有物品已取得"
L["BONUS_ROLL_CONFIRM_NO_ITEMS"] = "該專精沒有想要的物品"
L["BONUS_ROLL_CONFIRM_NO_ITEMS_OTHER_SPECS"] = "其他專精有想要的物品"
L["BONUS_ROLL_CONFIRM_NO_SELECTED"] = "沒有想要的物品"
L["BONUS_ROLL_CONFIRM_NOT_TRACKED"] = "來源未追蹤 — 無機率資訊"
L["BONUS_ROLL_CONFIRM_WARNING_HEADER"] = "|A:Ping_Chat_Warning:14:14|a |cffffff00擲骰將重置倒楣保護|r"
L["BONUS_ROLL_CONFIRM_WARNING_BODY"] = "此次擲骰後，先前已掉落的物品可再次為所有專精掉落。"
L["BONUS_ROLL_CONFIRM_QUESTION"] = "是否要擲骰獲取戰利品？"
L["BONUS_ROLL_CONFIRM_ROLL"] = "擲骰"
L["BONUS_ROLL_CONFIRM_PASS"] = "跳過"
L["BONUS_ROLL_CONFIRM_CONFIRM"] = "確認擲骰"
L["BONUS_ROLL_CONFIRM_PASS_CONFIRM"] = "確認跳過"
L["BONUS_ROLL_CONFIRM_CLOSE"] = "關閉"
L["BONUS_ROLL_POPUP_ROLL"] = "消耗星雲虛無核心進行額外擲骰？"
L["BONUS_ROLL_POPUP_PASS"] = "跳過此次額外擲骰？"

-- ── 選項面板（補充）──────────────────────────────────────────────────────────

L["OPTIONS_PREVIEW_BONUS_ROLL"] = "預覽"
L["BONUS_ROLL_CONFIRM_COST"] = "費用：|cffffff00%d|r  \194\183  擁有：|cffffff00%d|r"
L["OPTIONS_BONUS_ROLL_CONFIRM"] = "額外擲骰視窗"
L["OPTIONS_BONUS_ROLL_CONFIRM_TOOLTIP"] =
    "當星雲虛無核心額外擲骰視窗出現時，顯示 VoidcoreAdvisor 資訊，包含活躍拾取專精和物品機率。"
L["OPTIONS_BRC_SPEC_LIST"] = "顯示每個專精的剩餘物品"
L["OPTIONS_BRC_SPEC_LIST_TOOLTIP"] = "在額外擲骰視窗中顯示每個專精的剩餘物品列表。"
L["BRC_SWITCH_SPEC_TIP"] = "Switch specialization to %s"

-- ── VoidcoreAdvisor Reborn additions ─────────────────────────────────────────────
L["BRC_SWITCH_SPEC_TIP"] = "切換到%s專精"
L["SPEC_LIST_TOOLTIP"] = "各拾取專精的剩餘戰利品"
L["BONUS_ROLL_WANTED_TOOLTIP_TITLE"] = "想要的物品"
L["DIFFICULTY_NORMAL"] = "普通"
L["DIFFICULTY_HEROIC"] = "英雄"
L["DIFFICULTY_MYTHIC"] = "傳奇"
L["MARK_MODE_BUTTON"] = "標記已獲得物品"
L["MARK_MODE_ACTIVE"] = "點擊物品進行標記（點擊此處結束）"
L["MARK_MODE_TIP"] = "用於透過虛空之核擲骰獲得、但插件未記錄的物品。啟用後，點擊物品即可將其標記為所有專精已獲得，再次點擊則取消標記。"
L["RAID_NOT_IN_DATA"] = "此團隊副本尚未包含在插件的戰利品資料中。條件允許時會自動載入；否則請更新 VoidcoreAdvisor Reborn。"
L["ORIGINAL_ADDON_LOADED"] = "原版 VoidcoreAdvisor 也已啟用。請停用它：兩個版本無法同時執行。"
L["BONUS_ROLL_POPUP_ROLL"] = "確定要消耗虛空之核進行額外擲骰嗎？"
L["BONUS_ROLL_POPUP_PASS"] = "確定要放棄這次額外擲骰嗎？"
L["OPTIONS_BRC_CONFIRM"] = "擲骰或放棄前要求確認"
L["OPTIONS_BRC_CONFIRM_TOOLTIP"] = "點擊擲骰或放棄時顯示「確定嗎？」提示。"

-- ── VoidcoreAdvisor Reborn 2.1 additions ──────────────────────────────────────
L["MISSING_TITLE"] = "缺少的物品"
L["MISSING_EMPTY"] = "你已擁有此拾取專精的所有物品。"
L["PANEL_NOT_FOUND"] = "沒有符合「%s」的首領或地城。"
L["EXPORT_TITLE"] = "匯出已標記物品"
L["IMPORT_TITLE"] = "匯入已標記物品"
L["IMPORT_BUTTON"] = "匯入"
L["IMPORT_OK"] = "已匯入 %d 件物品。"
L["IMPORT_BAD"] = "該文字不是有效的匯出內容。"
L["TRANSFER_COPY_HINT"] = "按 Ctrl+C 複製此文字。"
L["TRANSFER_PASTE_HINT"] = "在此貼上匯出的文字，然後點擊匯入。"
L["OPTIONS_THEME"] = "顏色主題"
L["OPTIONS_THEME_TOOLTIP"] = "更改所有 VoidcoreAdvisor 視窗的顏色。"
L["THEME_GREEN"] = "毒液綠"
L["THEME_PURPLE"] = "虛空紫"
L["THEME_BLUE"] = "秘法藍"
L["ONE_ITEM_WARN"] = "此專精只剩 1 件物品：擲骰將重置你的拾取保護！"
L["MARK_MODE_SHIFT_TIP"] = "按住 Shift 並點擊第二件物品，可標記兩者之間的所有物品。"
L["DATA_OUTDATED"] = "新團隊副本尚未包含在戰利品資料中：%s。開發者需要更新 VoidcoreAdvisor Reborn。"
L["HELP_PANEL"] = "  /void panel [名稱] – 在某個首領或地城開啟冒險指南"
L["HELP_MISSING"] = "  /void missing [14|15|16] – 列出所有仍缺少的物品"
L["HELP_EXPORT"] = "  /void export – 將已標記物品複製為文字"
L["HELP_IMPORT"] = "  /void import – 貼上其他角色的已標記物品"
L["HELP_THEME"] = "  /void theme <name> – 更改視窗顏色"
L["HELP_RESETPANEL"] = "  /void resetpanel – 將面板放回指南旁邊"
L["THEME_LIGHT"] = "聖光"
L["THEME_FIRE"] = "火焰"
L["THEME_FROST"] = "冰霜"
L["THEME_RED"] = "紅色"
L["THEME_CLASS"] = "我的職業風格"
L["HELP_SCAN"] = "  /void scan [raid 14|15|16] – 讀取虛空寶箱，標記已使用硬幣獲得的物品"
L["SCAN_TIP"] = "提示：輸入 /void scan 可標記你已使用的虛空之核硬幣所獲得的物品。"
L["MARK_MODE_ACTIVE"] = "點擊物品，然後點擊此處儲存"
L["MARK_MODE_TIP"] = "點擊此欄，然後點擊插件未記錄的、透過虛空之核擲骰獲得的物品：它們會立即變暗。再次點擊此欄即可儲存。"
L["THEME_CURRENT"] = "與我的主題相同"
L["OPTIONS_ROLL_THEME"] = "額外擲骰視窗主題"
L["OPTIONS_ROLL_THEME_TOOLTIP"] = "選擇額外擲骰視窗的顏色主題，與插件其他部分的主題相互獨立。"
L["REMINDER_WARNING_ONE_ITEM_BOSS"] = "|cffff8000警告：|r 此專精在該首領處|cffff0000只剩 1 件物品|r。以此專精使用虛空之核將|cffff0000重置該首領所有專精的戰利品池|r！"
L["WARNING_ONE_ITEM_BOSS"] = "|cffff8000警告：|r 此專精在該首領處|cffff0000只剩 %d 件物品|r。使用虛空之核將|cffff0000重置該首領所有專精的戰利品池|r！"
L["OPTIONS_REMINDER_BOSS"] = "在團隊首領面前也提醒"
L["OPTIONS_REMINDER_BOSS_TOOLTIP"] = "開怪前將當前賽季的團隊首領設為目標時，每個首領顯示一次同樣的視窗。"
L["OPTIONS_REMINDER_THEME"] = "提醒視窗主題"
L["OPTIONS_REMINDER_THEME_TOOLTIP"] = "選擇拾取專精提醒視窗的顏色主題，與插件其他部分的主題相互獨立。"
L["HELP_OPEN"] = "  /void open – 開啟選項頁面（主題和預覽）"
L["MARK_MODE_ACTIVE"] = "點擊儲存"
L["RAID_OVERVIEW_EMPTY_HINT"] = "尚未選擇物品。\n點擊清單中的首領，再點擊你想要的物品：這裡會顯示每個首領的機率。"
L["DIFFICULTY_MYTHIC_PLUS"] = "傳奇+"
