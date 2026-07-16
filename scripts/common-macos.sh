#!/bin/bash

set -euo pipefail

if [ -z "${HOME:-}" ]; then
  CURRENT_USER="$(/usr/bin/id -un)"
  HOME="$(/usr/bin/dscl . -read "/Users/$CURRENT_USER" NFSHomeDirectory 2>/dev/null | /usr/bin/awk '{print $2}')"
  [ -n "$HOME" ] || { printf 'Codex Dream Skin Studio: could not resolve the current macOS home directory.\n' >&2; exit 1; }
  export HOME
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"
INJECTOR="$SCRIPT_DIR/injector.mjs"
INSTALL_ROOT="$HOME/.codex/codex-dream-skin-studio"
STATE_ROOT="$HOME/Library/Application Support/CodexDreamSkinStudio"
STATE_PATH="$STATE_ROOT/state.json"
THEME_BACKUP_PATH="$STATE_ROOT/theme-backup.json"
THEME_DIR="$STATE_ROOT/theme"
CONFIG_PATH="$HOME/.codex/config.toml"
INJECTOR_LOG="$STATE_ROOT/injector.log"
INJECTOR_ERROR_LOG="$STATE_ROOT/injector-error.log"
APP_LOG="$STATE_ROOT/codex-launch.log"
APP_ERROR_LOG="$STATE_ROOT/codex-launch-error.log"
START_ERROR_LOG="$STATE_ROOT/start-error.log"
WATCHDOG_LOG="$STATE_ROOT/watchdog.log"
WATCHDOG_ERROR_LOG="$STATE_ROOT/watchdog-error.log"
CODEX_APP_JOB_LABEL="com.openai.codex-dream-skin-studio.app"
INJECTOR_JOB_LABEL="com.openai.codex-dream-skin-studio.injector"
WATCHDOG_JOB_LABEL="com.openai.codex-dream-skin-studio.watchdog"
LEGACY_REPAIR_JOB_LABEL="com.openai.codex-dream-skin-studio.repair"
INJECTOR_PLIST="$HOME/Library/LaunchAgents/$INJECTOR_JOB_LABEL.plist"
WATCHDOG_PLIST="$HOME/Library/LaunchAgents/$WATCHDOG_JOB_LABEL.plist"
EXPECTED_CODEX_TEAM_ID="${CODEX_EXPECTED_TEAM_ID:-2DC432GLL2}"
SKIN_VERSION="2.7.0"

fail() {
  local message="$*"
  if [ -n "${START_ERROR_LOG:-}" ] && [ -n "${STATE_ROOT:-}" ]; then
    /bin/mkdir -p "$STATE_ROOT" 2>/dev/null || true
    printf '%s %s\n' "$(/bin/date -u '+%Y-%m-%dT%H:%M:%SZ')" "$message" >> "$START_ERROR_LOG" 2>/dev/null || true
  fi
  printf 'Codex Dream Skin Studio: %s\n' "$message" >&2
  exit 1
}

ensure_state_root() {
  /bin/mkdir -p "$STATE_ROOT"
  /bin/chmod 700 "$STATE_ROOT"
}

recorded_injector_is_running() {
  [ -f "$STATE_PATH" ] || return 1
  local pid saved_start saved_node saved_injector actual_start command_line
  pid="$(state_field injectorPid 2>/dev/null || true)"
  saved_start="$(state_field injectorStartedAt 2>/dev/null || true)"
  saved_node="$(state_field nodePath 2>/dev/null || true)"
  saved_injector="$(state_field injectorPath 2>/dev/null || true)"
  case "$pid" in ''|*[!0-9]*) return 1 ;; esac
  /bin/kill -0 "$pid" 2>/dev/null || return 1
  [ "$saved_node" = "$NODE" ] && [ "$saved_injector" = "$INJECTOR" ] || return 1
  actual_start="$(process_started_at "$pid")"
  [ -n "$actual_start" ] && [ "$actual_start" = "$saved_start" ] || return 1
  command_line="$(/bin/ps -p "$pid" -o command= 2>/dev/null || true)"
  case "$command_line" in *"$saved_node"*"$saved_injector"*"--watch"*) return 0 ;; esac
  return 1
}

