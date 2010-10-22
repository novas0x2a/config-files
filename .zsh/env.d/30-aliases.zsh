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
alias -s desktop=run-desktop
alias apt-name='apt-cache search --names-only'
alias apt-find='apt-cache search'
alias open='gnome-open'
alias debug-emerge="USE=\"debug\" FEATURES=\"nostrip splitdebug installsources\" CFLAGS=\"\$(portageq envvar CFLAGS) \$CFLAGS -O0 -ggdb\" CXXFLAGS=\"\$(portageq envvar CXXFLAGS) \$CXXFLAGS -O0 -ggdb\" sudo emerge"
alias lrun='libtool --mode=execute'
alias gdb='libtool --mode=execute gdb'
alias cgdb='libtool --mode=execute cgdb'
alias track_smart='sudo smartctl --attributes /dev/sda > $HOME/smart/$(date +''%Y-%m-%d_%H-%M-%S'')'

mike-tunnel() {
    SERVER=${1:-www.fluffypenguin.org}
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

gkeyword() {echo $1 | sudo tee -a /etc/portage/package.keywords}

if [[ -f $HOME/bin/hub ]]; then
    function git(){hub $@}
fi

cd() { builtin cd $* && ls }
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }
info()   { /usr/bin/info --subnodes --output - $1 2>/dev/null | less}

function current_datestamp() {date +"%Y-%m-%d_%H-%M_%S"}
