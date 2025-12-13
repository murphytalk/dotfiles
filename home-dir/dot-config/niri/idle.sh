#!/bin/sh
# Lightweight idle script for niri using swayidle.

# This script requires `swayidle` and `swaylock`.
# On Gentoo, you can emerge gui-wm/sway and x11-misc/swaylock.

# - After 15 minutes (900s), it locks the screen and turns off monitors.
# - After 30 minutes (1800s), it suspends the system.
# - It also locks the screen before the system sleeps for any other reason.

exec swayidle -w \
  timeout 900 'swaylock' \
  timeout 1800 'sudo systemctl suspend' \
  before-sleep 'swaylock'
