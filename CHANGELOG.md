# Changelog

## 2.0.0
- Fork of VoidcoreAdvisor 2.4.0 by rolferik12 (MIT, with permission).
- Patch 12.1.5: replaced removed global `GetItemInfo` and `GetItemQualityColor` with `C_Item` versions.
- New `Core/LiveRaid.lua`: reads loot tables of raids missing from SeasonData (The Unbinding of Kith'ix) from the Encounter Journal, without touching the season fingerprint so obtained items are never reset.
- Interface version 12.1.5 added.
