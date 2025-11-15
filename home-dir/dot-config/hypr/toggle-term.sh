#!/bin/bash
APP_CLASS="st-256color"
APP_CMD="st"
STATE_FILE="/tmp/${APP_CLASS}_workspace"

# Find window by class
WIN_INFO=$(hyprctl clients -j | jq -r ".[] | select(.class==\"$APP_CLASS\")")

if [ -z "$WIN_INFO" ]; then
    # No window → launch
    exec $APP_CMD &
    exit 0
fi

WIN_ADDR=$(echo "$WIN_INFO" | jq -r ".address")
WIN_WS=$(echo "$WIN_INFO" | jq -r ".workspace.id")
CUR_WS=$(hyprctl activeworkspace -j | jq -r ".id")

if [ "$WIN_WS" != "$CUR_WS" ]; then
    # Move to current workspace, remember original
    echo "$WIN_WS" > "$STATE_FILE"
    hyprctl dispatch movetoworkspace "$CUR_WS,address:$WIN_ADDR"
elif [ -f "$STATE_FILE" ]; then
    # Already here, move back
    ORIG_WS=$(cat "$STATE_FILE")
    rm "$STATE_FILE"
    hyprctl dispatch movetoworkspace "$ORIG_WS,address:$WIN_ADDR"
else
    # Already here, no record → close
    hyprctl dispatch closewindow address:$WIN_ADDR
fi

