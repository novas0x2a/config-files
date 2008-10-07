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

binary_files='*.(o|a|so|aux|dvi|swp|fig|bbl|blg|bst|idx|ind|out|toc|class|pdf|ps|hi|pyc)'

# only java files for javac
zstyle ':completion:*:javac:*' files '*.java'
# no binary files for vi
zstyle ':completion:*:vi:*'    ignored-patterns ${binary_files}
zstyle ':completion:*:vim:*'   ignored-patterns ${binary_files}
zstyle ':completion:*:gvim:*'  ignored-patterns ${binary_files}
zstyle ':completion:*:less:*'  ignored-patterns ${binary_files}
zstyle ':completion:*:zless:*' ignored-patterns ${binary_files}

# pdf for xpdf
zstyle ':completion:*:xpdf:*' files '*.pdf'
# tar files
zstyle ':completion:*:tar:*' files '*.tar|*.tgz|*.tz|*.tar.Z|*.tar.bz2|*.tZ|*.tar.gz'

#zstyle ’:completion:*’ use-cache on
#zstyle ’:completion:*’ cache-path ~/.zsh/cache

#zstyle ’:completion:*:(all-|)files’ ignored-patterns ’(|*/)CVS’
#zstyle ’:completion:*:cd:*’ ignored-patterns ’(*/)#CVS’

#local _myhosts
#_myhosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*})
#zstyle ':completion:*' hosts $_myhosts
zstyle ':completion:*' users

autoload run-help

autoload -U compinit
compinit

alias ls='ls -lh --color=auto --show-control-chars'
alias grep='LC_ALL=C grep --color=auto'
alias dir='ls'
alias todo='todo +children'
alias unob='perl -MO=Deparse'
alias dump-winexe='objdump -D -m i8086 -b binary'
alias tree='tree -A'
alias vim='vim -p'
alias gvim='gvim -p'

alias '..'='cd ..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

alias apt-name='apt-cache search --names-only'
alias apt-find='apt-cache search'
alias open='gnome-open'

cd() {
    builtin cd $* && ls
}

freload() {
    while (( $# )); do; unfunction $1; autoload -U $1; shift; done
}

cvs-ignore-all() {
    for i in $(cvs update | grep '^?' | cut -d ' ' -f 2);
        echo $(basename $i) >> $(dirname $i)/.cvsignore
}

cvs-ignore() {
    for i in $argv
        echo $(basename $i) >> $(dirname $i)/.cvsignore
}

bigprint() {
    local args=$argv
    local len=${#args}
    echo
    for (( i=0; i<$len+6; i++ ))
        echo -n "*"
    echo
    echo "** $argv **"
    for (( i=0; i<$len+6; i++ ))
        echo -n "*"
    echo -ne "\n\n"
}

info()   { /usr/bin/info --subnodes --output - $1 2>/dev/null | less}
inode()  { for i in $argv; do stat $i | grep inode | cut -d " " -f 4; done}
mydate() { date +'%Y-%m-%d_%H-%M-%S'}
spell()  { echo $1 | aspell -a}

open-ports() {
    /usr/sbin/lsof -i |sed -e 's/ \+/ /g' | cut -d " " -f 1,7,8,9 | sort | uniq | sed -e 's/ /\t/g'
}

# ask-yn Question [default answer]
function ask-yn()
{
    while true; do
        echo -n $1
        if [[ -n "$2" ]]; then
            [[ $2 == 0 ]] && echo -n " (y/N)" || echo -n " (Y/n)"
        else
            echo -n " (y/n)"
        fi
        echo -n " "
        read ret
        case ${ret} in
            yes|Yes|y|Y) return 0;;
            no|No|n|N)   return 1;;
            "") [[ -n $2 ]] && { [[ $2 != 0 ]] && return 0 || return 1 };;
        esac
    done
}

assert() {
    eval "[[ $1 ]]" && return 0
    [[ -n "$2" ]] && echo $2 || echo "Assertion $1 failed"
    return 1
}

ask-int()
{
    assert "\"${(Pt)1[1,5]}\" == \"array\"" || return 1
    assert "${(P)#1} > 0" || return 1

    local i
    while true; do
        i=0
        for item in ${(P)1}; do
            i=$((i+1));
            echo "    $i) $item"
        done
        echo "x) Exit"
        echo
        echo -n "? "

        read ret
        if [[ $((ret+0)) == $ret && $ret -gt 0 && $ret -le $i ]]; then
            typeset -g REPLY=${${(P)1}[$ret]}
            return 0
        elif [[ $ret == 'x' ]]; then
            return 1
        fi

        echo "$ret out of range (1-$i)"
        echo
    done
}


