-- VoidcoreAdvisor: Locale – Chinese (Simplified)
local _, VCA = ...
if (VCA.ForcedLocale or GetLocale()) ~= "zhCN" then
    return
end
local L = VCA.L

-- ── Panel UI ──────────────────────────────────────────────────────────────────

L["PANEL_TITLE"] = "|cff9fe08a虚空核心|r|cffdddddd助手|r"

L["COL_LOOT"] = "拾取"
L["COL_SPEC_RANKING"] = "专精排名"
L["COL_SPEC_FIT"] = "专精适配"
L["COL_LOOT_FILTERED"] = "拾取（已筛选）"
L["COL_LOOT_FILTERED_N"] = "拾取（已筛选 %d 个专精）"

L["CONTENT_RAID_BOSS"] = "团队首领"
L["CONTENT_MP_DUNGEON"] = "史诗钥石地下城"
L["NEBULOUS_VOIDCORE"] = "星云虚空核心"
L["NEBULOUS_VOIDCORES"] = "星云虚空核心"

L["NO_ITEMS_FOR_SPEC"] = "该专精没有可用物品"

L["LOOT_SPEC_LABEL"] = "拾取："
L["ALL_OBTAINED"] = "✓ 全部"

L["DETECTED_OBTAINED"] = "已自动检测到 %s 通过星云虚空核心获取。"

L["CLEAR_SELECTED"] = "清除选择"

-- ── Slash commands ────────────────────────────────────────────────────────────

L["RESET_CONFIRM"] = "所有已获取物品数据已重置。"
L["NEW_SEASON_RESET"] = "检测到新赛季——已选择和已获取的物品已清除。"
L["COUNT_FORMAT"] = "已标记 %d 件物品为通过虚空核心获取。"
L["SPEC_FORMAT"] = "当前拾取专精 ID：%s%s"
L["FOLLOWS_ACTIVE_SPEC"] = "（跟随当前专精）"
L["SOURCE_FORMAT"] = "当前来源 - 类型：%s  来源ID：%s  难度：%s"
L["NO_ACTIVE_SOURCE"] = "未设置活动来源。"
L["VERSION_FORMAT"] = "版本 %s"
L["HELP_HEADER"] = "命令："
L["HELP_RESET"] = "  /void reset    – 重置所有已获取物品数据"
L["HELP_COUNT"] = "  /void count    – 显示已获取物品总数"
L["HELP_SPEC"] = "  /void spec     – 显示拾取专精 ID"
L["HELP_SOURCE"] = "  /void source   – 显示当前检测来源"
L["HELP_VERSION"] = "  /void version  – 显示插件版本"
L["HELP_RESTORE"] = "  /void restore  – 从扫描前备份恢复已获得数据"

-- ── 面板 UI（补充）────────────────────────────────────────────────────────────

L["LFR_NOT_ELIGIBLE"] = "在寻找团队中不可用"

L["TOGGLE_SHOW"] = "点击显示顾问面板。"
L["TOGGLE_HIDE"] = "点击隐藏顾问面板。"
L["TOGGLE_OVERVIEW_SHOW"] = "点击显示地下城概览。"
L["TOGGLE_OVERVIEW_HIDE"] = "点击隐藏地下城概览。"

-- ── 提醒弹窗（Reminder.lua）──────────────────────────────────────────────────

L["REMINDER_TITLE"] = "|cff9fe08a虚空核心|r|cffdddddd助手|r"
L["REMINDER_SUBTITLE"] = "优化你的拾取专精以获得星云虚空核心奖励！"
L["REMINDER_VOIDCORE_COUNT"] = "你有 |cffffff00%d|r 个星云虚空核心"
L["REMINDER_CURRENT_SPEC"] = "当前拾取专精："
L["REMINDER_RECOMMENDED"] = "推荐专精："
L["REMINDER_ITEMS_SELECTED"] = "已选择 %d 件物品"
L["REMINDER_SELECTED_CHANCE"] = "选中物品的概率 %d%%"
L["REMINDER_CHANGE_PROMPT"] = "将拾取专精更改为 |cffffff00%s|r？"
L["REMINDER_YES"] = "是，更改"
L["REMINDER_NO"] = "不，谢谢"
L["REMINDER_WARNING_ONE_ITEM"] =
    "|cffff8000警告：|r 该专精在本地下城中|cffff0000只剩1件物品|r。以该专精使用星云虚空核心将|cffff0000重置本地下城所有专精的战利品池|r！"
L["REMINDER_SPEC_LIST_HEADER"] = "各专精剩余物品："
L["REMINDER_SPEC_REMAINING"] = "剩余 %d 件"
L["REMINDER_SPEC_NONE"] = "无剩余"
L["SPEC_LIST_TOOLTIP_TITLE"] = "战利品保护"
L["SPEC_LIST_ITEM_ONE"] = "还有1件物品"
L["SPEC_LIST_ITEM_MANY"] = "还有%d件物品"
L["SPEC_LIST_ALL_OBTAINED"] = "全部已获得"

