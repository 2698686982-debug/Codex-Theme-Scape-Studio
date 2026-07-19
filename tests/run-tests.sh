#!/bin/bash

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
NODE="${NODE:-/Applications/ChatGPT.app/Contents/Resources/cua_node/bin/node}"
[ -x "$NODE" ] || { printf 'Codex bundled Node.js was not found: %s\n' "$NODE" >&2; exit 1; }

while IFS= read -r file; do /bin/bash -n "$file"; done < <(
  /usr/bin/find "$ROOT" -type f \( -name '*.sh' -o -name '*.command' \) \
    ! -path '*/release/*' -print
)
while IFS= read -r file; do "$NODE" --check "$file" >/dev/null; done < <(
  /usr/bin/find "$ROOT/scripts" "$ROOT/assets" -type f \( -name '*.mjs' -o -name '*.js' \) -print
)

if /usr/bin/grep -R -n -E 'dream-skin-skin|DREAM_SKIN_SKIN|1\.0\.0-rc2' \
  "$ROOT/scripts" "$ROOT/assets" >/dev/null; then
  printf 'Legacy release-candidate identifiers remain in runtime files.\n' >&2
  exit 1
fi
if /usr/bin/grep -R -n -E '(writeFile|rename|copyFile|rm).*app\.asar' "$ROOT/scripts" >/dev/null; then
  printf 'A runtime script appears to mutate app.asar.\n' >&2
  exit 1
fi

"$NODE" "$ROOT/scripts/injector.mjs" --check-payload >/dev/null
"$NODE" -e '
  const fs = require("node:fs");
  const registry = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
  const allowed = new Set(["cinematic-banner", "immersive-board", "terminal-grid", "orbital-command", "china-workbench", "executive-stage", "sitcom-cosmos", "portal-episode", "mystery-mansion", "time-machine", "editorial-split", "minimal-focus"]);
  const variants = new Set(registry.themes.map(theme => theme.layoutVariant));
  const effects = new Set(registry.themes.map(theme => theme.effect));
  if (registry.themes.length !== 20 || registry.themes[1]?.id !== "naruto" ||
      registry.themes[2]?.id !== "gundam-orbital" ||
      registry.themes[2]?.image !== "mecha-orbital-hero.png" ||
      registry.themes[3]?.image !== "china-red-gold-hero-v2.png" ||
      registry.themes[1]?.layoutVariant !== "immersive-board" ||
      registry.themes[2]?.layoutVariant !== "orbital-command" ||
      registry.themes[3]?.id !== "china-red-gold" || registry.themes[3]?.layoutVariant !== "china-workbench" ||
      registry.themes[4]?.id !== "ai-executive-forum" || registry.themes[4]?.layoutVariant !== "executive-stage" ||
      registry.themes[5]?.id !== "family-cosmic" || registry.themes[5]?.layoutVariant !== "sitcom-cosmos" || registry.themes[5]?.effect !== "family-cosmic-drift" ||
      registry.themes[6]?.id !== "family-multiverse" || registry.themes[6]?.layoutVariant !== "portal-episode" || registry.themes[6]?.effect !== "family-portals" ||
      registry.themes[7]?.id !== "family-mystery" || registry.themes[7]?.layoutVariant !== "mystery-mansion" || registry.themes[7]?.effect !== "family-storm" ||
      registry.themes[8]?.id !== "family-time-travel" || registry.themes[8]?.layoutVariant !== "time-machine" || registry.themes[8]?.effect !== "family-timewarp" ||
      variants.size !== 12 || effects.size !== 20 ||
      registry.themes.some(theme => typeof theme.effect !== "string" || !theme.effect) ||
      registry.themes.some(theme => !allowed.has(theme.layoutVariant))) process.exit(1);
' "$ROOT/assets/themes.json"
if ! /usr/bin/grep -q 'SYSTEM_DEFAULT_ID = "system-default"' "$ROOT/assets/renderer-inject.js"; then
  printf 'The permanent system-default theme entry is missing.\n' >&2
  exit 1
