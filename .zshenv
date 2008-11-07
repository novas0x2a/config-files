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

path+=/opt/vmware/bin

export HISTSIZE=200
export DIRSTACKSIZE=20
export SAVEHIST='90'
export HISTFILE=~/.zsh_history
export LESS="-c -M -S -i -f -R"
#export LESSCHARSET="utf-8"
export VISUAL='/usr/bin/vim'
export BROWSER='firefox'
export TEXDOCVIEW_html="firefox %s"
export TEXDOCVIEW_dvi="kdvi %s"
export TEXDOCVIEW_pdf="kpdf %s"

zmodload -ab zsh/pcre pcre_compile

# tie LD_LIBRARY_PATH to the array ldpath
export -TU LD_LIBRARY_PATH ldpath
export -TU PYTHONPATH python_path

export ISISROOT=$HOME/Work/src/isis3/isis
export ISIS3DATA=$HOME/Work/src/isis3/data
