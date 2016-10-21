local PROJECT_DIR=~/Projects

perl_path=($HOME/local/lib/perl5/site_perl $HOME/local/lib/perl5 $perl_path)

fpath=($HOME/.zsh/functions $fpath)
cdpath+=$PROJECT_DIR
path=(~/bin ~/.local/bin ~/local/bin /opt/local/bin $path)

if which gem &>/dev/null; then
    local rubydir=$(gem environment gemdir || true)
    if [[ -d $rubydir ]]; then
        path=("$rubydir/bin" $path)
    fi
fi

if which go &>/dev/null; then
    go_path="$HOME/local/vendor/go/$(go version | cut -d ' ' -f 3)"
    path+=($go_path[1]/bin)
    if test -d "$go_path/src"; then
        cdpath+=($go_path/src/*)
    fi
fi

if [[ -d "$HOME/.cabal/bin" ]]; then
    path=("$HOME/.cabal/bin" $path)
fi

ldpath=($HOME/local/lib $ldpath)
pkg_path=($HOME/local/lib/pkgconfig $pkg_path)
