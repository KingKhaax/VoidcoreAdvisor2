# Changelog

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
