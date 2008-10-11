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

# Calculate the trayer height (assuming xmobar font size is constant)
calc=$(xdpyinfo| grep dimension | expand | sed -e 's/ \+/ /g' | cut -d ' ' -f 3,5 --output-delimiter x | cut -d x -f 2,4 --output-delimiter=/).0
height=$(echo 'scale=5;' $calc '* 3.93 + 2' | bc | cut -d . -f 1)

trayer --edge bottom --align right --widthtype request --heighttype pixel --height $height --SetDockType true --SetPartialStrut true &

xscreensaver -no-splash&

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
