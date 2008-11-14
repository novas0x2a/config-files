#!/bin/sh

isrunning() {
    pidof $1 > /dev/null
}

try() {
    if isrunning $(basename $1); then
        echo "$1 already running."
        return 0
    fi

    test x"`which $1 2>/dev/null`" != x""
    if test $? -eq 0; then
        $* &
        sleep 0.1
        if ! isrunning $1; then
            echo "$1 isn't running. failed?"
            return 1
        fi
    else
        echo "failed to find $1" >&2
        return 1
    fi
    return 0
}

try_eval() {
    test x"`which $1 2>/dev/null`" != x""
    ret=$?
    if test $ret -eq 0; then
        eval `$*`
        if test $? -ne 0; then
            echo "$1 failed."
        fi
    else
        echo "failed to find $1" >&2
    fi
    return $ret
}

cat /dev/null .Xdefaults | xrdb -nocpp -merge -

test -r $HOME/.Xmodmap && xmodmap $HOME/.Xmodmap

if test x"$DBUS_SESSION_BUS_ADDRESS" = x""; then
    try_eval dbus-launch --sh-syntax --exit-with-session
fi

nvidia-settings -a InitialPixmapPlacement=2 -a GlyphCache=1

if test x"$GNOME_KEYRING_PID" = x""; then
    try_eval gnome-keyring-daemon
    export GNOME_KEYRING_PID
    export GNOME_KEYRING_SOCKET
    export SSH_AUTH_SOCK
fi

if test x"$GPG_AGENT_INFO" = x""; then
    try_eval seahorse-agent
fi


# Calculate the trayer height (assuming xmobar font size is constant)
get_trayer_height() {
    local calc
    calc=$(xdpyinfo| grep dimension | expand | sed -e 's/ \+/ /g' | cut -d ' ' -f 3,5 --output-delimiter x | cut -d x -f 2,4 --output-delimiter=/).0
    echo 'scale=5;' $calc '* 3.93' | bc | cut -d . -f 1
}

try trayer --edge bottom --align right --widthtype request --heighttype pixel \
           --height $(get_trayer_height) --SetDockType true --SetPartialStrut true &
try nm-applet --sm-disable


try gnome-power-manager
try bluetooth-applet
try /usr/lib/gnome-volume-manager/gnome-volume-manager || try ivman || echo "No volume manager!"
try system-config-printer-applet
try update-notifier
try mail-notification
try twitux
try pidgin -n

if test -z "$VNCSESSION"; then
    # No screensaver is a problem (no screen lock) so warn about it
    try gnome-screensaver || try xscreensaver -no-splash || try xmessage "No screensaver!"
fi

xmonad

killall ivman
