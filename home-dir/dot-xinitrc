xset +fp /usr/share/fonts/local
xset fp rehash
xrdb ~/.Xresources
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
fcitx&
#export GTK_IM_MODULE=ibus
#export XMODIFIERS=@im=ibus
#export QT_IM_MODULE=ibus
#ibus-daemon -drx
if [ -z "$WM" ];then
	#WM=awesome
	WM=startxfce4
else
	xbindkeys
fi
#xrandr --output DVI-I-1 --rotate left
urxvtd -q -o -f
exec $WM

