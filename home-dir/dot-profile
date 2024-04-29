#sourced by bash and zsh

# Detect distro
[ -d /etc/pacman.d ] && DISTRO_ARCH=y
[ -d /etc/xbps.d ] && DISTRO_VOID=y
if [[ $(which emerge) == "/usr/bin/emerge" ]];then DISTRO_GENTOO=y;fi

uname | grep Microsoft > /dev/null && DISTRO_WSL=y
uname | grep Darwin > /dev/null && IS_MAC=y

which docker-compose > /dev/null
if [ $? -eq 0 ];then
    alias dc=docker-compose
fi

[ -f $HOME/.alias ] && source $HOME/.alias

# distro specific
#
if [ ! -z "$IS_MAC" ];then
    # BSD ls's default blue color for directory is unreadlable !
    # to override this https://github.com/sorin-ionescu/prezto/blob/master/modules/utility/init.zsh#L97
    export LSCOLORS=Exfxcxdxbxegedabagacad
fi

if [ ! -z "$DISTRO_GENTOO" ];then
    function c(){
        sudo emerge --depclean $1 -vp
    }
    [ -f $HOME/.alias.gentoo ] && source $HOME/.alias.gentoo
fi

if [ ! -z "$DISTRO_ARCH" ];then
    #ArchLinux
    [ -f $HOME/.alias.arch ] && source $HOME/.alias.arch
    export PATH=$PATH:/usr/lib/gettext
fi

if [ -z "$DISTRO_WSL" ];then
    # is NAS mounted ?
    vault=$(grep "nas.*volume1.Vault" /proc/mounts |sed 's/.* \(\/mnt.*\) nfs .*/\1/g')
    if [ ! -z "$vault" ];then
        export V=$vault
    fi
else
    export DISPLAY=:0.0
    # exclude scoop path
    a=("${(@s/:/)PATH}")
    for i in $a
    do
        if ! echo $i|grep scoop > /dev/null;then
            newpath="$newpath:$i"
        fi
    done
    export PATH=$newpath
    unset a
    unset newpath
fi

#if [ ! -z "$DISTRO_VOID" ];then
#    #VoidLinux
#    alias xi='sudo xbps-install -S'
#    alias xu='sudo xbps-install -Su'
#    alias xq='sudo xbps-query'
#    alias xr='sudo xbps-remove'
#fi


EDITOR=vim
