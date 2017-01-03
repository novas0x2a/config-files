# This file is sourced on all invocations of the shell.
# If the -f flag is present or if the NO_RCS option is
# set within this file, all other initialization files
# are skipped.
#
# This file should contain commands to set the command
# search path, plus other important environment variables.
# This file should not contain commands that produce
# output or assume the shell is attached to a tty.
#
# Global Order: zshenv, zprofile, zshrc, zlogin
#

PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    #echo "starting profile"
    zmodload zsh/zprof # Output load-time statistics
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>"${XDG_CACHE_HOME:-$HOME/tmp}/zsh_startup.$$"
    setopt xtrace prompt_subst
fi

export HISTSIZE=2000
export DIRSTACKSIZE=20
export SAVEHIST=2000
export KEYTIMEOUT=1
export HISTFILE=~/.zsh_history
export LESS="-c -M -S -i -f -R"
#export LESSCHARSET="utf-8"
export VISUAL='vim'
export EDITOR='vim'
export BROWSER='chromium'
export TEXDOCVIEW_html="chromium %s"
export TEXDOCVIEW_dvi="kdvi %s"
export TEXDOCVIEW_pdf="kpdf %s"
export OOO_FORCE_DESKTOP=gnome

type -p dircolors &>/dev/null && eval `dircolors -b`

zmodload -ab zsh/pcre pcre_compile

# tie LD_LIBRARY_PATH to the array ldpath
export -U path
case $(uname -s) in
    Linux)  export -TU LD_LIBRARY_PATH ldpath;;
    Darwin) export -TU DYLD_FALLBACK_LIBRARY_PATH ldpath;;
    *) echo "Don't know how to setup ldpath for $(uname -s)";;
esac

export -TU PKG_CONFIG_PATH pkg_path
export -TU PERL5LIB perl_path

export SHELL=/bin/zsh
export MY_TERM=xterm

setopt extended_glob

for zshrc in ~/.zsh/env.d/[0-9][0-9]*[^~] ; do
    source $zshrc
done


if [[ -f "${HOME}/.gentoo/java-env-classpath" ]]; then
    source ${HOME}/.gentoo/java-env-classpath
fi

[[ -r $HOME/.zshenv.local ]] && source $HOME/.zshenv.local

if [[ "$PROFILE_STARTUP" == true && ! -o interactive ]]; then
    #echo "ending profile in noninteractive mode"
    zprof
    unsetopt xtrace
    exec 2>&3 3>&-
fi
