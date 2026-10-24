#!/usr/bin/env bash
# Usage: keep-awake.sh run -- COMMAND [ARGS...]
#        keep-awake.sh start [--hours N] [--pid PID] [--lid] | stop [--pid PID] | status [--pid PID]
#
# `run` holds a sleep-prevention assertion exactly as long as COMMAND runs and
# exits with its status. `start` holds one in the background, scoped to one
# agent session, until whichever comes first: `stop`, the watched process
# exiting, or the --hours cap. On macOS, `--lid` also disables lid-close sleep
# for the same span and re-enables it on release.

set -euo pipefail

default_max_hours=12
state_dir="${TMPDIR:-/tmp}/keep-awake"

is_shell() {
  case "$(basename "${1#-}")" in
    sh | bash | zsh | dash | fish | ksh | tcsh | csh) return 0 ;;
    *) return 1 ;;
  esac
}

# The agent runs each command in a throwaway shell, so the first non-shell
# ancestor is the long-lived agent process (claude, codex, jazz, ...).
find_agent_pid() {
  local current_pid=$PPID
  local command_name
  while [ "$current_pid" -gt 1 ]; do
    command_name="$(ps -o comm= -p "$current_pid" 2>/dev/null || true)"
    if [ -z "$command_name" ]; then
      break
    fi
    if ! is_shell "$command_name"; then
      echo "$current_pid"
      return
    fi
    current_pid="$(ps -o ppid= -p "$current_pid" | tr -d ' ')"
  done
  echo "$PPID"
}

is_running() {
  kill -0 "$1" 2>/dev/null
}

# caffeinate cannot block lid-close sleep; only `pmset disablesleep` can. It
# needs root, so --lid runs it through `sudo -n` and relies on a sudoers rule
# for exactly these two commands (see lid_setup_hint).
lid_sleep_disabled() {
  [ "$(pmset -g 2>/dev/null | awk '/SleepDisabled/ {print $2}')" = "1" ]
}

restore_lid_command="sudo -n /usr/bin/pmset -a disablesleep 0"

lid_setup_hint() {
  cat >&2 <<EOF
--lid needs passwordless sudo for pmset disablesleep. One-time setup:
  echo "$(id -un) ALL=(root) NOPASSWD: /usr/bin/pmset -a disablesleep 1, /usr/bin/pmset -a disablesleep 0" | sudo tee /etc/sudoers.d/keep-awake && sudo chmod 440 /etc/sudoers.d/keep-awake && sudo visudo -cf /etc/sudoers.d/keep-awake
EOF
}

print_lid_note() {
  if [ "$(uname -s)" != "Darwin" ]; then
    return
  fi
  if [ -f "$lid_file" ]; then
    echo "lid sleep disabled until release; it is re-enabled on stop, agent exit or the cap"
  elif lid_sleep_disabled; then
    echo "lid sleep is disabled outside keep-awake; undo when done: sudo pmset -a disablesleep 0"
  else
    echo "closing the lid still sleeps this Mac; start with --lid to keep running lid-closed"
  fi
}

action="${1:-}"
shift || true

max_hours=$default_max_hours
watched_pid=""
hold_lid=false
while [ $# -gt 0 ]; do
  case "$1" in
    --hours)
      max_hours="$2"
      shift 2
      ;;
    --lid)
      hold_lid=true
      shift
      ;;
    --pid)
      watched_pid="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "unknown option: $1" >&2
      exit 2
      ;;
  esac
done

run() {
  if [ $# -eq 0 ]; then
    echo "usage: keep-awake.sh run -- COMMAND [ARGS...]" >&2
    exit 2
  fi
  case "$(uname -s)" in
    Darwin)
      exec caffeinate -ims "$@"
      ;;
    Linux)
      if ! command -v systemd-inhibit >/dev/null 2>&1; then
        echo "systemd-inhibit not found; running without preventing sleep" >&2
        exec "$@"
      fi
      exec systemd-inhibit --what=idle:sleep --who=keep-awake \
        --why="agent task in progress" --mode=block "$@"
      ;;
    *)
      echo "unsupported platform: $(uname -s); running without preventing sleep" >&2
      exec "$@"
      ;;
  esac
}

if [ "$action" = "run" ]; then
  run "$@"
fi

if [ -z "$watched_pid" ]; then
  watched_pid="$(find_agent_pid)"
fi
pid_file="$state_dir/$watched_pid.pid"
lid_file="$state_dir/$watched_pid.lid"

