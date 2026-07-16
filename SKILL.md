---
name: codex-dream-skin-studio
description: Install, switch, customize, launch, verify, repair, update, or restore Codex Dream Skin Studio on macOS. Use for the permanent system-default entry, 20-theme multi-layout dynamic wallpaper selector, personal-image themes, safe CDP troubleshooting, or rollback while preserving the native interface.
compatibility: macOS, official Codex Desktop app, signed bundled Node.js 20 or newer
---

# Codex Dream Skin Studio

This file is an optional Codex capability entry. The delivery is a complete standalone project; users do not need to install it as a Skill.

## Workflow

1. Run `Install Codex Dream Skin.command` from the complete project folder.
2. Use the top-right theme button to select system default or any of the 20 built-ins. The permanent first card restores native Codex; built-in slot 1 is the portal theme and slot 2 is Naruto.
3. Prefer the in-page “上传图片” action. It compresses PNG/JPEG/WebP locally, extracts a palette, lets the user adjust name/layout/colors, and stores up to 12 personal themes in IndexedDB without replacing the 20 built-ins. Every saved image automatically receives a low-speed dynamic wallpaper profile. The Finder-based Customize launcher remains as a legacy/import path.
4. Verify the live result with `Verify Codex Dream Skin.command`. A pass requires the permanent system-default entry, exactly 20 built-ins with Naruto second, a ready local upload studio, a visible native sidebar and composer, no horizontal overflow, non-interactive decoration, a running wallpaper animation with measurable movement, and—on the home route—a real banner, live task cards, and project selector. In system-default mode, it instead requires all skin surfaces to be absent while the picker remains usable.
5. Restore the official appearance with `Restore Codex Dream Skin.command`.

## Guardrails

- Never modify the official `.app`, `app.asar`, or its code signature.
- Use the official Codex app's signed Node.js runtime only after validating its signature, Team ID, architecture, and minimum version.
- Bind CDP to loopback, verify that the listener belongs to Codex, and reject non-Codex renderer targets.
- Preserve all native cards, navigation, project selectors, task content, composer controls, and keyboard focus.
- Keep decorative layers at `pointer-events: none`; only the deliberate theme picker is interactive.
- Honor `prefers-reduced-motion`: wallpaper, ambient light, and particles must become static when the operating system requests reduced motion.
- Require explicit authorization before restarting an already-running Codex instance.
- Stop an injector only when its recorded PID, executable, command line, and start time all match.
- Store uploaded images only in the renderer's local IndexedDB after canvas compression; never transmit customer assets or accept SVG/remote URLs.

## Key resources

- `README.md`: user installation and customization guide.
- `scripts/injector.mjs`: CDP connection, injection, removal, verification, and screenshots.
- `assets/dream-skin.css`: live native interface styling.
- `assets/renderer-inject.js`: idempotent DOM integration and cleanup.
- `assets/themes.json`: ordered 20-theme registry; Naruto must remain second.
- `scripts/doctor-macos.sh`: signed-runtime, payload, and optional live-session self-check.
- `references/qa-inventory.md`: release and visual acceptance criteria.
