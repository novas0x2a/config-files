cat /dev/null .Xdefaults | xrdb -nocpp -merge -

test -r $HOME/.Xmodmap && xmodmap $HOME/.Xmodmap

# Use dbus-launch if installed.
if test x"$DBUS_SESSION_BUS_ADDRESS" = x""; then
    dbuslaunch=`which dbus-launch`
    if test x"$dbuslaunch" != x"" -a x"$dbuslaunch" != x"no"; then
        eval `$dbuslaunch --sh-syntax --exit-with-session`
    fi
fi

#eval $(gnome-keyring-daemon)
#export GNOME_KEYRING_PID
#export GNOME_KEYRING_SOCKET
#export SSH_AUTH_SOCK

gnome-power-manager &

trayer --edge bottom --align right --widthtype request --heighttype pixel --height 18 --SetDockType true --SetPartialStrut true &

gnome-screensaver &

bluetooth-applet --singleton &
/usr/lib/gnome-volume-manager/gnome-volume-manager --sm-disable &
nm-applet --sm-disable &
/usr/bin/system-config-printer-applet &
update-notifier &
mail-notification &

twitux &
pidgin -n&

xmonad

#kill ${GNOME_KEYRING_PID}
