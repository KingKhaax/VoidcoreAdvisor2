-- VoidcoreAdvisor: Locale – Korean
if GetLocale() ~= "koKR" then
    return
end
local _, VCA = ...
local L = VCA.L

-- ── Panel UI ──────────────────────────────────────────────────────────────────

L["PANEL_TITLE"] = "|cff9fe08a공허핵|r|cffdddddd도우미|r"

L["COL_LOOT"] = "전리품"
L["COL_SPEC_RANKING"] = "전문화 순위"
L["COL_SPEC_FIT"] = "전문화 적합도"
L["COL_LOOT_FILTERED"] = "전리품 (필터됨)"
L["COL_LOOT_FILTERED_N"] = "전리품 (전문화 %d개 필터)"

L["CONTENT_RAID_BOSS"] = "공격대 우두머리"
L["CONTENT_MP_DUNGEON"] = "쐐기돌 던전"
L["NEBULOUS_VOIDCORE"] = "성운의 공허핵"
L["NEBULOUS_VOIDCORES"] = "성운의 공허핵"

L["NO_ITEMS_FOR_SPEC"] = "이 전문화에 해당하는 아이템이 없습니다"

L["LOOT_SPEC_LABEL"] = "전리품:"
L["ALL_OBTAINED"] = "✓ 전부"

L["DETECTED_OBTAINED"] = "%s|1을;를; 성운의 공허핵으로 획득한 것으로 자동 감지했습니다."

L["CLEAR_SELECTED"] = "선택 해제"

-- ── Slash commands ────────────────────────────────────────────────────────────

L["RESET_CONFIRM"] = "획득한 아이템 데이터가 모두 초기화되었습니다."
L["NEW_SEASON_RESET"] =
    "새 시즌이 감지되었습니다 — 선택한 아이템과 획득한 아이템이 초기화되었습니다."
L["COUNT_FORMAT"] = "공허핵으로 획득한 아이템 %d개가 표시되어 있습니다."
L["SPEC_FORMAT"] = "현재 전리품 전문화 ID: %s%s"
L["FOLLOWS_ACTIVE_SPEC"] = " (활성 전문화를 따름)"
L["SOURCE_FORMAT"] = "활성 출처 — 유형: %s  출처ID: %s  난이도: %s"
L["NO_ACTIVE_SOURCE"] = "활성 출처가 설정되지 않았습니다."
L["VERSION_FORMAT"] = "버전 %s"
L["HELP_HEADER"] = "명령어:"
L["HELP_RESET"] = "  /void reset    – 획득 아이템 데이터 초기화"
L["HELP_COUNT"] = "  /void count    – 획득한 아이템 총 수 표시"
L["HELP_SPEC"] = "  /void spec     – 전리품 전문화 ID 표시"
L["HELP_SOURCE"] = "  /void source   – 활성 감지 출처 표시"
L["HELP_VERSION"] = "  /void version  – 애드온 버전 표시"
L["HELP_RESTORE"] = "  /void restore  – 스캔 이전 백업에서 획득 데이터 복원"

-- ── 패널 UI (추가) ────────────────────────────────────────────────────────────

L["LFR_NOT_ELIGIBLE"] = "공격대 찾기에서는 사용 불가"

L["TOGGLE_SHOW"] = "클릭하여 어드바이저 패널을 표시합니다."
L["TOGGLE_HIDE"] = "클릭하여 어드바이저 패널을 숨깁니다."
L["TOGGLE_OVERVIEW_SHOW"] = "클릭하여 던전 개요를 표시합니다."
L["TOGGLE_OVERVIEW_HIDE"] = "클릭하여 던전 개요를 숨깁니다."

-- ── 알림 팝업 (Reminder.lua) ──────────────────────────────────────────────────

L["REMINDER_TITLE"] = "|cff9fe08a공허핵|r|cffdddddd도우미|r"
L["REMINDER_SUBTITLE"] = "성운의 공허핵 보상을 위해 전리품 전문화를 최적화하세요!"
L["REMINDER_VOIDCORE_COUNT"] = "성운의 공허핵이 |cffffff00%d|r개 있습니다"
L["REMINDER_CURRENT_SPEC"] = "현재 전리품 전문화:"
L["REMINDER_RECOMMENDED"] = "권장 전문화:"
L["REMINDER_ITEMS_SELECTED"] = "%d개 아이템 선택됨"
L["REMINDER_SELECTED_CHANCE"] = "선택한 아이템 %d%% 확률"
L["REMINDER_CHANGE_PROMPT"] = "전리품 전문화를 |cffffff00%s|r(으)로 변경하시겠습니까?"
L["REMINDER_YES"] = "예, 변경"
L["REMINDER_NO"] = "아니요"
L["REMINDER_WARNING_ONE_ITEM"] =
    "|cffff8000경고:|r 이 전문화는 이 던전에 |cffff0000아이템이 1개|r 남아 있습니다. 이 전문화로 성운의 공허핵을 사용하면 이 던전의 |cffff0000모든 전문화의 전리품 풀이 초기화|r됩니다!"
