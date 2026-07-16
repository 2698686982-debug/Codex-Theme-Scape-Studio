# Asset provenance

## Built-in theme registry

- File: `assets/themes.json`
- Count: 20 ordered presets; slot 1 is the portal fan theme and slot 2 is the Naruto fan theme.
- Art method: slot 1 uses the generated bitmap documented below. Slot 2 uses the user-supplied Naruto master crop documented below. Slot 3 uses the user-approved classic mecha master crop documented below. Slots 4–20 use original lightweight SVG scenes generated locally by `scripts/injector.mjs` from color, symbol, and motif metadata.
- Rights note: theme names that reference third-party franchises are unofficial fan labels. Software licensing does not grant franchise, character, trademark, or commercial merchandising rights. Replace or license those labels/assets as appropriate before commercial redistribution.

## Portal hero bitmap

- File: `assets/portal-hero.png`
- SHA-256: `e062694d6b9f42a400b5b8a5735fd348e19dd84ae05e6f363f65e7026f719fa9`
- Created: 2026-07-15 with OpenAI's built-in image generation tool for this project.
- Purpose: Use only as the cropped top hero; do not treat it as a UI screenshot or interactive layer.
- Rights note: This is recognizable fan-theme artwork. Confirm the necessary character, publicity, trademark, and redistribution rights before commercial publication or third-party distribution.

## Generation prompt

```text
Use case: stylized-concept
Asset type: wide hero banner for the native macOS Codex desktop home screen, designed to crop cleanly near a 3:1 aspect ratio
Primary request: create an original polished adult-animation-inspired sci-fi illustration featuring an eccentric spiky blue-haired elderly scientist in a white lab coat and his anxious teenage companion emerging from a luminous green dimensional portal inside a chaotic garage laboratory; preserve only the reference image's overall wide hero composition and UI-friendly negative-space strategy, not its subject, colors, text, people, branding, or decorative elements
Scene/backdrop: dark interdimensional garage laboratory with stars, planets, cables, strange gadgets, glass flasks and subtle portal energy trails
Subject: the two characters and the dimensional portal grouped mainly on the right and center-right; expressive adventurous poses; no cropped faces
Style/medium: premium clean 2D animation illustration, crisp silhouettes, cinematic depth, original artwork
Composition/framing: ultra-wide cinematic banner; reserve the left 40 percent as relatively calm dark purple and navy negative space for live HTML heading and subtitle; visual focus on the right; important details remain safe within a wide crop
Lighting/mood: acid green portal glow with cyan rim light, cosmic purple accents, energetic and mischievous but readable behind foreground UI
Color palette: deep navy #071116, portal green #7CFF46, acid lime #B8FF3D, cyan #36D7E8, cosmic purple #642A8C
Constraints: image only; no text, no letters, no numbers, no logos, no watermark, no UI controls, no navigation, no cards, no buttons, no input box, no screenshot frame; do not reproduce the woman or pink celebrity theme from the reference
Avoid: busy high-contrast details in the left negative-space area, fake interface elements, illegible pseudo-text, excessive gore, photorealism
```

## Naruto Sasuke artwork

- File: `assets/naruto-sasuke-clean.png`
- Source: user-supplied visual master `0d7e4510f156740626960907c26aa0a0.png`.
- Source crop: the original `1018×556` Sasuke artwork region was cropped again to its left `620×556` pixels without resampling.
- SHA-256: `8214921add00e2f6eabd529aec1258194d1471375958975ea5707909a27d4b81`
- Included content: Sasuke, Sharingan motifs, red atmosphere, blue lightning, and crows.
- Removed content: the entire “宇智波佐助 AI 助手” information module, third-party ID, URL, quote card, and all fake interface text.
- Purpose: independent hero/task wallpaper only. Native Codex sidebar, cards, project selector, task content, and composer remain live DOM.
- Rights note: This is recognizable third-party fan artwork. The customer must confirm the necessary character, copyright, trademark, and redistribution rights before commercial publication or third-party distribution.

## Classic mecha orbital artwork

- File: `assets/mecha-orbital-hero.png`
- Source: user-supplied visual master `5b97310a8762a56d72955f660e602055.png`.
- Source crop: the original `2400×1600` visual was cropped without resampling to a `1000×1100` right-side artwork region at approximately `x=1400`, `y=120`.
- SHA-256: `5f516f5e4f3296196076128cb70a109d464475c756e6421502b6290fe0640f00`
- Included content: the classic blue-white-red-gold full-body mecha, orbital hangar, shield, blue energy, reflective runway, and the small `SCAN READY` artwork motif.
- Removed content: the `WORKBUDDY` brand block, left navigation, hero marketing copy, call-to-action, bottom feature cards, and most of the source's fake interface chrome.
- Purpose: independent hero/task wallpaper for built-in slot 3. Native Codex sidebar, cards, project selector, task content, composer, and theme switcher remain live DOM.
- Rights note: This is recognizable user-supplied franchise fan artwork. Inclusion in the project does not grant copyright, character, trademark, or commercial redistribution rights; the customer must license or replace it before commercial distribution.
