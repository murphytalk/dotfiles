#!/bin/bash
toggle=$1
DEVICE="00:02:3C:29:3C:98" # Createive D200

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
  echo "󰓄"
else
  if [ ! -z "$toggle" ]; then
    notify-send "Bluetooth Speaker" " Connected"
  fi
  echo "󰦢"
fi
