#!/bin/bash
# toggle-app.sh — focus or launch by app_id or window title
#
# Usage:
#   toggle-app.sh --app-id <APP_ID>  [--cmd <LAUNCH_CMD>]
#   toggle-app.sh --title   <TITLE>   [--cmd <LAUNCH_CMD>]
#
# --app-id:  match niri window app_id
# --title:   match niri window title (case-insensitive contains)
# --cmd:     command to launch if no matching window found (defaults to app_id or title)
#
# Multiple matches → picks most recently focused.
#
# Examples:
#   toggle-app.sh --app-id com.mitchellh.ghostty --cmd ghostty
#   toggle-app.sh --title "Google Calendar" --cmd "firefox --new-window https://calendar.google.com"

set -euo pipefail

usage() {
    echo "Usage: $0 --app-id <APP_ID> [--cmd <LAUNCH_CMD>]"
    echo "       $0 --title <TITLE> [--cmd <LAUNCH_CMD>]"
    exit 1
}

MODE=""
VALUE=""
LAUNCH_CMD=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --app-id) MODE=app_id; VALUE="$2";              shift 2 ;;
        --title)  MODE=title;  VALUE="$2";              shift 2 ;;
        --cmd)    LAUNCH_CMD="$2";                      shift 2 ;;
        *)        echo "Unknown arg: $1"; usage         ;;
    esac
done

[[ -z "$MODE" || -z "$VALUE" ]] && usage

# default launch = VALUE if not overridden
[[ -z "$LAUNCH_CMD" ]] && LAUNCH_CMD="$VALUE"

# --- find best-matching window ---

if [ "$MODE" = "app_id" ]; then
    WIN_ID=$(niri msg -j windows 2>/dev/null \
        | jq -r "[.[] | select(.app_id == \"$VALUE\")] | sort_by(.focus_timestamp.secs, .focus_timestamp.nanos) | last | .id // empty")
else
    WIN_ID=$(niri msg -j windows 2>/dev/null \
        | jq -r --arg t "$VALUE" '[.[] | select(.title | ascii_downcase | contains($t | ascii_downcase))] | sort_by(.focus_timestamp.secs, .focus_timestamp.nanos) | last | .id // empty')
fi

# --- act ---

if [ -z "$WIN_ID" ]; then
    # No window found → launch
    exec $LAUNCH_CMD &
else
    # Found → focus
    niri msg action focus-window --id "$WIN_ID"
fi