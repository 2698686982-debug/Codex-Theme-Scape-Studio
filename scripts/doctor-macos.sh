#!/bin/bash

set -euo pipefail
. "$(cd "$(dirname "$0")" && pwd -P)/common-macos.sh"

REQUIRE_LIVE="false"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --require-live) REQUIRE_LIVE="true"; shift ;;
    *) fail "Unknown doctor argument: $1" ;;
  esac
done

discover_codex_app
require_macos_runtime
[ -f "$CONFIG_PATH" ] || fail "Codex config not found: $CONFIG_PATH"
for required in \
  "$PROJECT_ROOT/assets/dream-skin.css" \
  "$PROJECT_ROOT/assets/renderer-inject.js" \
  "$PROJECT_ROOT/assets/theme.json" \
  "$PROJECT_ROOT/assets/themes.json" \
  "$PROJECT_ROOT/scripts/injector.mjs" \
  "$PROJECT_ROOT/scripts/watchdog-dream-skin-macos.sh"; do
  [ -s "$required" ] || fail "Required project file is missing or empty: $required"
done

PAYLOAD_JSON="$("$NODE" "$INJECTOR" --check-payload --theme-dir "$THEME_DIR")"
PORT=9341
if [ -f "$STATE_PATH" ]; then
  PORT="$(state_field port)"
fi
LIVE="false"
LIVE_JSON="{}"
WATCHDOG_INSTALLED="false"
WATCHDOG_LOADED="false"
INJECTOR_AGENT_INSTALLED="false"
INJECTOR_AGENT_LOADED="false"
[ -f "$WATCHDOG_PLIST" ] && WATCHDOG_INSTALLED="true"
/bin/launchctl print "gui/$(/usr/bin/id -u)/$WATCHDOG_JOB_LABEL" >/dev/null 2>&1 && WATCHDOG_LOADED="true"
[ -f "$INJECTOR_PLIST" ] && INJECTOR_AGENT_INSTALLED="true"
/bin/launchctl print "gui/$(/usr/bin/id -u)/$INJECTOR_JOB_LABEL" >/dev/null 2>&1 && INJECTOR_AGENT_LOADED="true"
if [ -f "$STATE_PATH" ] && verified_cdp_endpoint "$PORT"; then
  if LIVE_JSON="$("$NODE" "$INJECTOR" --verify --port "$PORT" --theme-dir "$THEME_DIR" --timeout-ms 12000)"; then
    LIVE="true"
  fi
fi
[ "$REQUIRE_LIVE" = "false" ] || [ "$LIVE" = "true" ] || fail "No verified live Dream Skin session is active."
[ "$REQUIRE_LIVE" = "false" ] || { [ "$WATCHDOG_INSTALLED" = "true" ] && [ "$WATCHDOG_LOADED" = "true" ]; } \
  || fail "The restart watchdog is not installed and loaded."
[ "$REQUIRE_LIVE" = "false" ] || { [ "$INJECTOR_AGENT_INSTALLED" = "true" ] && [ "$INJECTOR_AGENT_LOADED" = "true" ]; } \
  || fail "The persistent injector LaunchAgent is not installed and loaded."

"$NODE" -e '
  const payload = JSON.parse(process.argv[1]);
  const liveResult = JSON.parse(process.argv[9] || "{}").targets?.[0]?.result || null;
  const result = {
    pass: true,
    product: "Codex Dream Skin Studio",
    version: process.argv[2],
    platform: `darwin-${process.argv[3]}`,
    codexVersion: process.argv[4],
    codexTeamId: process.argv[5],
    nodeVersion: process.argv[6],
    officialAppSignatureValid: true,
    modifiesAppAsar: false,
    live: process.argv[7] === "true",
    port: Number(process.argv[8]),
    restartWatchdog: {
      installed: process.argv[10] === "true",
      loaded: process.argv[11] === "true",
    },
    persistentInjector: {
      installed: process.argv[12] === "true",
      loaded: process.argv[13] === "true",
    },
    theme: {
      id: liveResult?.themeId || payload.themeId,
      name: liveResult?.themeName || payload.themeName,
      builtinThemeCount: payload.builtinThemeCount,
      secondThemeId: payload.secondThemeId,
      imageBytes: payload.imageBytes,
      payloadBytes: payload.payloadBytes,
    },
  };
  console.log(JSON.stringify(result, null, 2));
' "$PAYLOAD_JSON" "$SKIN_VERSION" "$(/usr/bin/uname -m)" "$CODEX_VERSION" "$CODEX_TEAM_ID" "$NODE_VERSION" "$LIVE" "$PORT" "$LIVE_JSON" "$WATCHDOG_INSTALLED" "$WATCHDOG_LOADED" "$INJECTOR_AGENT_INSTALLED" "$INJECTOR_AGENT_LOADED"