install_watchdog_agent() {
  local port="$1"
  local temporary="$WATCHDOG_PLIST.installing.$$"
  /bin/mkdir -p "$(dirname "$WATCHDOG_PLIST")"
  /bin/rm -f "$temporary"
  /usr/bin/plutil -create xml1 "$temporary"
  /usr/bin/plutil -insert Label -string "$WATCHDOG_JOB_LABEL" "$temporary"
  /usr/bin/plutil -insert ProgramArguments -array "$temporary"
  /usr/bin/plutil -insert ProgramArguments.0 -string /bin/bash "$temporary"
  /usr/bin/plutil -insert ProgramArguments.1 -string "$SCRIPT_DIR/watchdog-dream-skin-macos.sh" "$temporary"
  /usr/bin/plutil -insert ProgramArguments.2 -string --port "$temporary"
  /usr/bin/plutil -insert ProgramArguments.3 -string "$port" "$temporary"
  /usr/bin/plutil -insert RunAtLoad -bool true "$temporary"
  /usr/bin/plutil -insert KeepAlive -bool true "$temporary"
  /usr/bin/plutil -insert ProcessType -string Background "$temporary"
  /usr/bin/plutil -insert StandardOutPath -string "$WATCHDOG_LOG" "$temporary"
  /usr/bin/plutil -insert StandardErrorPath -string "$WATCHDOG_ERROR_LOG" "$temporary"
  /bin/chmod 600 "$temporary"
  /bin/mv "$temporary" "$WATCHDOG_PLIST"
  /bin/launchctl bootout "gui/$(/usr/bin/id -u)/$WATCHDOG_JOB_LABEL" >/dev/null 2>&1 || true
  /bin/launchctl bootstrap "gui/$(/usr/bin/id -u)" "$WATCHDOG_PLIST"
  /bin/launchctl kickstart -k "gui/$(/usr/bin/id -u)/$WATCHDOG_JOB_LABEL"
}

disable_watchdog_agent() {
  /bin/launchctl bootout "gui/$(/usr/bin/id -u)/$WATCHDOG_JOB_LABEL" >/dev/null 2>&1 || true
  /bin/rm -f "$WATCHDOG_PLIST"
}

disable_legacy_repair_job() {
  /bin/launchctl remove "$LEGACY_REPAIR_JOB_LABEL" >/dev/null 2>&1 || true
}

disable_injector_agent() {
  /bin/launchctl bootout "gui/$(/usr/bin/id -u)/$INJECTOR_JOB_LABEL" >/dev/null 2>&1 ||
    /bin/launchctl remove "$INJECTOR_JOB_LABEL" >/dev/null 2>&1 || true
  /bin/rm -f "$INJECTOR_PLIST"
}

discover_codex_app() {
  local candidate=""
  local identifier=""
  local executable_name=""
  local configured="${CODEX_APP_BUNDLE:-}"

  for candidate in "$configured" "/Applications/ChatGPT.app" "$HOME/Applications/ChatGPT.app"; do
    [ -n "$candidate" ] || continue
    [ -f "$candidate/Contents/Info.plist" ] || continue
    identifier="$(/usr/bin/plutil -extract CFBundleIdentifier raw -o - "$candidate/Contents/Info.plist" 2>/dev/null || true)"
    if [ "$identifier" = "com.openai.codex" ]; then
      CODEX_BUNDLE="$candidate"
      break
    fi
  done

  if [ -z "${CODEX_BUNDLE:-}" ]; then
    candidate="$(/usr/bin/mdfind 'kMDItemCFBundleIdentifier == "com.openai.codex"' | /usr/bin/head -n 1)"
    if [ -n "$candidate" ] && [ -f "$candidate/Contents/Info.plist" ]; then
      identifier="$(/usr/bin/plutil -extract CFBundleIdentifier raw -o - "$candidate/Contents/Info.plist" 2>/dev/null || true)"
      [ "$identifier" = "com.openai.codex" ] && CODEX_BUNDLE="$candidate"
    fi
  fi

  [ -n "${CODEX_BUNDLE:-}" ] || fail "Could not find the official Codex app bundle (com.openai.codex)."
  executable_name="$(/usr/bin/plutil -extract CFBundleExecutable raw -o - "$CODEX_BUNDLE/Contents/Info.plist")"
  CODEX_EXE="$CODEX_BUNDLE/Contents/MacOS/$executable_name"
  CODEX_VERSION="$(/usr/bin/plutil -extract CFBundleShortVersionString raw -o - "$CODEX_BUNDLE/Contents/Info.plist")"
  [ -x "$CODEX_EXE" ] || fail "Codex executable is missing: $CODEX_EXE"
  export CODEX_BUNDLE CODEX_EXE CODEX_VERSION
}

