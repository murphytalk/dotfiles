#!/bin/bash
# Lightweight idle script for niri using swayidle.

# Initialize flags
run_in_background=false
no_sleep=false

# Parse arguments using a loop
while [[ $# -gt 0 ]]; do
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

# Build arguments array
args=(-w timeout 600 'swaylock')
args+=(timeout 900 'wlopm --off *')

if [[ "$no_sleep" == "false" ]]; then
  args+=(timeout 1200 'sudo systemctl suspend')
fi

args+=(resume 'wlopm --on *')
args+=(before-sleep 'swaylock')

if [[ "$run_in_background" == "true" ]]; then
  swayidle "${args[@]}" &
else
  exec swayidle "${args[@]}"
fi