fi
for marker in \
  'UPLOAD_DB_NAME = "codex-dream-skin-studio"' \
  'prepareUploadedImage' \
  'extractPalette' \
  'saveUploadedThemeRecord' \
  'deleteUploadedThemeRecord' \
  'motionProfileForTheme' \
  'effectProfileForTheme' \
  'class="dream-skin-hero-art"' \
  'class="dream-skin-hero-fx"' \
  'class="dream-skin-viewport-fx"' \
  'class="dream-skin-upload-input"' \
  'uploadStorage: "indexedDB"'; do
  if ! /usr/bin/grep -q "$marker" "$ROOT/assets/renderer-inject.js"; then
    printf 'The in-page theme studio is incomplete: missing %s.\n' "$marker" >&2
    exit 1
  fi
done
if /usr/bin/grep -E -n 'https?://' "$ROOT/assets/renderer-inject.js" >/dev/null; then
  printf 'The renderer theme studio must not transmit customer images to remote endpoints.\n' >&2
  exit 1
fi
if ! /usr/bin/grep -q 'install_watchdog_agent' "$ROOT/scripts/start-dream-skin-macos.sh" ||
   ! /usr/bin/grep -q 'disable_watchdog_agent' "$ROOT/scripts/restore-dream-skin-macos.sh"; then
  printf 'The restart watchdog install/restore lifecycle is incomplete.\n' >&2
  exit 1
fi
if ! /usr/bin/grep -q 'payloadFingerprint' "$ROOT/scripts/injector.mjs" ||
   ! /usr/bin/grep -q 'detected Dream Skin version change' "$ROOT/scripts/watchdog-dream-skin-macos.sh"; then
  printf 'Live payload/version refresh recovery is incomplete.\n' >&2
  exit 1
fi
if ! /usr/bin/grep -q -- '--test-home-composer' "$ROOT/scripts/injector.mjs" ||
   ! /usr/bin/grep -q 'projectToComposerGap >= 14' "$ROOT/scripts/injector.mjs" ||
   ! /usr/bin/grep -q 'cardsToProjectGap >= 24' "$ROOT/scripts/injector.mjs"; then
  printf 'The live home composer regression guard is missing.\n' >&2
  exit 1
fi
if ! /usr/bin/grep -q 'INJECTOR_PLIST=' "$ROOT/scripts/common-macos.sh" ||
   ! /usr/bin/grep -q 'disable_injector_agent' "$ROOT/scripts/restore-dream-skin-macos.sh" ||
   /usr/bin/grep -q 'launchctl submit -l "$INJECTOR_JOB_LABEL"' "$ROOT/scripts/common-macos.sh"; then
  printf 'The persistent injector LaunchAgent lifecycle is incomplete.\n' >&2
  exit 1
fi
for script in install-dream-skin-macos.sh start-dream-skin-macos.sh restore-dream-skin-macos.sh; do
  /usr/bin/grep -q 'disable_legacy_repair_job' "$ROOT/scripts/$script" || {
    printf 'Legacy repair-loop cleanup is missing from %s.\n' "$script" >&2
    exit 1
  }
done
[ -x "$ROOT/scripts/watchdog-dream-skin-macos.sh" ] || /bin/chmod 755 "$ROOT/scripts/watchdog-dream-skin-macos.sh"

TMP="$(/usr/bin/mktemp -d /tmp/codex-dream-skin-tests.XXXXXX)"
trap '/bin/rm -rf "$TMP"' EXIT
/bin/mkdir -p "$TMP/theme"
/bin/cp "$ROOT/assets/portal-hero.png" "$TMP/theme/background.png"
"$NODE" "$ROOT/scripts/write-theme.mjs" custom --output-dir "$TMP/theme" \
  --image background.png --name '测试主题' --tagline '测试口号' --quote 'TEST' \
  --accent '#11aa55' --secondary '#22bbcc' --highlight '#663399' >/dev/null
