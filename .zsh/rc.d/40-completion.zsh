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

zstyle ':completion::complete:*' use-cache 1

zstyle ':completion:*' users

local _myhosts
_myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )

zstyle ':completion:*:hosts' hosts $_myhosts



autoload run-help

autoload -Uz compinit bashcompinit
compinit -i
bashcompinit -i

if which kubectl &>/dev/null; then
    compdef k=kubectl
fi

if which pipx &>/dev/null; then
    eval "$(register-python-argcomplete pipx)"
fi
