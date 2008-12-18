# This file is sourced only for interactive shells. It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#
# Global Order: zshenv, zprofile, zshrc, zlogin

READNULLCMD=${PAGER:-/usr/bin/pager}

# Limits
ulimit -c unlimited
ulimit -d unlimited
ulimit -s unlimited
ulimit -m unlimited

# Options
setopt   notify autolist
setopt   longlistjobs pushd_silent
setopt   histignoredups
setopt   extendedglob rcquotes mailwarning csh_null_glob
setopt   always_to_end list_packed
#setopt   warn_create_global
unsetopt bgnice equals

# Key binds
if [[ "$TERM" != emacs ]]; then
[[ -z "$terminfo[kdch1]" ]] || bindkey -M emacs "$terminfo[kdch1]" delete-char
[[ -z "$terminfo[khome]" ]] || bindkey -M emacs "$terminfo[khome]" beginning-of-line
[[ -z "$terminfo[kend]" ]] || bindkey -M emacs "$terminfo[kend]" end-of-line
[[ -z "$terminfo[kich1]" ]] || bindkey -M emacs "$terminfo[kich1]" overwrite-mode
[[ -z "$terminfo[kdch1]" ]] || bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
[[ -z "$terminfo[khome]" ]] || bindkey -M vicmd "$terminfo[khome]" vi-beginning-of-line
[[ -z "$terminfo[kend]" ]] || bindkey -M vicmd "$terminfo[kend]" vi-end-of-line
[[ -z "$terminfo[kich1]" ]] || bindkey -M vicmd "$terminfo[kich1]" overwrite-mode

[[ -z "$terminfo[cuu1]" ]] || bindkey -M viins "$terminfo[cuu1]" vi-up-line-or-history
[[ -z "$terminfo[cuf1]" ]] || bindkey -M viins "$terminfo[cuf1]" vi-forward-char
[[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" vi-up-line-or-history
[[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" vi-down-line-or-history
[[ -z "$terminfo[kcuf1]" ]] || bindkey -M viins "$terminfo[kcuf1]" vi-forward-char
[[ -z "$terminfo[kcub1]" ]] || bindkey -M viins "$terminfo[kcub1]" vi-backward-char

# ncurses fogyatekos
[[ "$terminfo[kcuu1]" == "O"* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" vi-up-line-or-history
[[ "$terminfo[kcud1]" == "O"* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" vi-down-line-or-history
[[ "$terminfo[kcuf1]" == "O"* ]] && bindkey -M viins "${terminfo[kcuf1]/O/[}" vi-forward-char
[[ "$terminfo[kcub1]" == "O"* ]] && bindkey -M viins "${terminfo[kcub1]/O/[}" vi-backward-char
[[ "$terminfo[khome]" == "O"* ]] && bindkey -M viins "${terminfo[khome]/O/[}" beginning-of-line
[[ "$terminfo[kend]" == "O"* ]] && bindkey -M viins "${terminfo[kend]/O/[}" end-of-line
[[ "$terminfo[khome]" == "O"* ]] && bindkey -M emacs "${terminfo[khome]/O/[}" beginning-of-line
[[ "$terminfo[kend]" == "O"* ]] && bindkey -M emacs "${terminfo[kend]/O/[}" end-of-line
fi

bindkey -e

# Completions
zstyle ':completion:*::::' completer _expand _complete _ignored #_approximate
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

binary_files='*.(o|a|so|aux|dvi|swp|fig|bbl|blg|bst|idx|ind|out|toc|class|pdf|ps|hi|pyc|lo|la)'

zstyle ':completion:*:javac:*' files '*.java'
zstyle ':completion:*:vi:*'    ignored-patterns ${binary_files}
zstyle ':completion:*:vim:*'   ignored-patterns ${binary_files}
zstyle ':completion:*:gvim:*'  ignored-patterns ${binary_files}
zstyle ':completion:*:less:*'  ignored-patterns ${binary_files}
zstyle ':completion:*:zless:*' ignored-patterns ${binary_files}
zstyle ':completion:*:xpdf:*' files '*.pdf'
zstyle ':completion:*:tar:*' files '*.tar|*.tgz|*.tz|*.tar.Z|*.tar.bz2|*.tZ|*.tar.gz'

#zstyle ’:completion:*’ use-cache on
#zstyle ’:completion:*’ cache-path ~/.zsh/cache

zstyle ':completion:*' users

autoload run-help

python_path=($HOME/local/lib/python2.5/site-packages $python_path)
fpath=($HOME/.zsh/functions $fpath)

ldpath=($HOME/local/lib $ldpath)
python_path=($HOME/local/lib/python2.5/site-packages $HOME/local/lib/python2.4/site-packages $python_path)

cdpath+=~/Work/projects
path=(~/local/bin $path)

autoload -Uz $HOME/.zsh/functions/*(-.:t)
autoload -U compinit
compinit

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

cd() { builtin cd $* && ls }
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }
info()   { /usr/bin/info --subnodes --output - $1 2>/dev/null | less}

case $TERM in xterm*)
    precmd () {
        print -Pn "\e]0;%n@%m: %~\a"
    }
    preexec () {
        print -Pn "\e]0;$1\a"
    }
    ;;
esac

#autoload colors
#colors
#setopt promptsubst
#export PROMPT=$'%(#|$fg_bold[red]|$fg_bold[green])%n@%m:%5~>%{\e[0m%} '
#export RPROMPT=$'$(src_control_info) %D{%Y-%m-%d (%H:%M)}'

export PROMPT=$'%{\e[1;%(#|31|32)m%}%n@%m:%5~>%{\e[0m%} '
export RPROMPT=$'%D{%Y-%m-%d (%H:%M)}'
export TEXINPUTS=$HOME/code/mine/code/latex:
export BSTINPUTS=$HOME/code/mine/code/latex:
export spot0='0014.4F01.0000.4519'
export spot1='0014.4F01.0000.1F88'
export spot2='0014.4F01.0000.1F9A'

alias phone='obexftp -b 00:19:C0:C8:00:A1'
alias gdb='libtool --mode=execute gdb'

case $(hostname --fqdn) in
    *arc.nasa.gov)
        IRGPKG=/irg/packages/${(L)$(echo $(uname -m)_$(uname -s)_gcc$(gcc -dumpversion | cut -f-2 -d .))}
        ;;
esac
