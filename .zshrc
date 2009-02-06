#!/bin/zsh

# This file is sourced only for interactive shells. It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#
# Global Order: zshenv, zprofile, zshrc, zlogin


autoload -U compinit zrecompile

zsh_cache="${HOME}/.zsh_cache"
mkdir -p $zsh_cache

if [ $UID -eq 0 ]; then
    compinit
else
    compinit -d $zsh_cache/zcomp-$HOST

    for f in ~/.zshrc $zsh_cache/zcomp-$HOST; do
            zrecompile -p $f && rm -f $f.zwc.old
    done
fi

setopt extended_glob
for zshrc in ~/.zsh/rc.d/[0-9][0-9]*[^~] ; do
    source $zshrc
done

