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

autoload -U compinit
compinit

