#!/bin/bash
toggle=$1
DEVICE="00:02:3C:29:3C:98" # Creative D200
DEVICE_NAME="Creative D200"

device_sink="bluez_output.00_02_3C_29_3C_98.1"

if pactl list short sinks 2>/dev/null | grep -q "$device_sink"; then
  on_off="yes"
else
  on_off="no"
fi

if [ "$on_off" != "yes" ]; then
  cmd=connect
else
  cmd=disconnect
fi

if [ ! -z "$toggle" ]; then
  notify-send "Bluetooth Speaker" "${cmd}ing"
  bluetoothctl $cmd $DEVICE >/dev/null 2>&1
fi

device_sink="bluez_output.00_02_3C_29_3C_98.1"
if pactl list short sinks 2>/dev/null | grep -q "$device_sink"; then
  on_off="yes"
else
  on_off="no"
fi

if [ "$on_off" != "yes" ]; then
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