# If sudoing, a virtualenvwrapper log rotation could end up making the hook.log
# owned by root.
if [ -z $SUDO_USER ]; then
    if which virtualenvwrapper_lazy.sh &>/dev/null; then
        . virtualenvwrapper_lazy.sh
    fi
    export PROJECT_HOME=$PROJECT_DIR
fi
