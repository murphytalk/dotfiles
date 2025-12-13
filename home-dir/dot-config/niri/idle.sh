#!/bin/sh
# Lightweight idle script for niri using swayidle.

# This script requires `swayidle` and `swaylock`.
# On Gentoo, you can emerge gui-wm/sway and x11-misc/swaylock.

# - After 15 minutes (900s), it locks the screen and turns off monitors.
# - After 30 minutes (1800s), it suspends the system.
# - It also locks the screen before the system sleeps for any other reason.

# Initialize flags
run_in_background=false
no_sleep=false

# Parse arguments using a loop
while [ $# -gt 0 ]; do
  case "$1" in
    -run)
      run_in_background=true
      shift
      ;;
    -no-sleep)
      no_sleep=true
      shift
      ;;
    *)
      # Ignore unknown arguments
      shift
      ;;
  esac
done

# Kill any running swayidle processes
pkill swayidle 2>/dev/null

# Determine which command to run based on flags
if [ "$run_in_background" = true ] && [ "$no_sleep" = true ]; then
  # Run swayidle in background without sleep timeout
  swayidle -w \
    timeout 1800 'swaylock' \
    before-sleep 'swaylock' &
  # Exit the script after starting swayidle in background
  exit 0
elif [ "$run_in_background" = true ]; then
  # Run swayidle in background with default behavior
  swayidle -w \
    timeout 1800 'swaylock' \
    timeout 3600 'sudo systemctl suspend' \
    before-sleep 'swaylock' &
  # Exit the script after starting swayidle in background
  exit 0
elif [ "$no_sleep" = true ]; then
  # Execute swayidle without the 3600 second timeout for suspension
  exec swayidle -w \
    timeout 1800 'swaylock' \
    before-sleep 'swaylock'
else
  # Default behavior
  exec swayidle -w \
    timeout 1800 'swaylock' \
    timeout 3600 'sudo systemctl suspend' \
    before-sleep 'swaylock'
fi
