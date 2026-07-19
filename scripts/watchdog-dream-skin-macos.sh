#!/bin/bash

set -euo pipefail
. "$(cd "$(dirname "$0")" && pwd -P)/common-macos.sh"

PORT=9341
while [ "$#" -gt 0 ]; do
  case "$1" in
    --port) PORT="${2:-}"; shift 2 ;;
    *) fail "Unknown watchdog argument: $1" ;;
  esac
done
case "$PORT" in ''|*[!0-9]*) fail "Invalid watchdog port: $PORT" ;; esac
[ "$PORT" -ge 1024 ] && [ "$PORT" -le 65535 ] || fail "Watchdog port must be between 1024 and 65535."

export CODEX_DREAM_SKIN_WATCHDOG=1
discover_codex_app
require_macos_runtime
ensure_state_root

last_pid=""
unwrapped_checks=0
printf '%s watchdog active for Codex %s\n' "$(/bin/date -u '+%Y-%m-%dT%H:%M:%SZ')" "$CODEX_VERSION"

while true; do
  if [ -f "$STATE_PATH" ]; then
    saved_port="$(state_field port 2>/dev/null || true)"
    case "$saved_port" in ''|*[!0-9]*) ;; *) PORT="$saved_port" ;; esac
  fi

  codex_pid="$(codex_main_pids | /usr/bin/head -n 1)"
  if [ -z "$codex_pid" ]; then
    last_pid=""
    unwrapped_checks=0
    if recorded_injector_is_running; then
      stop_recorded_injector || true
      /bin/rm -f "$STATE_PATH"
    elif [ -f "$STATE_PATH" ]; then
      saved_pid="$(state_field injectorPid 2>/dev/null || true)"
      case "$saved_pid" in
        ''|*[!0-9]*) /bin/rm -f "$STATE_PATH" ;;
        *) /bin/kill -0 "$saved_pid" 2>/dev/null || /bin/rm -f "$STATE_PATH" ;;
      esac
    fi
    /bin/sleep 2
    continue
  fi

  if verified_cdp_endpoint "$PORT"; then
    last_pid="$codex_pid"
    unwrapped_checks=0
    expected_version="$(/usr/bin/tr -d '[:space:]' < "$PROJECT_ROOT/VERSION" 2>/dev/null || true)"
    saved_version="$(state_field skinVersion 2>/dev/null || true)"
    if recorded_injector_is_running && [ -n "$expected_version" ] && [ "$saved_version" != "$expected_version" ]; then
      printf '%s detected Dream Skin version change (%s -> %s); refreshing injector without restarting Codex\n' \
        "$(/bin/date -u '+%Y-%m-%dT%H:%M:%SZ')" "${saved_version:-unknown}" "$expected_version"
      "$SCRIPT_DIR/start-dream-skin-macos.sh" --port "$PORT" >> "$WATCHDOG_LOG" 2>> "$WATCHDOG_ERROR_LOG" || true
    elif ! recorded_injector_is_running; then
      if [ -f "$STATE_PATH" ]; then
        saved_pid="$(state_field injectorPid 2>/dev/null || true)"
        case "$saved_pid" in
          ''|*[!0-9]*) /bin/rm -f "$STATE_PATH" ;;
          *) /bin/kill -0 "$saved_pid" 2>/dev/null || /bin/rm -f "$STATE_PATH" ;;
        esac
      fi
      "$SCRIPT_DIR/start-dream-skin-macos.sh" --port "$PORT" >> "$WATCHDOG_LOG" 2>> "$WATCHDOG_ERROR_LOG" || true
    fi
    /bin/sleep 2
    continue
  fi

  if [ "$codex_pid" != "$last_pid" ]; then
    last_pid="$codex_pid"
    unwrapped_checks=0
  fi
  unwrapped_checks=$((unwrapped_checks + 1))
  if [ "$unwrapped_checks" -ge 2 ]; then
    printf '%s detected ordinary Codex launch (pid %s); enabling persistent theme session\n' \
      "$(/bin/date -u '+%Y-%m-%dT%H:%M:%SZ')" "$codex_pid"
    "$SCRIPT_DIR/start-dream-skin-macos.sh" --port "$PORT" --restart-existing >> "$WATCHDOG_LOG" 2>> "$WATCHDOG_ERROR_LOG" || true
    unwrapped_checks=0
  fi
  /bin/sleep 2
done
