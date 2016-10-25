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
    export -TU GOPATH go_path
    local go_version="$(go version | cut -d ' ' -f 3)"

    export GO_SCRATCH_PATH="$HOME/tmp/${go_version}"
    export GO_LOCAL_PATH="$HOME/local/go"
    export GO_DEV_PATH="$HOME/Projects/go"

    go_path=($GO_SCRATCH_PATH $GO_LOCAL_PATH $GO_DEV_PATH)
    path+=($GO_DEV_PATH/bin $GO_LOCAL_PATH/bin $GO_SCRATCH_PATH/bin)

    if test -d "$GO_DEV_PATH/src"; then
        cdpath+=($GO_DEV_PATH/src/*)
    fi

    alias godev='GOPATH="$GO_DEV_PATH" go'
    alias golocal='GOPATH="$GO_LOCAL_PATH" go'
    alias goscratch='GOPATH="$GO_SCRATCH_PATH" go'
fi

if [[ -d "$HOME/.cabal/bin" ]]; then
    path=("$HOME/.cabal/bin" $path)
fi

ldpath=($HOME/local/lib $ldpath)
pkg_path=($HOME/local/lib/pkgconfig $pkg_path)
