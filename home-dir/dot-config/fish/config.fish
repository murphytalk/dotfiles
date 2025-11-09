if test -e $HOME/.alias
    source $HOME/.alias
end

if /usr/bin/uname -r | /bin/grep -i microsoft >/dev/null
    set WSL 1
    setenv AWS_CPP_SDK_DIR /usr/local
end

if test -d /etc/portage
    set DISTRO_GENTOO 1

    function c
        sudo emerge --depclean $argv -vp
    end
    if test -e $HOME/.alias.gentoo
        source $HOME/.alias.gentoo
    end

    function tuu
        set PORTFS /var/tmp/portage
        if not grep $PORTFS /proc/mounts > /dev/null
            sudo mount -t tmpfs -o size=8G,uid=portage,gid=portage,mode=775,noatime tmpfs $PORTFS
        end
        sudo emerge -uDU --keep-going --with-bdeps=y @world
        sudo umount $PORTFS
        set PORTFS
    end

    setenv JAVA_HOME /opt/openjdk-bin-11.0.9_p11
    setenv FLUTTER_HOME /mnt/extra/apps/flutter
    setenv MY_ANDROID_SDK_HOME /mnt/extra/apps/android-sdk
    setenv MY_ANDROID_NDK $MY_ANDROID_SDK_HOME/ndk-bundle/
end

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	~/.cargo/bin/yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end


function f
    cd ~/work/finance_scraper
    . venv/bin/activate.fish
    python -m console.shell
    deactivate
end

set PATH ~/go/bin  ~/.cargo/bin ~/.local/bin/ $FLUTTER_HOME/bin $MY_ANDROID_SDK_HOME/platform-tools/ /home/linuxbrew/.linuxbrew/bin $PATH

function gemini-glow
    gemini | glow
end

alias p='fzf --preview "bat --color=always {}"'
zoxide init fish | source
#oh-my-posh init fish | source
starship init fish | source
fzf --fish | source

# The next line updates PATH for the Google Cloud SDK.
#if [ -f '/home/mu/temp/google-cloud-sdk/path.fish.inc' ]; . '/home/mu/temp/google-cloud-sdk/path.fish.inc'; end

alias t='todo.sh -d /mnt/d/Syncthing/mobile/todo/todo.cfg'

set -x XDG_CURRENT_DESKTOP Hyprland
set -x XDG_SESSION_TYPE wayland
# set -x BROWSER firefox
set -x FILE_MANAGER spacefm
alias open="xdg-open"



set XMODIFIERS @im=fcitx

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
