#
# ~/.bashrc
#
#set -x  #for debug
# Check if it is Windows Linux Subsystem

export PATH=/opt/npm_global/bin:$PATH
# If not running interactively, do not do anything
[[ $- != *i* ]] && return

if uname -a | grep Microsoft >/dev/null;then
    WSL=1
fi

# Check distro
if [ -f /etc/os-release ];then
    if grep -i opensuse /etc/os-release >/dev/null;then
        OPENSUSE=1
    fi
fi

[ -f ~/.profile ] && source ~/.profile

# the legacy stuff for bash, only when fish is not installed
if [ ! -x /bin/fish ];then
   PS1='[\u@\h \W]\$ '

   if ! echo $PS1 | grep git_ps1 >/dev/null;then
       [ -f /etc/profile.d/git-prompt.sh ] && source /etc/profile.d/git-prompt.sh
       fi
fi

which tmux > /dev/null
if [ $? -ne 0 ];then
    echo Install tmux !
    exit 0
fi

# I prefer to setup tmux as login shell
# the following is a workaround if default shell cannot be changed. .e.g Windows Linux Subsystem
if [[ -z "$TMUX" ]];then
    if [[ $WSL == 1 && $OPENSUSE == 1 ]];then
        # OpenSUSE's tmux adpoting the new rule to create socket under /run instead of /var/run
        # but WSL nukes all permission changes to /run when it shutsdown and when it starts /run is always
        # can only be modified by root
        # see https://github.com/tmux/tmux/issues/1092
        sudo chmod 0777 /run
        [ ! -d /run/tmux ] && mkdir /run/tmux
    fi
    if [ ! -L ~/.tmux.conf ];then
        if [ -L ~/.bashrc ];then
            a=`ls -all ~/.bashrc | sed 's/.* -> \(.*\)/\1/g'`
            p=`dirname $a`
            ln -s $p/.tmux.conf ~/.tmux.conf
        fi
    fi
    #tmux_sessions=$(tmux ls)
    #if [ -z "$tmux_sessions" ];then
    #     exec tmux attach -t $(echo $tmux_sessions|head -1|sed -r 's/([0-9]*):.*/\1/g')
    #else
    if pgrep tmux >/dev/null;then
       tmux ls
       [ -x /bin/fish ] && exec /bin/fish
    else
       echo Launching tmux
       exec tmux
    fi
fi
