#!/usr/bin/env bash
# Usage: keep-awake.sh run -- COMMAND [ARGS...]
#        keep-awake.sh start [--hours N] [--pid PID] | stop [--pid PID] | status [--pid PID]
#
# `run` holds a sleep-prevention assertion exactly as long as COMMAND runs and
# exits with its status. `start` holds one in the background, scoped to one
# agent session, until whichever comes first: `stop`, the watched process
# exiting, or the --hours cap.

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

action="${1:-}"
shift || true

max_hours=$default_max_hours
watched_pid=""
while [ $# -gt 0 ]; do
  case "$1" in
    --hours)
      max_hours="$2"
      shift 2
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
      nohup caffeinate "${caffeinate_args[@]}" >/dev/null 2>&1 &
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
}

stop() {
  local holder_pid
  holder_pid="$(read_holder_pid)"
  if [ -z "$holder_pid" ]; then
    echo "not running"
    return
  fi
  kill "$holder_pid"
  rm -f "$pid_file"
  echo "released (holder $holder_pid)"
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
    echo "usage: keep-awake.sh run -- COMMAND | start [--hours N] [--pid PID] | stop | status" >&2
    exit 2
    ;;
esac
