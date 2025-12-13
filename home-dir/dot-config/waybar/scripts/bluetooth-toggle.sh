#!/bin/bash
toggle=$1
status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')
if [ "$status" = "yes" ]; then
  if [ ! -z "$toggle" ]; then
    bluetoothctl power off
  fi
  printf '{"text":"%s","tooltip":"%s"}\n' "" "Bluetooth: On"
else
  if [ ! -z "$toggle" ]; then
    bluetoothctl power on
  fi
  printf '{"text":"%s","tooltip":"%s"}\n' "󰂲" "Bluetooth: Off"
fi
