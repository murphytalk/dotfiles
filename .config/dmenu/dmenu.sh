#!/bin/sh
# if this script is called with a parameter "-c" then the cach menu item file will be created
# otherwise dmenu will be called and selected app will be launched
#

ROOT=`dirname $0`

MENUFILE="$ROOT/menu"
GEN_CMD="$ROOT/dmenu.py"
CACHE="$ROOT/cache"

populate_menu(){
    #$1 menu file
    #$2 path seperated by :
    path=$2
    cat $1
    for i in `echo $path|sed 's/:/\n/g'|uniq`;do
        for f in $i/*;do
            if [[ -f $f && -x $f ]];then
                echo `basename $f`
            fi
        done
    done
}

gen_cache(){
    populate_menu $MENUFILE $PATH|sed "/^#/d"|sed "s/[[:blank:]].*//" > $CACHE
}

if [ -z $1 ];then
    if [ ! -e $CACHE ];then
        gen_cache
    fi
    #select=`cat $CACHE|dmenu -p "Launch:" -nb black -nf gray -sb #000000 -sf #aaaaff -fn snap`
    select=`cat $CACHE|dmenu -p "Launch:" -nb black -nf gray -fn snap`
    cmd=`$GEN_CMD $MENUFILE $select`
    echo $cmd
#    echo "select=$select" >> /tmp/cmd
#    echo "cmd=$cmd" >> /tmp/cmd
    exec $cmd
elif [ $1 == "c" ];then
    echo "generating menu cache"
    gen_cache
fi
