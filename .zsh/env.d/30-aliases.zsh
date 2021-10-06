unsetopt ksh_autoload
autoload -U $HOME/.zsh/functions/*(-.:t)

if ls --help &>/dev/null; then
    # Coreutils ls
    alias ls='ls -lh --color=auto --show-control-chars'
else
    # BSD ls (broken...)
    alias ls='ls -lhG'
fi

alias grep='LC_ALL=C grep --color=auto -I'
alias todo='todo +children'
alias unob='perl -MO=Deparse'
alias dump-winexe='objdump -D -m i8086 -b binary'
#alias tree='tree -A'
alias vim='vim -p'
alias gvim='gvim -p'

alias '..'='cd ..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g W1='| awk ''{print $1}'''
alias -g W2='| awk ''{print $2}'''
alias -g W3='| awk ''{print $3}'''
alias -g W4='| awk ''{print $4}'''
alias -g W5='| awk ''{print $5}'''
alias -g W6='| awk ''{print $6}'''
alias -g W7='| awk ''{print $7}'''
alias -g W8='| awk ''{print $8}'''
alias -g W9='| awk ''{print $9}'''
alias -s desktop=run-desktop
alias apt-name='apt-cache search --names-only'
alias apt-find='apt-cache search'
alias open='xdg-open'
alias debug-emerge="USE=\"debug\" FEATURES=\"nostrip splitdebug installsources\" CFLAGS=\"\$(portageq envvar CFLAGS) \$CFLAGS -O0 -ggdb\" CXXFLAGS=\"\$(portageq envvar CXXFLAGS) \$CXXFLAGS -O0 -ggdb\" sudo emerge"
alias lrun='libtool --mode=execute'
alias gdb='libtool --mode=execute gdb'
alias cgdb='libtool --mode=execute cgdb'
alias track_smart='sudo smartctl --attributes /dev/sda > $HOME/smart/$(date +''%Y-%m-%d_%H-%M-%S'')'
alias screen='ln -sf ${SSH_AUTH_SOCK:-/dev/null} $HOME/.ssh/auth-sock; screen'
alias vimopen='xargs $SHELL -c '\''vim < /dev/tty "$0" "$@"'\'''
alias speakers='pacmd load-module module-tunnel-sink server=wheelbarrow-1'
alias speakers-off='pacmd unload-module module-tunnel-sink'

mike-tunnel() {
    SERVER=${1:-h00t.fluffypenguin.org}
    PORT=${2:-55555}
    set -x

    for i in {0..10}; do
        if pkill -u $USER -f "autossh.*${PORT}"; then
            sleep 1;
        else
            autossh -NfD ${PORT} -M0 ${SERVER} &!
            set +x
            return
        fi
    done
    echo "Failed to kill existing tunnel"
    set +x
}

gkeyword() {echo $1 | sudo tee -a /etc/portage/package.accept_keywords}
gunmask()  {gkeyword $1 && echo $1 | sudo tee -a /etc/portage/package.unmask}
guse()     {
    if [[ -d /etc/portage/package.use ]]; then
        echo "$@" | sudo tee -a /etc/portage/package.use/guse
    else
        echo "$@" | sudo tee -a /etc/portage/package.use
    fi
}

if type -p hub &>/dev/null; then
    function git(){hub $@}
fi

freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }
info()   { /usr/bin/info --subnodes --output - $1 2>/dev/null | less}

function current_datestamp() {date +"%Y-%m-%d_%H-%M_%S"}

governor() {
    if test -z "$1"; then
        for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
            local cpu=$(echo $i | cut -d / -f 6)
            echo "${cpu}: $(<$i)"
        done
    else
        for i in {0..7}; sudo cpufreq-set -r -g $1 -c $i
    fi
}

_homedir_root() {echo "${XDG_CONFIG_HOME:-$HOME/.config}/homedir_track/${1:?[$0 <repo>]}"}
homedir_public() {
    local root=$(_homedir_root public)
     git \
        --work-tree="$HOME" \
        --git-dir="$root/repo" \
        -c core.excludesfile="$root/gitignore" \
        -c core.attributesfile="$root/attributes" \
        "$@"
}
