#!/bin/bash
toggle=$1
status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')
if [ "$status" = "yes" ]; then
    if [ ! -z "$toggle" ]; then
        bluetoothctl power off
    fi
    echo ""
else
    if [ ! -z "$toggle" ]; then
        bluetoothctl power on
    fi
    echo ""
fi