codesign_team_id() {
  /usr/bin/codesign -dv --verbose=4 "$1" 2>&1 \
    | /usr/bin/awk -F= '/^TeamIdentifier=/{print $2; exit}'
}

require_macos_runtime() {
  [ "$(/usr/bin/uname -s)" = "Darwin" ] || fail "This launcher requires macOS."
  [ -n "${CODEX_BUNDLE:-}" ] || fail "Discover the Codex app before validating its runtime."

  RUNTIME_NODE="$CODEX_BUNDLE/Contents/Resources/cua_node/bin/node"
  [ -x "$RUNTIME_NODE" ] || fail "The signed Node.js runtime bundled with Codex was not found: $RUNTIME_NODE"
  /usr/bin/codesign --verify --deep --strict "$CODEX_BUNDLE" >/dev/null 2>&1 \
    || fail "The Codex app signature is not valid. Restore or reinstall the official app before continuing."
  /usr/bin/codesign --verify --strict "$RUNTIME_NODE" >/dev/null 2>&1 \
    || fail "The Node.js runtime bundled with Codex failed code-signature validation."

  CODEX_TEAM_ID="$(codesign_team_id "$CODEX_BUNDLE")"
  NODE_TEAM_ID="$(codesign_team_id "$RUNTIME_NODE")"
  [ "$CODEX_TEAM_ID" = "$EXPECTED_CODEX_TEAM_ID" ] \
    || fail "Unexpected Codex signing team: ${CODEX_TEAM_ID:-missing}."
  [ "$NODE_TEAM_ID" = "$CODEX_TEAM_ID" ] \
    || fail "The bundled Node.js signer does not match the Codex app signer."

  local machine_arch
  local node_major
  machine_arch="$(/usr/bin/uname -m)"
  /usr/bin/file "$RUNTIME_NODE" | /usr/bin/grep -q "$machine_arch" \
    || fail "The Codex Node.js runtime does not match this Mac architecture ($machine_arch)."
  NODE_VERSION="$($RUNTIME_NODE --version)"
  node_major="${NODE_VERSION#v}"
  node_major="${node_major%%.*}"
  case "$node_major" in ''|*[!0-9]*) fail "Could not parse bundled Node.js version: $NODE_VERSION" ;; esac
  [ "$node_major" -ge 20 ] || fail "Codex bundled Node.js $NODE_VERSION is too old; version 20 or newer is required."

  NODE="$RUNTIME_NODE"
  export NODE RUNTIME_NODE NODE_VERSION CODEX_TEAM_ID NODE_TEAM_ID
}

codex_main_pids() {
  local pid
  local command_line
  while read -r pid command_line; do
    [ -n "$pid" ] || continue
    case "$command_line" in
      "$CODEX_EXE"*) printf '%s\n' "$pid" ;;
    esac
  done < <(/bin/ps -axo pid=,command=)
}

codex_is_running() {
  [ -n "$(codex_main_pids)" ]
}

process_started_at() {
  /bin/ps -p "$1" -o lstart= 2>/dev/null | /usr/bin/awk '{$1=$1; print}'
}

