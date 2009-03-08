case $TERM in xterm*|rxvt*)
    precmd () {
        print -Pn "\e]0;%n@%m: %~\a"
    }
    preexec () {
        print -Pn "\e]0;$1\a"
    }
    ;;
esac

export PROMPT=$'%{\e[1;%(#|31|32)m%}%n@%m:%5~>%{\e[0m%} '
export RPROMPT=$'%(?..[%{\e[1;31m%}%?%{\e[0m%}])$(__git_ps1)'

