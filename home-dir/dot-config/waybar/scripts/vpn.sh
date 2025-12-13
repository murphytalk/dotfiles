#!/bin/bash
toggle=$1

if [ ! -z "$toggle" ]; then
    ~/work/home-server/vpn/wireguard/wireguard.sh
fi

if  ifconfig | grep -q "peer_desktop"; then
    on="yes"
else
    on="no"
fi

if [ "$on" = "yes" ]; then
    printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "" "VPN: On" "on"
else
    printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "" "VPN: Off" "off"
fi

