#!/bin/bash
toggle=$1
DEVICE="00:02:3C:29:3C:98" # Createive D200
DEVICE_NAME="Creative D200"

on_off=$(bluetoothctl info $DEVICE | grep 'Connected:' | sed 's/.*C.*: *\(.*\)$/\1/g')
if [ "$on_off" = "no" ]; then
  cmd=connect
else
  cmd=disconnect
fi

if [ ! -z "$toggle" ]; then
  notify-send "Bluetooth Speaker" "$cmd"ting
  bluetoothctl $cmd $DEVICE >/dev/null
fi

on_off=$(bluetoothctl info $DEVICE | grep 'Connected:' | sed 's/.*C.*: *\(.*\)$/\1/g')
if [ "$on_off" = "no" ]; then
  if [ ! -z "$toggle" ]; then
    notify-send "Bluetooth Speaker" " Disconnected"
  fi
  printf '{"text":"%s","tooltip":"%s: %s","class":"%s"}\n' "󰓄" "$DEVICE_NAME" "Disconnected" "off"
else
  if [ ! -z "$toggle" ]; then
    notify-send "Bluetooth Speaker" " Connected"
  fi
  printf '{"text":"%s","tooltip":"%s: %s","class":"%s"}\n' "󰦢" "$DEVICE_NAME" "Connected" "on"
fi