# Only re-enables lid sleep that this session disabled, so a setting the user
# made by hand is left alone.
restore_lid_sleep() {
  if [ -f "$lid_file" ]; then
    $restore_lid_command >/dev/null 2>&1 || echo "could not re-enable lid sleep; run: sudo pmset -a disablesleep 0" >&2
    rm -f "$lid_file"
    echo "lid sleep re-enabled"
  fi
}

read_holder_pid() {
  if [ -f "$pid_file" ]; then
    local holder_pid
    holder_pid="$(cat "$pid_file")"
    if is_running "$holder_pid"; then
      echo "$holder_pid"
      return
    fi
    rm -f "$pid_file"
  fi
}

start() {
  local holder_pid
  holder_pid="$(read_holder_pid)"
  if [ -n "$holder_pid" ]; then
    echo "already awake (holder $holder_pid, watching $watched_pid)"
    if [ "$hold_lid" = true ] && [ ! -f "$lid_file" ]; then
      echo "--lid is not active on this hold; run stop, then start --lid" >&2
    fi
    return
  fi

  local max_seconds=$((max_hours * 3600))
  mkdir -p "$state_dir"

  case "$(uname -s)" in
    Darwin)
      local caffeinate_args=(-ims -w "$watched_pid")
      if [ "$max_seconds" -gt 0 ]; then
        caffeinate_args+=(-t "$max_seconds")
      fi
      if [ "$hold_lid" = true ] && ! lid_sleep_disabled; then
        if sudo -n /usr/bin/pmset -a disablesleep 1 >/dev/null 2>&1; then
          touch "$lid_file"
        else
          echo "could not disable lid sleep; holding without --lid" >&2
          lid_setup_hint
        fi
      fi
      if [ -f "$lid_file" ]; then
        # The wrapper outlives caffeinate so lid sleep comes back on every
        # release path: stop, the agent exiting, or the cap.
        nohup bash -c 'caffeinate "${@:2}"; '"$restore_lid_command"' >/dev/null 2>&1; rm -f "$1"' \
          keep-awake-holder "$lid_file" "${caffeinate_args[@]}" >/dev/null 2>&1 &
      else
        nohup caffeinate "${caffeinate_args[@]}" >/dev/null 2>&1 &
      fi
      ;;
    Linux)
      if ! command -v systemd-inhibit >/dev/null 2>&1; then
        echo "systemd-inhibit not found; cannot prevent sleep on this system" >&2
        exit 1
      fi
      local wait_command=(tail --pid="$watched_pid" -f /dev/null)
      if [ "$max_seconds" -gt 0 ]; then
        wait_command=(timeout "$max_seconds" "${wait_command[@]}")
      fi
      nohup systemd-inhibit --what=idle:sleep --who=keep-awake \
        --why="agent task in progress" --mode=block \
        "${wait_command[@]}" >/dev/null 2>&1 &
      ;;
    *)
      echo "unsupported platform: $(uname -s)" >&2
      exit 1
      ;;
  esac

  holder_pid=$!
  disown "$holder_pid" 2>/dev/null || true
  echo "$holder_pid" >"$pid_file"

  local cap_description="no cap"
  if [ "$max_seconds" -gt 0 ]; then
    cap_description="cap ${max_hours}h"
  fi
  echo "awake (holder $holder_pid, watching $watched_pid, $cap_description)"
  print_lid_note
}

stop() {
  local holder_pid
  holder_pid="$(read_holder_pid)"
  if [ -z "$holder_pid" ]; then
    echo "not running"
  else
    pkill -P "$holder_pid" 2>/dev/null || true
    kill "$holder_pid" 2>/dev/null || true
    rm -f "$pid_file"
    echo "released (holder $holder_pid)"
  fi
  restore_lid_sleep
  if [ "$(uname -s)" = "Darwin" ] && lid_sleep_disabled; then
    print_lid_note
  fi
}

status() {
  local holder_pid
  holder_pid="$(read_holder_pid)"
  if [ -n "$holder_pid" ]; then
    echo "awake (holder $holder_pid, watching $watched_pid)"
  else
    echo "not running"
  fi
}

case "$action" in
  start) start ;;
  stop) stop ;;
  status) status ;;
  *)
    echo "usage: keep-awake.sh run -- COMMAND | start [--hours N] [--pid PID] [--lid] | stop | status" >&2
    exit 2
    ;;
esac
