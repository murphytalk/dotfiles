#!/bin/sh
DAEMON="urxvtd"
CLIENT="urxvtc"

if ! (ps axj | grep -v grep | grep -q $DAEMON) ;then
	$DAEMON -q -f
fi

if [ -z $1 ];then
	$CLIENT
else
	$CLIENT -e $1
fi