stop_codex() {
  local allow_force="${1:-false}"
  local deadline
  local pid

  /bin/launchctl remove "$CODEX_APP_JOB_LABEL" >/dev/null 2>&1 || true
  codex_is_running || return 0
  /usr/bin/osascript -e 'tell application id "com.openai.codex" to quit' >/dev/null 2>&1 || true
  deadline=$((SECONDS + 15))
  while codex_is_running && [ "$SECONDS" -lt "$deadline" ]; do /bin/sleep 0.25; done
  codex_is_running || return 0

  [ "$allow_force" = "true" ] || fail "Codex did not close within 15 seconds; explicit restart authorization is required for a forced stop."
  while IFS= read -r pid; do
    [ -n "$pid" ] && /bin/kill -TERM "$pid" 2>/dev/null || true
  done < <(codex_main_pids)
  deadline=$((SECONDS + 5))
  while codex_is_running && [ "$SECONDS" -lt "$deadline" ]; do /bin/sleep 0.25; done
  if codex_is_running; then
    while IFS= read -r pid; do
      [ -n "$pid" ] && /bin/kill -KILL "$pid" 2>/dev/null || true
    done < <(codex_main_pids)
  fi
  /bin/sleep 0.5
  codex_is_running && fail "Codex could not be stopped safely."
  return 0
}

listener_pids() {
  /usr/sbin/lsof -nP -iTCP:"$1" -sTCP:LISTEN -t 2>/dev/null | /usr/bin/sort -u || true
}

port_is_available() {
  [ -z "$(listener_pids "$1")" ]
}

pid_is_codex_descendant() {
  local current="$1"
  local command_line=""
  local parent=""
  local depth=0
  while [ "$current" -gt 1 ] 2>/dev/null && [ "$depth" -lt 32 ]; do
    command_line="$(/bin/ps -p "$current" -o command= 2>/dev/null || true)"
    case "$command_line" in "$CODEX_EXE"*) return 0 ;; esac
    parent="$(/bin/ps -p "$current" -o ppid= 2>/dev/null | /usr/bin/awk '{$1=$1; print}')"
    case "$parent" in ''|*[!0-9]*) return 1 ;; esac
    [ "$parent" -ne "$current" ] || return 1
    current="$parent"
    depth=$((depth + 1))
  done
  return 1
}

port_belongs_to_codex() {
  local port="$1"
  local found_direct="false"
  local pid
  local command_line
  while IFS= read -r pid; do
    [ -n "$pid" ] || continue
    command_line="$(/bin/ps -p "$pid" -o command= 2>/dev/null || true)"
    case "$command_line" in
      "$CODEX_EXE"*) found_direct="true" ;;
      *) pid_is_codex_descendant "$pid" || return 1 ;;
    esac
  done < <(listener_pids "$port")
  [ "$found_direct" = "true" ]
}

verified_cdp_endpoint() {
  local port="$1"
  port_belongs_to_codex "$port" || return 1
  /usr/bin/curl --noproxy '*' --silent --fail --max-time 2 "http://127.0.0.1:$port/json/version" \
    | "$NODE" -e '
      let input = "";
      process.stdin.setEncoding("utf8");
      process.stdin.on("data", chunk => input += chunk);
      process.stdin.on("end", () => {
        try {
          const parsed = JSON.parse(input);
          const url = new URL(parsed.webSocketDebuggerUrl);
          const ok = url.protocol === "ws:" && ["127.0.0.1", "localhost", "[::1]"].includes(url.hostname);
          process.exitCode = ok ? 0 : 2;
        } catch { process.exitCode = 2; }
      });
    ' >/dev/null 2>&1
}

select_available_port() {
  local preferred="$1"
  local candidate="$preferred"
  local last=$((preferred + 100))
  [ "$last" -le 65535 ] || last=65535
  while [ "$candidate" -le "$last" ]; do
    if port_is_available "$candidate"; then
      printf '%s\n' "$candidate"
      return 0
    fi
    candidate=$((candidate + 1))
  done
  fail "No free loopback port was found between $preferred and $last."
}

