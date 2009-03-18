autoload -Uz $HOME/.zsh/functions/*(-.:t)
alias ls='ls -lh --color=auto --show-control-chars'
alias grep='LC_ALL=C grep --color=auto -I'
alias dir='ls'
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
alias debug-emerge="FEATURES=\"nostrip splitdebug\" CFLAGS=\"\$(portageq envvar CFLAGS) \$CFLAGS -O0 -ggdb\" CXXFLAGS=\"\$(portageq envvar CXXFLAGS) \$CXXFLAGS -O0 -ggdb\" sudo emerge"
alias gdb='libtool --mode=execute gdb'
alias cgdb='libtool --mode=execute cgdb'

cd() { builtin cd $* && ls }
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }
info()   { /usr/bin/info --subnodes --output - $1 2>/dev/null | less}

