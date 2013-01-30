# If sudoing, a virtualenvwrapper log rotation could end up making the hook.log
# owned by root.
if [ -z $SUDO_USER ]; then
    if which virtualenvwrapper.sh &>/dev/null; then
        . virtualenvwrapper.sh
    fi
fi