wait_for_cdp() {
  local port="$1"
  local deadline=$((SECONDS + 35))
  while [ "$SECONDS" -lt "$deadline" ]; do
    verified_cdp_endpoint "$port" && return 0
    /bin/sleep 0.4
  done
  return 1
}

state_field() {
  local key="$1"
  "$NODE" -e '
    const fs = require("node:fs");
    const value = JSON.parse(fs.readFileSync(process.argv[1], "utf8"))[process.argv[2]];
    if (value !== undefined && value !== null) process.stdout.write(String(value));
  ' "$STATE_PATH" "$key"
}

write_state() {
  local port="$1"
  local injector_pid="$2"
  local injector_started_at="$3"
  local codex_pid="$4"
  "$NODE" -e '
    const fs = require("node:fs");
    const [file, version, port, pid, startedAt, injector, node, nodeVersion, bundle, exe, appVersion, teamId, root, themeDir, codexPid, arch] = process.argv.slice(1);
    const state = {
      schemaVersion: 4,
      platform: `darwin-${arch}`,
      skinVersion: version,
      port: Number(port),
      injectorPid: Number(pid),
      injectorStartedAt: startedAt,
      injectorPath: injector,
      nodePath: node,
      nodeVersion,
      codexBundle: bundle,
      codexExe: exe,
      codexVersion: appVersion,
      codexTeamId: teamId,
      codexPid: Number(codexPid || 0),
      projectRoot: root,
      themeDir,
      createdAt: new Date().toISOString()
    };
    const temporary = `${file}.${process.pid}.tmp`;
    fs.writeFileSync(temporary, `${JSON.stringify(state, null, 2)}\n`, { mode: 0o600 });
    fs.renameSync(temporary, file);
  ' "$STATE_PATH" "$SKIN_VERSION" "$port" "$injector_pid" "$injector_started_at" "$INJECTOR" "$NODE" "$NODE_VERSION" "$CODEX_BUNDLE" "$CODEX_EXE" "$CODEX_VERSION" "$CODEX_TEAM_ID" "$PROJECT_ROOT" "$THEME_DIR" "$codex_pid" "$(/usr/bin/uname -m)"
}

stop_recorded_injector() {
  [ -f "$STATE_PATH" ] || return 0
  local pid
  local saved_start
  local saved_node
  local saved_injector
  local actual_start
  local command_line
  pid="$(state_field injectorPid)" || fail "Could not read the saved injector PID; state was preserved."
  saved_start="$(state_field injectorStartedAt)" || fail "Could not read the saved injector start time; state was preserved."
  saved_node="$(state_field nodePath)" || fail "Could not read the saved Node.js path; state was preserved."
  saved_injector="$(state_field injectorPath)" || fail "Could not read the saved injector path; state was preserved."
  [ -n "$pid" ] || fail "The saved injector state has no PID; state was preserved."
  /bin/kill -0 "$pid" 2>/dev/null || return 0
  [ "$saved_node" = "$NODE" ] || fail "Saved Node.js identity does not match this project; injector was not stopped."
  [ "$saved_injector" = "$INJECTOR" ] || fail "Saved injector identity does not match this project; injector was not stopped."
  actual_start="$(process_started_at "$pid")"
  [ -n "$actual_start" ] && [ "$actual_start" = "$saved_start" ] || fail "Saved injector start time no longer matches PID $pid; injector was not stopped."
  command_line="$(/bin/ps -p "$pid" -o command= 2>/dev/null || true)"
  case "$command_line" in *"$saved_node"*"$saved_injector"*"--watch"*) ;; *) fail "Saved injector command line does not match PID $pid; injector was not stopped." ;; esac
  /bin/launchctl bootout "gui/$(/usr/bin/id -u)/$INJECTOR_JOB_LABEL" >/dev/null 2>&1 ||
    /bin/launchctl remove "$INJECTOR_JOB_LABEL" >/dev/null 2>&1 || /bin/kill -TERM "$pid"
  local deadline=$((SECONDS + 6))
  while /bin/kill -0 "$pid" 2>/dev/null && [ "$SECONDS" -lt "$deadline" ]; do /bin/sleep 0.2; done
  /bin/kill -0 "$pid" 2>/dev/null && fail "The verified injector did not stop; state was preserved."
  return 0
}

