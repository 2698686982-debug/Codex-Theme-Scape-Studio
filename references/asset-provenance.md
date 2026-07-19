# Asset provenance

## Built-in theme registry

- File: `assets/themes.json`
- Count: 20 ordered presets; slot 1 is the portal fan theme and slot 2 is the Naruto fan theme.
- Art method: slot 1 uses the generated bitmap documented below. Slot 2 uses the user-supplied Naruto master crop documented below. Slot 3 uses the user-approved classic mecha master crop documented below. Slot 4 uses the generated red-gold hero documented below. Slot 5 uses the user-supplied executive roundtable image documented below. Slots 6–9 use four generated Family Guy fan-theme posters documented below. Slots 10–20 use original lightweight SVG scenes generated locally by `scripts/injector.mjs` from color, symbol, and motif metadata.
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

## Red-gold China technology artwork

- File: `assets/china-red-gold-hero-v2.png`
- SHA-256: `a9dcea47568ffcfc65580e54e169714d8d71934a63350ae74dd82cb0e375c64d`
- Created: 2026-07-19 with OpenAI's built-in image generation tool for this project, using the prior generated red-gold city composition as a visual reference.
- Included content: warm ivory Shanghai-inspired skyline, Chinese civic architecture, high-speed rail, red silk energy, gold data light, a correctly constructed five-star Chinese national flag, and conceptual editorial portraits ordered left-to-right as Sam Altman, Elon Musk, Donald Trump, Jensen Huang, and Dario Amodei. Donald Trump occupies the visual center, is slightly larger, and stands slightly forward of the other four figures.
- Excluded content: text, logos, buttons, sidebar, cards, progress panel and all fake interface chrome.
- Purpose: independent hero/task wallpaper for built-in slot 4. All Codex controls remain live DOM.
- Rights note: Generated artwork does not grant likeness, publicity, personality, trademark, political-advertising, image, or commercial redistribution rights. The composition is an unofficial conceptual editorial visual; it does not represent support, collaboration, approval, quotation, or endorsement by the depicted people, their companies, OpenAI, Anthropic, NVIDIA, xAI, Tesla, any government, or any public institution. Confirm all required rights or replace the artwork before public or commercial distribution.

### Generation brief

```text
Create a 2048×768 ultra-wide red-and-gold conceptual editorial hero for a live Codex desktop theme. Keep the left roughly 45% calm and bright for native HTML title copy. On the right, arrange recognizable conceptual portraits left-to-right as Sam Altman, Elon Musk, Donald Trump, Jensen Huang, and Dario Amodei; place Donald Trump in the exact visual center, slightly larger and slightly forward. Include a correctly constructed five-star Chinese flag, Shanghai skyline, Chinese civic architecture, high-speed rail, red silk and gold circuit light. Produce artwork only: no text, logo, UI, buttons or watermark. This is an unofficial conceptual editorial composition and must not imply endorsement or real collaboration.
```

## AI executive roundtable artwork

- File: `assets/executive-ai-roundtable.png`
- Source: user-supplied visual master `445745b46c58d91106606e806009c038.png`.
- SHA-256: `054e5d76806dc523f52647688fafb883b5d2e8e3718ad95e1a150d4aa8db04e0`
- Purpose: independent hero/task wallpaper for built-in slot 5. All task cards, project controls, composer and theme switcher remain live DOM.
- Rights note: The image appears to depict recognizable public figures. Inclusion in the software does not grant copyright, publicity, personality, trademark, endorsement or commercial redistribution rights. The distributor must obtain permission or replace the image before public or commercial distribution.

## Family episode fan-theme artwork

The following four image-only ultra-wide posters were created on 2026-07-18 with OpenAI's built-in image generation tool for this project. They contain no interface controls, text, logos or watermark and are used only as fixed home/task wallpaper behind live Codex DOM.

- `assets/family-cosmic-hero.png` — 2060×763 — SHA-256 `eff2c3574d16c734bf714c2c4f245437a200afc1b01d2d39035701dbb633f5e8` — space-adventure ensemble with calm left-side copy area.
- `assets/family-multiverse-hero.png` — 2061×763 — SHA-256 `5ed7060ed7fba040a9d9f50a0ec71cded3aa2327e609b51e53cef19cc3ff57ff` — multiple stylized portal worlds with calm left-side copy area.
- `assets/family-mystery-hero.png` — 2060×763 — SHA-256 `8afedab2447108dcb6735b962028fb242e9ab76565fdd0b0ffc8b91c4549a5e2` — stormy manor dinner mystery.
- `assets/family-time-hero.png` — 2061×763 — SHA-256 `fe51bcc9d83248aa002ee3975aaa8980a4dfb6da0ce24edab03e8df5b6caa3f7` — time machine and three era portals with calm left-side copy area.

Rights note: These are recognizable unofficial fan-theme depictions of third-party characters. Image generation and inclusion in the repository do not grant copyright, character, trademark, merchandising, publicity or commercial redistribution rights. Replace them with original or properly licensed artwork before commercial distribution, and retain an unofficial-project disclaimer for any public fan release.
