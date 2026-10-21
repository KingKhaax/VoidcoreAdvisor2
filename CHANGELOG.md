# Changelog

## 2.2.4
- Login item-cache warmup is gentler (about 80 items per second instead of 600) to avoid frame rate dips right after logging in.

## 2.2.3
- The bonus roll window showed a cost of 2 for raid bosses; it now shows the real cost reported by the roll prompt (and 1 when the prompt gives none). The cost in the panel header follows the same fallback.

## 2.2.2
- The "new raid not in the loot data" message no longer names the expansion's world boss entry ("Midnight"): entries named like the expansion or without a map are ignored.

## 2.2.1
- New /void scan [raid 14|15|16] command: reads the Voidcache of every spec to mark the items you already got from the Voidcores you spent (the same scan as the Scan Loot Specs buttons).
- A one-time hint about /void scan for characters that have nothing marked yet.

## 2.2.0
- 22 color themes: venom green (default), void purple, arcane blue, light, fire, frost, red and one for each of the 13 classes, using the class colors.
- Two themes that follow you: "Style of my class" and "Style of my specialization". They change by themselves when you switch character or specialization.
- /void theme <name> accepts every theme key; /void theme lists them.

## 2.1.2
- The loot of The Unbinding of Kith'ix (Normal, Heroic and Mythic, every class and spec) now ships with the addon in Core/SeasonDataExtra.lua, so nobody needs to scan it. It stays outside the season fingerprint, so obtained items are never reset.
- The "new raid not in the loot data" message ignores world boss entries such as the expansion's own "Midnight" entry.

## 2.1.1
- Bonus roll window: the timer bar no longer covers the cost line when the item name takes two lines.
- Panel: the loot spec label no longer overlaps the spec column title (it is shortened instead).
- /void liveraid now lists the raids it finds in the Adventure Guide, selects each raid before reading its bosses and falls back to any raid of the newest tier that is not in the loot data.

## 2.1.0
- Color themes: venom green (default), void purple and arcane blue, from the options or with /void theme.
- /void panel [name] opens the Adventure Guide on a boss or dungeon with the panel showing.
- /void missing [14|15|16] lists every item you still need for your loot spec, best odds first.
- Shift+click in mark mode marks every item between two clicks.
- /void export and /void import copy your marked items between characters.
- The panel can be moved (drag the header) and resized (corner grip); /void resetpanel restores it.
- Raid overview shows a progress bar per boss.
- Bonus roll window warns louder (red text, sound, confirmation text) when only 1 item is left for your spec.
- A chat message names new raids that are not in the loot data yet.
- All new texts translated in the 11 languages.

## 2.0.2
- Bonus roll window restyled: grey double frame, epic-coloured item border, green Roll and red Pass buttons.
- New option to ask "Are you sure?" before rolling or passing (on by default).
- Fixed the automatic reading of new raids (The Unbinding of Kith'ix): it looked the boss up with the wrong ID. New command /void liveraid forces the scan and prints what happened.

## 2.0.1
- Fixed rolls that were not tracked when the boss selected in the Encounter Journal was not the boss that dropped the item: the item is now searched in the whole raid, and the saved roll log is replayed on login so past rolls get marked.
- New "Mark rolled item" button in the loot column to mark items by hand.
- Bonus roll confirmation window is now enabled by default.
- Message when you open a raid that is not in the loot data yet.
- Slash command is now /void (/voidcoreadvisor2) and a warning is shown if the original addon is also enabled.
- All 11 languages: added missing strings, translated the spec switch tooltip, fixed Spanish wording.

## 2.0.0
- Fork of VoidcoreAdvisor 2.4.0 by rolferik12 (MIT, with permission).
- Patch 12.1.5: replaced removed global `GetItemInfo` and `GetItemQualityColor` with `C_Item` versions.
- New `Core/LiveRaid.lua`: reads loot tables of raids missing from SeasonData (The Unbinding of Kith'ix) from the Encounter Journal, without touching the season fingerprint so obtained items are never reset.
- Interface version 12.1.5 added.
