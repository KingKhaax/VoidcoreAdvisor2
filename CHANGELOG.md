# Changelog

## 2.3.0
- New **Preview** button next to the color theme selector in the options (also `/void preview`): a sample window that recolors live while you change the theme, with a counting-down timer bar.
- The timer bar of the bonus roll window shows the time left (for example 2:34) in its center.
- **Mark rolled item** now works in two steps: press the bar, click the items you got (they dim right away, nothing is saved yet), then press the bar again to save them. Closing the panel or changing boss discards unsaved marks. Shift+click still stages everything between two clicks. The save bar text is now short ("Click to save") so it always fits, and saving is double-checked so the marks are stored for every spec. Items you save this way are never wiped by the automatic pool reset (it used to clear the whole boss when a spec had all its items marked).
- The preview window has < > buttons to look at other themes without changing yours.
- New **Bonus roll window theme** selector in the options: the bonus roll window has its own color theme (default: your class).
- The loot spec reminder popup now also appears in front of raid bosses: target a current-season raid boss before the pull and you get it once per boss. It has its own option (on by default) and boss wording in the warning.
- New **Reminder popup theme** selector in the options (default: your class), and the reminder popups show a gold "Reborn" next to the title. Both popups now use the flat themed look of the sample windows (gold corners, bigger spec rows, progress bars, no clipped text).
- Every theme row in the options now has its own **Preview** button: the color theme opens the sample window, the bonus roll theme opens the roll window preview and the reminder theme opens the example popup.
- New `/void open` command: opens the addon options page (themes and previews) directly.
- Removed the "Style of my specialization" theme. "Style of my class" stays; anyone who had the specialization theme selected is moved to it.

## 2.2.5
Fork of VoidcoreAdvisor 2.4.0 by rolferik12 (MIT license, with the author's permission). Everything below is new compared to the original.

Compatibility
- Works on patch 12.1.5: the removed global item functions were replaced with their `C_Item` versions.
- The addon lives in its own folder (`VoidcoreAdvisorReborn`). Disable or remove the original VoidcoreAdvisor first: both use the same saved variables, and Reborn warns you if the original is also enabled.

Loot tracking
- Fixed Voidcore rolls not being tracked when the boss selected in the Adventure Guide was not the boss that dropped the item. Rolls saved by the old version are applied again when you log in.
- New **Mark rolled item** bar to mark by hand the items you got from a Voidcore roll that the addon did not track.
- `/void scan [raid 14|15|16]` reads the Voidcache of every spec to mark the items you already got from the Voidcores you spent. A one-time hint tells you about it.
- `/void missing [14|15|16]` lists every item you still need for your loot spec, best odds first.
- `/void export` and `/void import` copy your marked items between characters.

New raid
- The loot of The Unbinding of Kith'ix (Normal, Heroic and Mythic, every class and spec) ships with the addon, outside the season fingerprint so your obtained items are never reset.
- `/void liveraid` reads a new raid straight from the Adventure Guide when the built-in data does not include it yet. A chat message names raids missing from the loot data, once per raid.

Bonus roll window
- Redesigned: green Roll button, red Pass button, themed frame and timer bar.
- Optional "Are you sure?" confirmation before rolling or passing (on by default). The window is enabled by default.
- A red warning, a sound and an extra line in the confirmation appear when only 1 item is left for your spec.
- Shows the real Voidcore cost reported by the roll prompt.

Panel and looks
- 22 color themes: venom green (default), void purple, arcane blue, light, fire, frost, red, one for each of the 13 classes, and "Style of my class", which follows the character you are playing. Choose one in the options or with `/void theme <name>`.
- The panel can be moved (drag the header) and resized (corner grip), and remembers both. `/void resetpanel` puts it back next to the Adventure Guide.
- The raid overview shows a progress bar per boss. The loot spec label no longer overlaps the spec column title.
- `/void panel [name]` opens the Adventure Guide on a boss or dungeon with the panel showing.
- New logo and icon.

Languages
- All 11 languages are complete (the original left some texts in English). The newest texts were translated without a native review: corrections are welcome.

Commands and performance
- The command is now `/void` (also `/voidreborn`).
- The login item-cache warmup is gentler, to avoid frame rate dips after logging in.