-- ── 战利品池重置警告弹窗（Reminder.lua）─────────────────────────────────────

L["WARNING_TITLE"] = "|cff9fe08a虚空核心|r|cffdddddd助手|r"
L["WARNING_SUBTITLE"] = "战利品池重置风险"
L["WARNING_VOIDCORE_COUNT"] = "你有 |cffffff00%d|r 个星云虚空核心"
L["WARNING_FAVORED_SPEC"] = "你正在使用首选拾取专精："
L["WARNING_ONE_ITEM"] =
    "|cffff8000警告：|r 该专精在本地下城中|cffff0000只剩 %d 件物品|r。使用星云虚空核心将|cffff0000重置本地下城所有专精的战利品池|r！"
L["WARNING_SPEC_LIST_HEADER"] = "各专精剩余物品："
L["WARNING_CLOSE"] = "关闭"

-- ── 选项面板（Options.lua）───────────────────────────────────────────────────

L["OPTIONS_CAT_REMINDER"] = "拾取专精提醒"
L["OPTIONS_CAT_BONUS_ROLL"] = "额外掷骰"

L["OPTIONS_REMINDER_ENABLE"] = "拾取专精提醒"
L["OPTIONS_REMINDER_TOOLTIP"] =
    "当进入当前赛季史诗钥石地下城时，如果其他拾取专精能为选定物品提供更好的概率，则显示弹出窗口。"
L["OPTIONS_PREVIEW_REMINDER"] = "预览"

-- ── 地下城概览面板（DungeonOverview.lua）─────────────────────────────────────

L["DUNGEON_OVERVIEW_SUBTITLE"] = "史诗钥石地下城 — 拾取概率"
L["DUNGEON_OVERVIEW_COL_DUNGEON"] = "地下城"
L["DUNGEON_OVERVIEW_COL_SPEC"] = "专精"
L["DUNGEON_OVERVIEW_COL_LOOTED"] = "已获取"
L["DUNGEON_OVERVIEW_COL_CHANCE"] = "概率"
L["DUNGEON_OVERVIEW_ALL_DONE"] = "所有地下城物品均已获取！"
L["DUNGEON_OVERVIEW_NO_DATA"] = "赛季地下城数据暂不可用。"

L["RAID_OVERVIEW_SUBTITLE"] = "团队首领 — 拾取概率"
L["RAID_OVERVIEW_COL_BOSS"] = "首领"
L["RAID_OVERVIEW_NO_DATA"] = "没有团队遭遇数据可用。"

-- ── 专精选择弹窗（PanelColumns.lua）──────────────────────────────────────────

L["SPEC_PICKER_TITLE"] = "获取方式："
L["SPEC_PICKER_OK"] = "确定"
L["OBTAINED_UNKNOWN_SPEC"] = "已获取（专精未知）"
L["UNKNOWN_KEYLEVEL"] = "未知钥石等级"
L["MANUAL_ENTRY"] = "手动输入"

-- ── 槽位抽屉（DungeonOverview.lua）──────────────────────────────────────────

L["SLOT_FILTER_TOGGLE"] = "按部位筛选"
L["SLOT_FILTER_CLEAR"] = "取消选择所有部位物品"
L["SLOT_FILTER_CLEAR_CONFIRM"] = "清除所有物品选择？"
L["SLOT_FILTER_CLEAR_CONFIRM_BODY"] = "所有已选择的物品将被取消选择。"

L["SLOT_head"] = "头部"
L["SLOT_neck"] = "颈部"
L["SLOT_shoulder"] = "肩部"
L["SLOT_back"] = "背部"
L["SLOT_chest"] = "胸部"
L["SLOT_wrist"] = "手腕"
L["SLOT_hands"] = "手部"
L["SLOT_waist"] = "腰部"
L["SLOT_legs"] = "腿部"
L["SLOT_feet"] = "脚部"
L["SLOT_finger"] = "指环"
L["SLOT_trinket"] = "饰品"
L["SLOT_SELECT_ALL"] = "全选"
L["SLOT_DESELECT_ALL"] = "取消全选"
L["SLOT_NONE_SELECTED"] = "未选择任何内容"
L["SLOT_weapon"] = "武器"
L["SLOT_offhand"] = "副手"

-- ── 虚空缓存扫描 (VoidcacheScan.lua / DungeonOverview.lua) ────────────────────

