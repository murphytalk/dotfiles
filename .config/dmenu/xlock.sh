#!/bin/sh
LOG=~/tmp/xlock.log
ERR=~/tmp/xlock.err
xlock -modelist "all,-juggle" -font -adobe-helvetica-medium-r-*-*-*-240-*-*-*-*-*-* 1>$LOG 2>$ERR
#-adobe-courier-medium-r-*-*-*-180-*-*-*-*-*-*