L["REMINDER_SPEC_LIST_HEADER"] = "전문화별 남은 아이템:"
L["REMINDER_SPEC_REMAINING"] = "%d개 남음"
L["REMINDER_SPEC_NONE"] = "남은 아이템 없음"
L["SPEC_LIST_TOOLTIP_TITLE"] = "전리품 보호"
L["SPEC_LIST_ITEM_ONE"] = "아이템 1개 남음"
L["SPEC_LIST_ITEM_MANY"] = "아이템 %d개 남음"
L["SPEC_LIST_ALL_OBTAINED"] = "모두 획득"

-- ── 공허 풀 초기화 경고 팝업 (Reminder.lua) ──────────────────────────────────

L["WARNING_TITLE"] = "|cff9fe08a공허핵|r|cffdddddd도우미|r"
L["WARNING_SUBTITLE"] = "전리품 풀 초기화 위험"
L["WARNING_VOIDCORE_COUNT"] = "성운의 공허핵 |cffffff00%d|r개 보유 중"
L["WARNING_FAVORED_SPEC"] = "현재 선호 전리품 전문화를 사용 중입니다:"
L["WARNING_ONE_ITEM"] =
    "|cffff8000경고:|r 이 전문화는 이 던전에 |cffff0000아이템이 %d개|r 남아 있습니다. 성운의 공허핵을 사용하면 이 던전의 |cffff0000모든 전문화의 전리품 풀이 초기화|r됩니다!"
L["WARNING_SPEC_LIST_HEADER"] = "전문화별 남은 아이템:"
L["WARNING_CLOSE"] = "닫기"

-- ── 옵션 패널 (Options.lua) ───────────────────────────────────────────────────

L["OPTIONS_CAT_REMINDER"] = "전리품 전문화 알림"
L["OPTIONS_CAT_BONUS_ROLL"] = "보너스 주사위"

L["OPTIONS_REMINDER_ENABLE"] = "전리품 전문화 알림"
L["OPTIONS_REMINDER_TOOLTIP"] =
    "현재 시즌 쐐기돌 던전에 입장할 때 다른 전리품 전문화가 선택한 아이템에 더 나은 확률을 제공하면 팝업을 표시합니다."
L["OPTIONS_PREVIEW_REMINDER"] = "미리 보기"

-- ── 던전 개요 패널 (DungeonOverview.lua) ─────────────────────────────────────

L["DUNGEON_OVERVIEW_SUBTITLE"] = "쐐기돌 던전 — 전리품 확률"
L["DUNGEON_OVERVIEW_COL_DUNGEON"] = "던전"
L["DUNGEON_OVERVIEW_COL_SPEC"] = "전문화"
L["DUNGEON_OVERVIEW_COL_LOOTED"] = "획득됨"
L["DUNGEON_OVERVIEW_COL_CHANCE"] = "확률"
L["DUNGEON_OVERVIEW_ALL_DONE"] = "모든 던전 아이템을 획득했습니다!"
L["DUNGEON_OVERVIEW_NO_DATA"] = "시즌 던전 데이터를 아직 사용할 수 없습니다."

L["RAID_OVERVIEW_SUBTITLE"] = "공격대 우두머리 — 전리품 확률"
L["RAID_OVERVIEW_COL_BOSS"] = "우두머리"
L["RAID_OVERVIEW_NO_DATA"] = "공격대 조우 데이터를 사용할 수 없습니다."

-- ── 전문화 선택 팝업 (PanelColumns.lua) ──────────────────────────────────────

L["SPEC_PICKER_TITLE"] = "획득 방식:"
L["SPEC_PICKER_OK"] = "확인"
L["OBTAINED_UNKNOWN_SPEC"] = "획득 (전문화 알 수 없음)"
L["UNKNOWN_KEYLEVEL"] = "알 수 없는 열쇠 레벨"
L["MANUAL_ENTRY"] = "수동 입력"

-- ── 슬롯 서랍 (DungeonOverview.lua) ─────────────────────────────────────────

