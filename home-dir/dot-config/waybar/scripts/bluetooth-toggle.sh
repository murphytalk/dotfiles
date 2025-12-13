#!/bin/bash
toggle=$1
status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')
if [ "$status" = "yes" ]; then
  if [ ! -z "$toggle" ]; then
    bluetoothctl power off
  fi
  printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "" "Bluetooth: On" "on"
else
  if [ ! -z "$toggle" ]; then
    bluetoothctl power on
  fi
  printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "󰂲" "Bluetooth: Off" "off"
fi
