#!/bin/bash
# Check if clipboard contains an image
if wl-paste --list-types | grep -q "image/png"; then
  FILENAME="$HOME/Pictures/Screenshot_$(date +%Y%m%d_%H%M%S).png"
  wl-paste >"$FILENAME"
  notify-send "Clipboard saved" "$FILENAME"
else
  notify-send "No image in clipboard"
fi
