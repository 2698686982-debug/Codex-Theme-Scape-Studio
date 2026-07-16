#!/bin/bash

set -euo pipefail
. "$(cd "$(dirname "$0")" && pwd -P)/common-macos.sh"

PORT=9341
SCREENSHOT=""
RESULT_PATH="$STATE_ROOT/restart-regression.json"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --port) PORT="${2:-}"; shift 2 ;;
    --screenshot) SCREENSHOT="${2:-}"; shift 2 ;;
    --result) RESULT_PATH="${2:-}"; shift 2 ;;
    *) fail "Unknown restart-regression argument: $1" ;;
  esac
done
case "$PORT" in ''|*[!0-9]*) fail "Invalid restart-regression port: $PORT" ;; esac
[ -n "$SCREENSHOT" ] || fail "restart-regression requires an absolute --screenshot path."
case "$SCREENSHOT" in /*) ;; *) fail "restart-regression screenshot path must be absolute." ;; esac
case "$RESULT_PATH" in /*) ;; *) fail "restart-regression result path must be absolute." ;; esac

discover_codex_app
require_macos_runtime
ensure_state_root
disable_legacy_repair_job

STEP="initial verification"
write_failure_result() {
  local code="$1"
  local message="Restart regression failed during $STEP (exit $code)."
  /bin/mkdir -p "$(dirname "$RESULT_PATH")"
  "$NODE" -e '
    const fs = require("node:fs");
    const [file, message, step, code] = process.argv.slice(1);
    fs.writeFileSync(file, `${JSON.stringify({ pass: false, message, step, exitCode: Number(code), finishedAt: new Date().toISOString() }, null, 2)}\n`);
  ' "$RESULT_PATH" "$message" "$STEP" "$code" || true
}
trap 'code=$?; write_failure_result "$code"' EXIT

verified_cdp_endpoint "$PORT" || fail "Port $PORT is not a verified Codex loopback CDP endpoint before restart."
BEFORE_JSON="$("$NODE" "$INJECTOR" --verify --port "$PORT" --theme-dir "$THEME_DIR" --timeout-ms 30000)"
BEFORE_THEME="$("$NODE" -e '
  const value = JSON.parse(process.argv[1]).targets?.[0]?.result;
  if (!value?.pass || !value.themeId) process.exit(2);
  process.stdout.write(value.themeId);
' "$BEFORE_JSON")"
OLD_PID="$(codex_main_pids | /usr/bin/head -n 1)"
case "$OLD_PID" in ''|*[!0-9]*) fail "Could not identify the running Codex PID before restart." ;; esac

STEP="authorized Codex quit"
/usr/bin/osascript -e 'tell application id "com.openai.codex" to quit' >/dev/null

STEP="waiting for old Codex PID to exit"
deadline=$((SECONDS + 75))
while /bin/kill -0 "$OLD_PID" 2>/dev/null && [ "$SECONDS" -lt "$deadline" ]; do /bin/sleep 0.25; done
/bin/kill -0 "$OLD_PID" 2>/dev/null && fail "Old Codex PID $OLD_PID did not exit within 75 seconds."

STEP="waiting for launchd Codex restart"
NEW_PID=""
deadline=$((SECONDS + 75))
while [ "$SECONDS" -lt "$deadline" ]; do
  NEW_PID="$(codex_main_pids | /usr/bin/head -n 1)"
  if [ -n "$NEW_PID" ] && [ "$NEW_PID" != "$OLD_PID" ]; then break; fi
  /bin/sleep 0.4
done
case "$NEW_PID" in ''|*[!0-9]*) fail "Codex did not restart automatically within 75 seconds." ;; esac
[ "$NEW_PID" != "$OLD_PID" ] || fail "Codex PID did not change after restart."

STEP="waiting for verified CDP after restart"
wait_for_cdp "$PORT" || fail "Restarted Codex did not restore the verified loopback CDP endpoint."

STEP="verifying automatic theme reinjection"
/bin/mkdir -p "$(dirname "$SCREENSHOT")"
AFTER_JSON="$("$NODE" "$INJECTOR" --verify --port "$PORT" --theme-dir "$THEME_DIR" --timeout-ms 30000 --open-theme-picker --screenshot "$SCREENSHOT")"
"$NODE" -e '
  const value = JSON.parse(process.argv[1]).targets?.[0]?.result;
  if (!value?.pass || value.version !== process.argv[2] || value.themeId !== process.argv[3] ||
      !value.pickerPresent || !value.uploadEnabled || !value.uploadsReady ||
      value.builtinThemeCount !== 20 || value.secondThemeId !== "naruto") process.exit(2);
' "$AFTER_JSON" "$SKIN_VERSION" "$BEFORE_THEME"

STEP="refreshing saved process identity"
"$SCRIPT_DIR/start-dream-skin-macos.sh" --port "$PORT" >/dev/null

STEP="post-restart doctor"
DOCTOR_JSON="$("$SCRIPT_DIR/doctor-macos.sh" --require-live)"

STEP="post-restart Theme Studio self-test"
STUDIO_JSON="$("$SCRIPT_DIR/test-theme-studio-macos.sh" --port "$PORT")"

STEP="writing restart regression result"
/bin/mkdir -p "$(dirname "$RESULT_PATH")"
"$NODE" -e '
  const fs = require("node:fs");
  const [file, beforeJson, afterJson, doctorJson, studioJson, oldPid, newPid, screenshot] = process.argv.slice(1);
  const before = JSON.parse(beforeJson).targets?.[0]?.result;
  const after = JSON.parse(afterJson).targets?.[0]?.result;
  const doctor = JSON.parse(doctorJson);
  const studio = JSON.parse(studioJson).targets?.[0]?.result;
  const result = {
    pass: Boolean(before?.pass && after?.pass && doctor?.pass && doctor?.live && studio?.pass && Number(oldPid) !== Number(newPid)),
    version: after?.version,
    oldPid: Number(oldPid),
    newPid: Number(newPid),
    themeBefore: before?.themeId,
    themeAfter: after?.themeId,
    pickerPresent: after?.pickerPresent,
    uploadEnabled: after?.uploadEnabled,
    uploadsReady: after?.uploadsReady,
    builtinThemeCount: after?.builtinThemeCount,
    secondThemeId: after?.secondThemeId,
    doctorLive: doctor?.live,
    restartWatchdog: doctor?.restartWatchdog,
    persistentInjector: doctor?.persistentInjector,
    themeStudioPass: studio?.pass,
    screenshot,
    finishedAt: new Date().toISOString(),
  };
  fs.writeFileSync(file, `${JSON.stringify(result, null, 2)}\n`, { mode: 0o600 });
  if (!result.pass) process.exit(2);
' "$RESULT_PATH" "$BEFORE_JSON" "$AFTER_JSON" "$DOCTOR_JSON" "$STUDIO_JSON" "$OLD_PID" "$NEW_PID" "$SCREENSHOT"

trap - EXIT
printf 'PASS: Codex PID changed from %s to %s and Dream Skin %s recovered automatically.\n' "$OLD_PID" "$NEW_PID" "$SKIN_VERSION"