L["SCAN_BTN"] = "扫描拾取专精"
L["SCAN_PROGRESS"] = "扫描中 %d/%d..."
L["SCAN_COMPLETE"] = "✓ 扫描完成"
L["SCAN_ABORTED"] = "扫描已取消"
L["SCAN_CONFIRM_TITLE"] = "扫描拾取专精？"
L["SCAN_CONFIRM_BODY"] =
    "将扫描本赛季所有副本中每个拾取专精的星云虚空缓存提示。\n\n扫描的难度：\n|cffffff00神话+ 钥匙等级 +10|r|cffaaaaaa\n\n现有副本已获得数据将被重置。\n\n扫描期间请勿进入战斗或副本。"
L["SCAN_UNAVAILABLE_COMBAT"] = "战斗中无法扫描。"
L["SCAN_UNAVAILABLE_INSTANCE"] = "副本中无法扫描。"
L["RAID_SCAN_CONFIRM_TITLE"] = "扫描团队副本拾取专精？"
L["RAID_SCAN_CONFIRM_BODY"] =
    "将扫描所有神话团队副本遭遇中每个拾取专精的星云虚空缓存提示。\n\n扫描的难度：\n|cffffff00神话|r|cffaaaaaa\n\n现有神话团队副本已获得数据将被重置。\n\n扫描期间请勿进入战斗。"

-- ── 斜线命令（补充）──────────────────────────────────────────────────────────

L["HELP_REPLAYLOG"] = "  /void replaylog – 重新将所有掷骰日志条目标记为已获得"
L["RESTORE_COMPLETE"] = "已从备份恢复 %d 件物品。"
L["RESTORE_NO_BACKUP"] = "没有可用备份。请先运行扫描。"
L["RESTORE_FAILED"] = "恢复失败。"

-- ── 额外掷骰确认窗口（BonusRollConfirm.lua）─────────────────────────────────

L["BONUS_ROLL_CONFIRM_SUBTITLE"] = "确认星云虚空核心掷骰"
L["BONUS_ROLL_CONFIRM_SPEC_LABEL"] = "活跃拾取专精："
L["BONUS_ROLL_CONFIRM_POOL"] = "池中剩余 %d 件物品"
L["BONUS_ROLL_CONFIRM_CHANCE"] = "%d%% 概率（%d 件想要的物品）"
L["BONUS_ROLL_CONFIRM_CHANCE_ONE"] = "%d%% 概率（1 件想要的物品）"
L["BONUS_ROLL_CONFIRM_ALL_OBTAINED"] = "该专精的所有物品已获取"
L["BONUS_ROLL_CONFIRM_NO_ITEMS"] = "该专精没有想要的物品"
L["BONUS_ROLL_CONFIRM_NO_ITEMS_OTHER_SPECS"] = "其他专精有想要的物品"
L["BONUS_ROLL_CONFIRM_NO_SELECTED"] = "没有想要的物品"
L["BONUS_ROLL_CONFIRM_NOT_TRACKED"] = "来源未追踪 — 无概率信息"
L["BONUS_ROLL_CONFIRM_WARNING_HEADER"] = "|A:Ping_Chat_Warning:14:14|a |cffffff00掷骰将重置倒霉保护|r"
L["BONUS_ROLL_CONFIRM_WARNING_BODY"] = "此次掷骰后，之前已掉落的物品可再次为所有专精掉落。"
L["BONUS_ROLL_CONFIRM_QUESTION"] = "是否要掷骰获取战利品？"
L["BONUS_ROLL_CONFIRM_ROLL"] = "掷骰"
L["BONUS_ROLL_CONFIRM_PASS"] = "跳过"
L["BONUS_ROLL_CONFIRM_CONFIRM"] = "确认掷骰"
L["BONUS_ROLL_CONFIRM_PASS_CONFIRM"] = "确认跳过"
L["BONUS_ROLL_CONFIRM_CLOSE"] = "关闭"
L["BONUS_ROLL_POPUP_ROLL"] = "消耗星云虚空核心进行额外掷骰？"
L["BONUS_ROLL_POPUP_PASS"] = "跳过此次额外掷骰？"

-- ── 选项面板（补充）──────────────────────────────────────────────────────────

L["OPTIONS_PREVIEW_BONUS_ROLL"] = "预览"
L["BONUS_ROLL_CONFIRM_COST"] = "费用：|cffffff00%d|r  \194\183  拥有：|cffffff00%d|r"
L["OPTIONS_BONUS_ROLL_CONFIRM"] = "额外掷骰窗口"
L["OPTIONS_BONUS_ROLL_CONFIRM_TOOLTIP"] =
    "当星云虚空核心额外掷骰窗口出现时，显示 VoidcoreAdvisor 信息，包括活跃拾取专精和物品概率。"
L["OPTIONS_BRC_SPEC_LIST"] = "显示每个专精的剩余物品"
L["OPTIONS_BRC_SPEC_LIST_TOOLTIP"] = "在额外掷骰窗口中显示每个专精的剩余物品列表。"
L["BRC_SWITCH_SPEC_TIP"] = "Switch specialization to %s"