L["SLOT_FILTER_TOGGLE"] = "슬롯으로 필터"
L["SLOT_FILTER_CLEAR"] = "모든 슬롯 아이템 선택 해제"
L["SLOT_FILTER_CLEAR_CONFIRM"] = "모든 아이템 선택을 초기화할까요?"
L["SLOT_FILTER_CLEAR_CONFIRM_BODY"] = "선택된 모든 아이템이 해제됩니다."

L["SLOT_head"] = "머리"
L["SLOT_neck"] = "목"
L["SLOT_shoulder"] = "어깨"
L["SLOT_back"] = "등"
L["SLOT_chest"] = "가슴"
L["SLOT_wrist"] = "손목"
L["SLOT_hands"] = "손"
L["SLOT_waist"] = "허리"
L["SLOT_legs"] = "다리"
L["SLOT_feet"] = "발"
L["SLOT_finger"] = "반지"
L["SLOT_trinket"] = "장신구"
L["SLOT_SELECT_ALL"] = "모두 선택"
L["SLOT_DESELECT_ALL"] = "모두 선택 해제"
L["SLOT_NONE_SELECTED"] = "선택된 항목 없음"
L["SLOT_weapon"] = "무기"
L["SLOT_offhand"] = "보조 손"

-- ── 허공 캐시 스캔 (VoidcacheScan.lua / DungeonOverview.lua) ──────────────────

L["SCAN_BTN"] = "전리품 특성 스캔"
L["SCAN_PROGRESS"] = "스캔 중 %d/%d..."
L["SCAN_COMPLETE"] = "✓ 스캔 완료"
L["SCAN_ABORTED"] = "스캔 취소됨"
L["SCAN_CONFIRM_TITLE"] = "전리품 특성을 스캔하시겠습니까?"
L["SCAN_CONFIRM_BODY"] =
    "이 시즌의 모든 던전에서 각 전리품 특성에 대한 성운 허공 캐시 툴팁을 스캔합니다.\n\n스캔하는 난이도:\n|cffffff00신화+ 열쇠 단계 +10|r|cffaaaaaa\n\n기존 던전 획득 데이터가 초기화됩니다.\n\n스캔 중 전투에 참여하거나 던전에 입장하지 마십시오."
L["SCAN_UNAVAILABLE_COMBAT"] = "전투 중에는 스캔할 수 없습니다."
L["SCAN_UNAVAILABLE_INSTANCE"] = "던전 안에서는 스캔할 수 없습니다."
L["RAID_SCAN_CONFIRM_TITLE"] = "공격대 전리품 특성을 스캔하시겠습니까?"
L["RAID_SCAN_CONFIRM_BODY"] =
    "모든 신화 공격대 전투에서 각 전리품 특성에 대한 성운 허공 캐시 툴팁을 스캔합니다.\n\n스캔하는 난이도:\n|cffffff00신화|r|cffaaaaaa\n\n기존 신화 공격대 획득 데이터가 초기화됩니다.\n\n스캔 중 전투에 참여하지 마십시오."

-- ── 슬래시 명령어 (추가) ──────────────────────────────────────────────────────

L["HELP_REPLAYLOG"] = "  /void replaylog – 모든 주사위 기록 항목을 다시 획득으로 적용"
L["RESTORE_COMPLETE"] = "백업에서 %d개 아이템이 복원되었습니다."
L["RESTORE_NO_BACKUP"] = "사용 가능한 백업이 없습니다. 먼저 스캔을 실행하세요."
L["RESTORE_FAILED"] = "복원에 실패했습니다."

-- ── 보너스 주사위 확인 창 (BonusRollConfirm.lua) ─────────────────────────────

L["BONUS_ROLL_CONFIRM_SUBTITLE"] = "성운의 공허핵 주사위 확인"
L["BONUS_ROLL_CONFIRM_SPEC_LABEL"] = "활성 전리품 전문화:"
L["BONUS_ROLL_CONFIRM_POOL"] = "풀에 %d개 아이템 남음"
L["BONUS_ROLL_CONFIRM_CHANCE"] = "%d%% 확률 (원하는 아이템 %d개)"
L["BONUS_ROLL_CONFIRM_CHANCE_ONE"] = "%d%% 확률 (원하는 아이템 1개)"
L["BONUS_ROLL_CONFIRM_ALL_OBTAINED"] = "이 전문화의 모든 아이템 획득됨"
L["BONUS_ROLL_CONFIRM_NO_ITEMS"] = "이 전문화에 원하는 아이템 없음"
L["BONUS_ROLL_CONFIRM_NO_ITEMS_OTHER_SPECS"] = "다른 전문화에 원하는 아이템 있음"
L["BONUS_ROLL_CONFIRM_NO_SELECTED"] = "원하는 아이템 없음"
L["BONUS_ROLL_CONFIRM_NOT_TRACKED"] = "출처 미추적 — 확률 정보 없음"
L["BONUS_ROLL_CONFIRM_WARNING_HEADER"] =
    "|A:Ping_Chat_Warning:14:14|a |cffffff00주사위를 굴리면 악운 보호가 초기화됩니다|r"
