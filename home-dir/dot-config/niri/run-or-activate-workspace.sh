#!/usr/bin/env bash
app=$(basename "$0")
app=${app%.*}

if [[ "$app" == "IKBR" ]]; then
  name="tws"
  app_exe=/mnt/extra/apps/tws/tws
elif [[ "$app" == "SWB" ]]; then
  name="thinkorswim"
  app_exe=/mnt/extra/apps/run-thinkorswim.sh
else
  echo "Unknown app $app"
  exit 1
fi

NIRI_SOCKET=$(ls /run/user/$(id -u)/niri.*.sock | head -n1) niri msg action focus-workspace $app

echo Finding $app instance $name
if ! ps axj | grep $name | grep -v grep >/dev/null; then
  echo laucnhing $app from $app_exe
  exec $app_exe
fi