pick-governor() {
    local -a govs
    local cpu
    for i in /sys/devices/system/cpu/cpu[0-9]/cpufreq; do
        cpu=$(echo $i | cut -d / -f 6)
        echo "$cpu :" $(<$i/scaling_governor)
    done
    govs=($(<$i/scaling_available_governors))
    ask-int govs || return
    echo "Switching to $REPLY"
    for i in /sys/devices/system/cpu/cpu[0-9]/cpufreq; do
        echo $REPLY | sudo tee $i/scaling_governor
    done
}

case $TERM in xterm*)
    precmd () {
        print -Pn "\e]0;%n@%m: %~\a"
    }
    preexec () {
        print -Pn "\e]0;$1\a"
    }
    ;;
esac

src_control_info() {
    for s in svn git; do
        data=""
        for t in branch version; do
            f=src_control_${s}_${t}
            type $f &>/dev/null && data+="$($f)"
        done
        if [[ -n $data ]]; then
            echo "${(U)s}[$data]"
            return
        fi
    done
}


src_control_git_branch() {
    echo ${$(git symbolic-ref HEAD 2>/dev/null)##refs/heads/}
}

src_control_svn_branch() {
    local info
    local -a match
    [[ -d .svn  ]] || return
    info="$(svn info 2>/dev/null)"
    if [[ -n $info ]]; then
        pcre_compile -m '^URL:\s+(.*?)$[.\n]*^Repository Root:\s+(.*?)$' && pcre_match "$info" && echo ${match[1]##$match[2]}
    fi
}

#setopt promptsubst
export PROMPT=$'%{\e[1;%(#|31|32)m%}%n@%m:%~>%{\e[0m%} '
#export RPROMPT=$'$(src_control_info) %D{%Y-%m-%d (%H:%M)}'
export RPROMPT=$'%D{%Y-%m-%d (%H:%M)}'

export TEXINPUTS=/home/mike/code/mine/code/latex:
export BSTINPUTS=/home/mike/code/mine/code/latex:
alias phone='obexftp -b 00:19:C0:C8:00:A1'
alias gdb='libtool --mode=execute gdb'
alias '...'='cd ../..'
alias '....'='cd ../../..'
alias '.....'='cd ../../../..'

path+=~/build/bin

gdata_auth() {
    local email passwd ret state
    echo -n 'Email? '
    read email
    state=$(stty -g)
    echo -n 'Password? '
    stty -echo
    read passwd
    stty "$state"
    echo
    ret=$(curl                                          \
         -f -s -S                                       \
         -d accountType=GOOGLE                          \
         -d "Email=$email"                              \
         -d "Passwd=$passwd"                            \
         -d service=cp                                  \
         -d source='fluffypenguin,gdatashellauth,0.1'   \
         https://www.google.com/accounts/ClientLogin)
    if [[ $? -ne 0 ]]; then
        echo "Failed."
        return
    fi
    eval $(echo $ret | grep '^Auth')
    echo 'Auth set: ' $Auth[1,5]...
}

gdata_get() {
    local url ret
    if [[ $# -lt 1 ]]; then
        echo "Usage: $0 feed_url [addl-opts]"
    fi
    ret=$(curl -f -s -S \
        -H "Authorization: GoogleLogin auth=$Auth" \
        $2                                         \
        $1)
    if [[ $? -ne 0 ]]; then
        echo "Failed."
        return
    fi
    echo $ret
}

gdata_email() {
    [[ $# -ne 1 ]] && return
    gdata_get  'http://www.google.com/m8/feeds/contacts/default/base?max-results=999999' | xpath -q -e "//entry[contains(title/text(),'$1')]/gd:email/@address"
}

computer() {
    local cmd
    [[ $# -ne 1 ]] && return
    case "$1" in
        "suspend")
            cmd=Suspend
            ;;
        "hibernate")
            cmd=Hibernate
            ;;
        *)
            return
            ;;
    esac

    dbus-send \
        --session \
        --dest=org.freedesktop.PowerManagement \
        --type=method_call \
        --print-reply \
        --reply-timeout=2000 \
    /org/freedesktop/PowerManagement \
    org.freedesktop.PowerManagement.$cmd
}

export spot0='0014.4F01.0000.4519'
export spot1='0014.4F01.0000.1F88'
export spot2='0014.4F01.0000.1F9A'