launch_injector_daemon() {
  local port="$1"
  local pid=""
  local deadline=$((SECONDS + 15))
  local temporary="$INJECTOR_PLIST.installing.$$"
  : > "$INJECTOR_LOG"
  : > "$INJECTOR_ERROR_LOG"
  /bin/mkdir -p "$(dirname "$INJECTOR_PLIST")"
  /bin/rm -f "$temporary"
  /usr/bin/plutil -create xml1 "$temporary"
  /usr/bin/plutil -insert Label -string "$INJECTOR_JOB_LABEL" "$temporary"
  /usr/bin/plutil -insert ProgramArguments -array "$temporary"
  /usr/bin/plutil -insert ProgramArguments.0 -string "$NODE" "$temporary"
  /usr/bin/plutil -insert ProgramArguments.1 -string "$INJECTOR" "$temporary"
  /usr/bin/plutil -insert ProgramArguments.2 -string --watch "$temporary"
  /usr/bin/plutil -insert ProgramArguments.3 -string --port "$temporary"
  /usr/bin/plutil -insert ProgramArguments.4 -string "$port" "$temporary"
  /usr/bin/plutil -insert ProgramArguments.5 -string --theme-dir "$temporary"
  /usr/bin/plutil -insert ProgramArguments.6 -string "$THEME_DIR" "$temporary"
  /usr/bin/plutil -insert RunAtLoad -bool true "$temporary"
  /usr/bin/plutil -insert KeepAlive -bool true "$temporary"
  /usr/bin/plutil -insert ProcessType -string Background "$temporary"
  /usr/bin/plutil -insert ThrottleInterval -integer 1 "$temporary"
  /usr/bin/plutil -insert StandardOutPath -string "$INJECTOR_LOG" "$temporary"
  /usr/bin/plutil -insert StandardErrorPath -string "$INJECTOR_ERROR_LOG" "$temporary"
  /bin/chmod 600 "$temporary"
  /bin/mv "$temporary" "$INJECTOR_PLIST"
  /bin/launchctl bootout "gui/$(/usr/bin/id -u)/$INJECTOR_JOB_LABEL" >/dev/null 2>&1 ||
    /bin/launchctl remove "$INJECTOR_JOB_LABEL" >/dev/null 2>&1 || true
  /bin/launchctl bootstrap "gui/$(/usr/bin/id -u)" "$INJECTOR_PLIST"
  while [ "$SECONDS" -lt "$deadline" ]; do
    pid="$(/bin/launchctl print "gui/$(/usr/bin/id -u)/$INJECTOR_JOB_LABEL" 2>/dev/null \
      | /usr/bin/awk '/^[[:space:]]*pid = [0-9]+/{print $3; exit}')"
    if [ -n "$pid" ] && /bin/kill -0 "$pid" 2>/dev/null; then
      printf '%s\n' "$pid"
      return 0
    fi
    /bin/sleep 0.2
  done
  disable_injector_agent
  fail "The persistent injector LaunchAgent did not start. See $INJECTOR_ERROR_LOG"
}

launch_codex_with_cdp() {
  local port="$1"
  : > "$APP_LOG"
  : > "$APP_ERROR_LOG"
  /bin/launchctl remove "$CODEX_APP_JOB_LABEL" >/dev/null 2>&1 || true
  /bin/launchctl submit -l "$CODEX_APP_JOB_LABEL" -o "$APP_LOG" -e "$APP_ERROR_LOG" -- "$CODEX_EXE" \
    --remote-debugging-address=127.0.0.1 \
    --remote-debugging-port="$port"
  /bin/launchctl kickstart -k "gui/$(/usr/bin/id -u)/$CODEX_APP_JOB_LABEL"
}

launch_codex_normally() {
  /bin/launchctl remove "$CODEX_APP_JOB_LABEL" >/dev/null 2>&1 || true
  /usr/bin/open -na "$CODEX_BUNDLE"
}
