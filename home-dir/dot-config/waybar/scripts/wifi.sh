#/usr/bin/env bash

#sudo modprobe -r iwlwifi
#sudo modprobe iwlwifi
rfkill unblock wifi
xdg-terminal-exec --app-id=my.tui.popup --title=wifi impala
