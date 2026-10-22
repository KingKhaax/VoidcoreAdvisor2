Version: 2.3.0
2026/10/22 Released

🔮 New
- [Options] New **Preview** button on every theme row. The color theme opens a sample window (also `/void preview`) that recolors live, with a counting-down timer bar and < > buttons to look at other themes without changing yours. The bonus roll theme opens the roll window preview and the reminder theme opens the example popup.
- [Options] New **Bonus roll window theme** and **Reminder popup theme** selectors, both defaulting to your class. Use their Preview buttons to see the result.
- [Options] New `/void open` command that opens the addon options page directly.
- [Reminder] The loot spec popup now also appears in front of raid bosses: target a current-season raid boss before the pull and it shows once per boss. It has its own option (on by default) and boss wording in the warning.
- [Reminder] Both popups use the flat themed look of the sample windows (gold corners, spec rows with a progress bar, no clipped text) and show a gold "Reborn" next to the title. Try it with the Preview button of the reminder theme.
- [Bonus Roll] The timer bar shows the time left (for example 2:34) in its center.
- [Panel] **Mark rolled item** works in two steps: press the bar, click the items you got (they dim right away), then press "Click to save". Closing the panel or changing boss discards unsaved marks.
- [Panel] The panel title now shows the difficulty next to the boss or dungeon name: [Raid Finder], [Normal], [Heroic], [Mythic] for raids and [Mythic+] for dungeons, each in its own color.
- [Panel] New line under the spec ranking with the chance to get at least one chosen item with 1 roll, 3 rolls and with the Voidcores you have. Turn it off with "Show cumulative odds" in the options.
- [Voidcores] New `/void cores [14|15|16]`: Voidcores you have, spent this week, and about how many you need to get everything you chose.
- [Voidcores] New `/void next [14|15|16]`: raid bosses and dungeons ranked by your chance of a chosen item. Bosses killed this week go last and the dungeon of your keystone gets a bonus.
- [Voidcores] New `/void history`: your last 200 rolls, how many gave a chosen item and where you rolled most.
- [Wishlist] New `/void prio <item> bis|alt|clear` (full or half weight). Priorities now weigh the spec ranking and `/void next`.
- [Wishlist] New `/void wish`: paste item IDs, links or a Raidbots / Droptimizer list and they are chosen everywhere they drop.
- [Panel] New green + button (and `/void select [clear]`) that chooses everything your loot spec can still get from the open boss or dungeon.
- [Characters] New `/void chars`: Voidcores and missing chosen items of each character, saved when you log out.
- [Reminder] After a wipe, the popup appears again on the next pull of that boss.
- [Live Raid] When the loot data is missing a new raid, a banner appears at the top of the screen as well as the chat message.
- [Support] New `/void debug`: version, settings and recent messages in a window you can copy into a bug report.

💪 Improvement
- [Bonus Roll] The timer bar refreshes 10 times per second instead of every frame, using less CPU. The theme preview does the same.
- [Missing] The missing items list only listens for item data while it is open.
- [Theme] Removed the "Style of my specialization" theme. "Style of my class" stays; anyone who had the specialization theme selected is moved to it.
- [Panel] The roll history keeps the last 200 rolls (it kept 50).
- [Options] The Preview buttons of the "Bonus roll window" and "Loot spec reminder" checkboxes were removed: every preview is now on the theme rows.
- [Options] The Interface version now includes 12.1.7, so the addon is not shown as out of date.

🛠️ Fix
- [Panel] Saving items with the **Mark rolled item** bar did nothing: when the saved items completed a spec's loot pool, the automatic pool reset cleared every marked item of the boss. Saved marks are now kept, the save is double-checked for every spec and any error is printed in chat.
- [Panel] The text of the Mark bar in save mode was longer than the bar and got cut off. It is now short ("Click to save") and cannot overflow, in all 11 languages.
- [Panel] The raid boss overview showed a table full of dashes when no boss had chosen items. It now explains what to do instead.
- [Panel] Items whose data was not in the local cache showed as "Item 123456" with a broken icon. The icon now always comes from the client item tables, and the name and link are requested and filled in as soon as they arrive, in every language.
- [Panel] The "all" label of a fully obtained spec showed an empty box instead of a check mark (the game font has no such character); it now uses a check icon in all 11 languages.
- [Panel] Missing icons (spec rows, the "no items" row, the roll window and the reminder) showed a red slash instead of a question mark; they now use a valid icon.
- [Theme] In the preview window the hint line overlapped the Mark bar; the window is taller now.
- [Reminder] The text of the loot spec popup (for example the chance line) was clipped by the old dialog frame. The new layout sizes everything by its real text height, so nothing is cut in any language.

---

Version: 2.2.5
2026/10/21 Released

Fork of VoidcoreAdvisor 2.4.0 by rolferik12 (MIT license, with the author's permission). Everything below is new compared to the original.

🔮 New
- [Compatibility] Works on patch 12.1.5: the removed global item functions were replaced with their `C_Item` versions. The addon lives in its own folder (`VoidcoreAdvisorReborn`); disable the original VoidcoreAdvisor first, because both use the same saved variables (Reborn warns you if both are enabled).
- [Panel] **Mark rolled item** bar to mark by hand the items you got from a Voidcore roll that the addon did not track.
- [Voidcache Scan] `/void scan [raid 14|15|16]` reads the Voidcache of every spec to mark the items you already got from the Voidcores you spent. A one-time hint tells you about it.
- [Missing] `/void missing [14|15|16]` lists every item you still need for your loot spec, best odds first.
- [Transfer] `/void export` and `/void import` copy your marked items between characters.
- [Live Raid] The loot of The Unbinding of Kith'ix (Normal, Heroic and Mythic, every class and spec) ships with the addon, outside the season fingerprint so your obtained items are never reset. `/void liveraid` reads a new raid straight from the Adventure Guide when the built-in data does not include it yet, and a chat message names raids missing from the loot data, once per raid.
- [Bonus Roll] Redesigned window: green Roll button, red Pass button, themed frame and timer bar. Optional "Are you sure?" confirmation (on by default). A red warning, a sound and an extra line appear when only 1 item is left for your spec.
- [Theme] 22 color themes: venom green (default), void purple, arcane blue, light, fire, frost, red, one for each of the 13 classes, and "Style of my class". Choose one in the options.
- [Panel] The panel can be moved (drag the header) and resized (corner grip) and remembers both. `/void resetpanel` puts it back next to the Adventure Guide.
- [Panel] `/void panel [name]` opens the Adventure Guide on a boss or dungeon with the panel showing.
- [Overview] The raid overview shows a progress bar per boss.
- [Branding] New logo and icon.

💪 Improvement
- [Bonus Roll] Shows the real Voidcore cost reported by the roll prompt.
- [Languages] All 11 languages are complete (the original left some texts in English). The newest texts were translated without a native review: corrections are welcome.
- [Commands] The command is now `/void` (also `/voidreborn`).
- [Performance] The login item-cache warmup is gentler, to avoid frame rate dips after logging in.

🛠️ Fix
- [Detection] Voidcore rolls were not tracked when the boss selected in the Adventure Guide was not the boss that dropped the item. Rolls saved by the old version are applied again when you log in.
- [Panel] The loot spec label no longer overlaps the spec column title.
