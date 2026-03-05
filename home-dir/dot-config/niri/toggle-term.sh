#!/bin/bash
APP_CLASS="com.mitchellh.ghostty"
APP_CMD="ghostty"

# Find window by app_id (class)
# We pick the one with the highest focus_timestamp (most recently focused)
WIN_ID=$(niri msg -j windows | jq -r "[.[] | select(.app_id == \"$APP_CLASS\")] | sort_by(.focus_timestamp.secs, .focus_timestamp.nanos) | last | .id // empty")

if [ -z "$WIN_ID" ]; then
  # No window → launch
  $APP_CMD &
  exit 0
fi

# Found window, focus on it
niri msg action focus-window --id "$WIN_ID"