PAYLOAD_JSON="$("$NODE" "$ROOT/scripts/injector.mjs" --check-payload --theme-dir "$TMP/theme")"
"$NODE" -e '
  const value = JSON.parse(process.argv[1]);
  if (!value.pass || value.themeName !== "测试主题" || value.imageBytes < 1 ||
      value.builtinThemeCount !== 20 || value.secondThemeId !== "naruto") process.exit(1);
' "$PAYLOAD_JSON"
"$NODE" "$ROOT/scripts/write-theme.mjs" reset-demo --output-dir "$TMP/theme" >/dev/null
[ ! -e "$TMP/theme" ]

CONFIG="$TMP/config.toml"
BACKUP="$TMP/theme-backup.json"
/usr/bin/printf '%s\n' \
  'model = "gpt-5"' \
  '' \
  '[desktop]' \
  'appearanceTheme = "system"' \
  'appearanceDarkCodeThemeId = "vscode-dark"' \
  'keepMe = true' > "$CONFIG"
/bin/cp "$CONFIG" "$TMP/original.toml"
"$NODE" "$ROOT/scripts/theme-config.mjs" install "$CONFIG" "$BACKUP" >/dev/null
/usr/bin/grep -q 'appearanceTheme = "dark"' "$CONFIG"
"$NODE" "$ROOT/scripts/theme-config.mjs" restore "$CONFIG" "$BACKUP" >/dev/null
/usr/bin/cmp -s "$CONFIG" "$TMP/original.toml"

/usr/bin/grep -q '@media (prefers-reduced-motion: reduce)' "$ROOT/assets/dream-skin.css"
/usr/bin/grep -q '@keyframes ds-fx-field' "$ROOT/assets/dream-skin.css"
/usr/bin/grep -q '@keyframes ds-fx-orbit' "$ROOT/assets/dream-skin.css"
/usr/bin/grep -q '@keyframes ds-fx-matrix-rain' "$ROOT/assets/dream-skin.css"
/usr/bin/grep -q '@keyframes ds-particle-confetti' "$ROOT/assets/dream-skin.css"
/usr/bin/grep -q 'animation: var(--ds-particle-motion' "$ROOT/assets/dream-skin.css"
/usr/bin/grep -q 'animation: none;' "$ROOT/assets/dream-skin.css"
/usr/bin/grep -q 'data-thread-find-target="conversation"' "$ROOT/assets/dream-skin.css"
/usr/bin/grep -q 'data-pip-obstacle="thread-summary-panel"' "$ROOT/assets/dream-skin.css"
/usr/bin/grep -q 'data-thread-scroll-footer' "$ROOT/assets/dream-skin.css"
/usr/bin/grep -q 'content: "☭"' "$ROOT/assets/dream-skin.css"
/usr/bin/grep -q 'content: "一颗红心向祖国，一片赤诚为人民"' "$ROOT/assets/dream-skin.css"
/usr/bin/grep -q 'main.main-surface:not(.dream-skin-home-shell)::after' "$ROOT/assets/dream-skin.css"
/usr/bin/grep -q 'color: rgba(143, 21, 26, .28)' "$ROOT/assets/dream-skin.css"
/usr/bin/grep -q 'partyBadgeCount === 4' "$ROOT/scripts/injector.mjs"
/usr/bin/grep -Fq 'div[class~="z-0"][class~="absolute"][class~="top-full"]:has([class~="group/project-selector"])' "$ROOT/assets/dream-skin.css"
/usr/bin/env -u HOME /bin/bash -c '. "$1/scripts/common-macos.sh"; [ -n "$HOME" ] && [ "$SKIN_VERSION" = "2.10.12" ]' _ "$ROOT"
"$ROOT/scripts/doctor-macos.sh" >/dev/null

printf 'PASS: syntax, payload, in-page studio markers, custom-theme round-trip, config recovery, persistent-agent lifecycle, signature, and doctor checks.\n'
