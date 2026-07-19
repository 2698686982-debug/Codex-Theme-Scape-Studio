# QA inventory

## Required user-visible behavior

1. Home route shows one independent image banner, live native heading, two to four native suggestion cards or four interactive fallback task cards, the real project selector, and native composer.
2. Normal tasks show the selected image behind restrained gradients and translucent live content surfaces.
3. Sidebar, navigation, messages, approvals, project selector, attachments, composer, menus, hover, focus, and keyboard input remain native and interactive.
4. Decorative layers have `pointer-events: none`; no screenshot or raster UI is used as an overlay.
5. Route changes, renderer reloads, and ordinary refreshes reapply the current theme while the verified injector runs.
6. Official application signature and `app.asar` remain unchanged.
7. Restore removes live DOM/CSS, restores the two saved base-theme values, closes the CDP session after restart, and supports later reinstallation.
8. A visible top-right theme trigger opens an interactive picker containing one permanent system-default entry plus exactly 20 built-in themes; the first built-in is the portal preset and the second is Naruto.
9. One click changes the banner, task background, colors, labels, status, and quote without a page reload; the selection survives route changes and renderer reloads.
10. A customer image appears as an additional custom entry and never replaces one of the 20 built-ins.
11. System default removes the skin root class, theme background, hero, extra actions, and decoration while keeping the picker available; the state survives refresh and can switch back to any theme.
12. The 20 built-ins use twelve layout families. Portal is `cinematic-banner`; Naruto is `immersive-board`; Gundam is `orbital-command`; slot 4 is `china-workbench`; slot 5 is `executive-stage`; slots 6–9 use `sitcom-cosmos`, `portal-episode`, `mystery-mansion`, and `time-machine`.
13. The picker accepts PNG/JPEG/WebP locally, compresses to WebP, extracts a palette, previews four editable colors and twelve layouts, and persists up to 12 uploaded themes in IndexedDB.
14. Deleting an uploaded theme removes its IndexedDB record and card, restores a built-in when necessary, and never changes the 20 built-ins or permanent system-default entry.
15. Every built-in and uploaded theme uses a non-video dynamic wallpaper layer on both home and task routes; animation never moves native controls or intercepts input.
16. The 20 built-ins use six layout motion profiles plus 20 unique environmental-effect profiles. Uploaded themes receive a locally selected effect based on palette/layout, and `prefers-reduced-motion: reduce` makes artwork, ambient light, particles, rain, smoke, debris, and scans static.

## Automated checks

- Shell and JavaScript syntax checks.
- Payload construction with bundled demo and an isolated custom theme.
- Reject unsupported theme config, unsafe image paths, invalid colors, oversized images, non-loopback WebSocket URLs, and unrecognized renderer targets.
- Exact install/restore round trip for the two TOML settings while preserving unrelated values.
- Empty `HOME` recovery.
- Official app and internal Node signature, Team ID, architecture, and version validation.
- Port collision selection and saved-port reuse.
- PID reuse protection through PID, start time, executable, script path, and command-line matching.
- Live verification after `Page.reload` returns version `2.10.12` and `pass: true`; verify mode does not inject after reload, so recovery must come from the persistent injector LaunchAgent. The agent hot-reloads changed theme resources, while the watchdog replaces a stale agent when the installed version changes.
- Verification requires an interactive picker trigger, the permanent system-default card, 20 built-ins, Naruto at index 2, a ready IndexedDB upload studio, a visible composer and sidebar, non-interactive decoration, and no horizontal overflow.
- Theme Studio self-test generates a local image, verifies WebP compression, four distinct extracted colors, preview, save, `editorial-split` application, running dynamic wallpaper with measurable movement, IndexedDB delete, temporary-card removal, and original-theme restoration.
- `doctor --require-live` requires both the restart watchdog and persistent injector LaunchAgent to be installed and loaded; installer/start/restore remove the deprecated repair job to prevent launchd retry loops.
- System-default verification requires `themeId: system-default`, no skin root class, no skin chrome or home decoration, and a visible interactive picker.
- Strict home verification additionally requires a visible banner of at least 320×160 and a visible project button. When the current Codex build supplies native suggestion cards, two to four must be visible; otherwise all four interactive fallback task cards must be visible.
- On Gundam at 1120px and wider, strict verification additionally requires `orbital-command`, a four-card asymmetric command deck (one tall left card, two short upper-right cards, and one wide lower-right card), shared outer edges with the project bar/composer, and 16–80px between the deck and project bar.
- Slots 6–9 each require four visible real task controls and distinct geometry: a separate four-card launch deck, an in-poster 2×2 portal selector, an asymmetric evidence board, and an in-poster vertical timeline respectively.
- On every themed task route, the independent wallpaper layer must compute to `cover`; a right-side `auto` image no longer passes. Any visible native Markdown/table sample must also resolve to a light foreground suitable for the dark full-bleed artwork.
- Dynamic verification requires the artwork layer itself to have `animation: none` and `transform: none`; it samples the independent `ds-fx-*` layer twice and requires a changed background position or timeline, `animationPlayState: running`, and `pointer-events: none` unless reduced motion is active.
- `--test-all-effects` switches all 20 built-ins without reload and requires the exact theme/effect mapping, 20 unique effect IDs, fixed artwork, a running and measurably changing independent effect layer, no pointer interception, no horizontal overflow, and restoration of the original theme.

## Visual checks

- Home at normal desktop size: banner crop is readable, text remains live, cards are not clipped, and composer does not overlap content.
- Fallback task cards: clicking each card writes the intended prompt into the real Codex contenteditable composer without submitting it; native cards hide the fallback automatically when available.
- Narrower window: quote/orbit decoration hides before covering essential controls.
- Task route: the selected artwork visibly covers the complete work area under a left-deep/right-clear mask, messages and output panels keep high contrast, and the composer remains reachable.
- Observe home and task wallpaper over time: the artwork crop remains fixed while each theme's own particles, floating light, smoke, dust, debris, rain, snow, bubbles, petals, scan lines, or energy glow animate independently; text/cards/composer remain stationary.
- Emulate or enable reduced motion: wallpaper, ambient light, and particles become static while all controls remain usable.
- Picker open: system default is the first persistent card, all 20 built-ins are reachable by scrolling, the selected card is clear, the panel stays inside the viewport, and native controls remain usable after it closes.
- Theme editor open: compressed-image dimensions and size are visible; preview, name, layout, four color controls, cancel, and save remain inside the scrollable panel at normal and narrow widths.
- Naruto: slot badge reads `02`, red/black/deep-blue styling is visible, and the user-supplied Sasuke/Sharingan/lightning crop is an independent banner/background rather than a raster UI screenshot.
- Naruto source crop contains no assistant information card, third-party ID, URL, or fake Codex controls.
- Compare portal and Naruto at the same viewport: Naruto hero is taller, Sasuke is larger, cards overlap the hero bottom, and the middle cards are raised; portal keeps the separate cinematic banner and card row.
- Selected image contains no fake interface controls or raster text intended to impersonate Codex.
- Inspect sidebar selection, header, banner edges, cards, project label, composer buttons, scrollbars, focus outlines, dialogs, and menus.

## Release signoff

- Run `tests/run-tests.sh` successfully.
- Install from a clean extracted copy with no global Node.js.
- Complete install → live verify → reload verify → restore → reinstall.
- Run `scripts/test-theme-studio-macos.sh` and require `pass: true`; confirm its temporary theme is absent afterward.
- Capture a real CDP screenshot and retain the verifier JSON.
- Confirm `codesign --verify --deep --strict` still succeeds for the official Codex app.
- Build ZIP and record SHA-256.
