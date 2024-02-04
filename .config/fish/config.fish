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
set PATH  ~/.local/bin/ $FLUTTER_HOME/bin $MY_ANDROID_SDK_HOME/platform-tools/ $PATH
