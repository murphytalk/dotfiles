if test -e $HOME/.alias
    source $HOME/.alias
end

if uname -r | grep -i microsoft >/dev/null
    set WSL 1
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
end

setenv JAVA_HOME /opt/openjdk-bin-11.0.9_p11/
set PATH  ~/.local/bin/ $PATH /opt/local/flutter/bin