L["BONUS_ROLL_CONFIRM_WARNING_BODY"] =
    "이번 주사위 후 이전에 획득한 아이템이 모든 전문화에 다시 드롭될 수 있습니다."
L["BONUS_ROLL_CONFIRM_QUESTION"] = "전리품을 위해 주사위를 굴리시겠습니까?"
L["BONUS_ROLL_CONFIRM_ROLL"] = "주사위"
L["BONUS_ROLL_CONFIRM_PASS"] = "패스"
L["BONUS_ROLL_CONFIRM_CONFIRM"] = "주사위 확인"
L["BONUS_ROLL_CONFIRM_PASS_CONFIRM"] = "패스 확인"
L["BONUS_ROLL_CONFIRM_CLOSE"] = "닫기"
L["BONUS_ROLL_POPUP_ROLL"] = "성운의 공허핵을 보너스 주사위에 사용하시겠습니까?"
L["BONUS_ROLL_POPUP_PASS"] = "이 보너스 주사위를 패스하시겠습니까?"

-- ── 옵션 패널 (추가) ──────────────────────────────────────────────────────────

L["OPTIONS_PREVIEW_BONUS_ROLL"] = "미리 보기"
L["BONUS_ROLL_CONFIRM_COST"] = "비용: |cffffff00%d|r  \194\183  보유: |cffffff00%d|r"
L["OPTIONS_BONUS_ROLL_CONFIRM"] = "보너스 주사위 창"
L["OPTIONS_BONUS_ROLL_CONFIRM_TOOLTIP"] =
    "성운의 공허핵 보너스 주사위 창이 나타날 때 VoidcoreAdvisor 정보(활성 전리품 전문화 및 아이템 확률 포함)를 표시합니다."
L["OPTIONS_BRC_SPEC_LIST"] = "전문화별 남은 아이템 표시"
L["OPTIONS_BRC_SPEC_LIST_TOOLTIP"] =
    "보너스 주사위 창에서 각 전문화의 남은 아이템 목록을 표시합니다."
L["BRC_SWITCH_SPEC_TIP"] = "Switch specialization to %s"

-- ── VoidcoreAdvisor Reborn additions ─────────────────────────────────────────────
L["BRC_SWITCH_SPEC_TIP"] = "%s 전문화로 전환"
L["SPEC_LIST_TOOLTIP"] = "각 전리품 전문화별 남은 전리품"
L["BONUS_ROLL_WANTED_TOOLTIP_TITLE"] = "원하는 아이템"
L["DIFFICULTY_NORMAL"] = "일반"
L["DIFFICULTY_HEROIC"] = "영웅"
L["DIFFICULTY_MYTHIC"] = "신화"
L["MARK_MODE_BUTTON"] = "획득한 아이템 표시"
L["MARK_MODE_ACTIVE"] = "아이템을 클릭해 표시하세요 (여기를 클릭하면 종료)"
L["MARK_MODE_TIP"] = "공허 핵 굴림으로 얻었지만 애드온이 기록하지 못한 아이템에 사용하세요. 켜 두면 아이템을 클릭해 모든 전문화에서 획득한 것으로 표시하고, 다시 클릭하면 표시를 해제합니다."
L["RAID_NOT_IN_DATA"] = "이 공격대는 아직 애드온의 전리품 데이터에 없습니다. 가능하면 자동으로 불러오며, 그렇지 않으면 VoidcoreAdvisor Reborn을 업데이트하세요."
L["ORIGINAL_ADDON_LOADED"] = "원본 VoidcoreAdvisor도 활성화되어 있습니다. 비활성화하세요. 두 버전은 함께 작동할 수 없습니다."
L["BONUS_ROLL_POPUP_ROLL"] = "공허 핵을 사용해 추가 굴림을 하시겠습니까?"
L["BONUS_ROLL_POPUP_PASS"] = "이 추가 굴림을 넘기시겠습니까?"
L["OPTIONS_BRC_CONFIRM"] = "굴리기 또는 넘기기 전에 확인 요청"
L["OPTIONS_BRC_CONFIRM_TOOLTIP"] = "굴리기나 넘기기를 누르면 '정말입니까?' 메시지를 표시합니다."