-- ── VoidcoreAdvisor Reborn additions ─────────────────────────────────────────────
L["BRC_SWITCH_SPEC_TIP"] = "切换到%s专精"
L["SPEC_LIST_TOOLTIP"] = "各拾取专精的剩余战利品"
L["BONUS_ROLL_WANTED_TOOLTIP_TITLE"] = "想要的物品"
L["DIFFICULTY_NORMAL"] = "普通"
L["DIFFICULTY_HEROIC"] = "英雄"
L["DIFFICULTY_MYTHIC"] = "史诗"
L["MARK_MODE_BUTTON"] = "标记已获得物品"
L["MARK_MODE_ACTIVE"] = "点击物品进行标记（点击此处结束）"
L["MARK_MODE_TIP"] = "用于通过虚空之核骰点获得、但插件未记录的物品。开启后，点击物品即可将其标记为所有专精已获得，再次点击则取消标记。"
L["RAID_NOT_IN_DATA"] = "该团队副本尚未包含在插件的战利品数据中。条件允许时会自动加载；否则请更新 VoidcoreAdvisor Reborn。"
L["ORIGINAL_ADDON_LOADED"] = "原版 VoidcoreAdvisor 也已启用。请禁用它：两个版本不能同时运行。"
L["BONUS_ROLL_POPUP_ROLL"] = "确定要消耗虚空之核进行额外骰点吗？"
L["BONUS_ROLL_POPUP_PASS"] = "确定要放弃这次额外骰点吗？"
L["OPTIONS_BRC_CONFIRM"] = "掷骰或放弃前请求确认"
L["OPTIONS_BRC_CONFIRM_TOOLTIP"] = "点击掷骰或放弃时显示“确定吗？”提示。"

-- ── VoidcoreAdvisor Reborn 2.1 additions ──────────────────────────────────────
L["MISSING_TITLE"] = "缺少的物品"
L["MISSING_EMPTY"] = "你已拥有此拾取专精的所有物品。"
L["PANEL_NOT_FOUND"] = "没有与“%s”匹配的首领或地下城。"
L["EXPORT_TITLE"] = "导出已标记物品"
L["IMPORT_TITLE"] = "导入已标记物品"
L["IMPORT_BUTTON"] = "导入"
L["IMPORT_OK"] = "已导入 %d 件物品。"
L["IMPORT_BAD"] = "该文本不是有效的导出内容。"
L["TRANSFER_COPY_HINT"] = "按 Ctrl+C 复制此文本。"
L["TRANSFER_PASTE_HINT"] = "在此粘贴导出的文本，然后点击导入。"
L["OPTIONS_THEME"] = "颜色主题"
L["OPTIONS_THEME_TOOLTIP"] = "更改所有 VoidcoreAdvisor 窗口的颜色。"
L["THEME_GREEN"] = "毒液绿"
L["THEME_PURPLE"] = "虚空紫"
L["THEME_BLUE"] = "奥术蓝"
L["ONE_ITEM_WARN"] = "此专精只剩 1 件物品：掷骰将重置你的拾取保护！"
L["MARK_MODE_SHIFT_TIP"] = "按住 Shift 并点击第二件物品，可标记两者之间的所有物品。"
L["DATA_OUTDATED"] = "新团队副本尚未包含在战利品数据中：%s。开发者需要更新 VoidcoreAdvisor Reborn。"
L["HELP_PANEL"] = "  /void panel [名称] – 在某个首领或地下城打开冒险指南"
L["HELP_MISSING"] = "  /void missing [14|15|16] – 列出所有仍缺少的物品"
L["HELP_EXPORT"] = "  /void export – 将已标记物品复制为文本"
L["HELP_IMPORT"] = "  /void import – 粘贴其他角色的已标记物品"
L["HELP_THEME"] = "  /void theme <name> – 更改窗口颜色"
L["HELP_RESETPANEL"] = "  /void resetpanel – 将面板放回指南旁边"
L["THEME_LIGHT"] = "圣光"
L["THEME_FIRE"] = "火焰"
L["THEME_FROST"] = "冰霜"
L["THEME_RED"] = "红色"
L["THEME_CLASS"] = "我的职业风格"
L["HELP_SCAN"] = "  /void scan [raid 14|15|16] – 读取虚空宝箱，标记已使用硬币获得的物品"
L["SCAN_TIP"] = "提示：输入 /void scan 可标记你已使用的虚空之核硬币所获得的物品。"
L["MARK_MODE_ACTIVE"] = "点击物品，然后点击此处保存"
L["MARK_MODE_TIP"] = "点击此栏，然后点击插件未记录的、通过虚空之核骰点获得的物品：它们会立即变暗。再次点击此栏即可保存。"
