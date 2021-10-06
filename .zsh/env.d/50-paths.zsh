local PROJECT_DIR=~/Projects

# Make sure current directory is always searched first for CDPATH, some build
# scripts depend on this
cdpath=("" $cdpath)

perl_path=($HOME/local/lib/perl5/site_perl $HOME/local/lib/perl5 $perl_path)

fpath=($HOME/.zsh/functions $fpath)
cdpath+=$PROJECT_DIR
path=(~/bin ~/.local/bin ~/local/bin /opt/local/bin $path)

# Doesn't seem to be supported anymore?
# if which ruby &>/dev/null; then
#     local rubydir=$(ruby -rrubygems -e 'puts Gem.user_dir')
#     if [[ -d $rubydir ]]; then
#         path=("$rubydir/bin" $path)
#     fi
# fi

if which go &>/dev/null; then
    export -TU GOPATH go_path
    export GO_SCRATCH_PATH="$HOME/tmp/go"
    export GO_LOCAL_PATH="$HOME/local/go/vendor"
    export GO_DEV_PATH="$HOME/Projects/go"

    go_path=($GO_SCRATCH_PATH $GO_LOCAL_PATH $GO_DEV_PATH)
    path=(~/go/bin $GO_DEV_PATH/bin $GO_LOCAL_PATH/bin $GO_SCRATCH_PATH/bin $path)

    if test -d "$GO_DEV_PATH/src"; then
        cdpath+=($GO_DEV_PATH/src/*)
    fi
fi

if [[ -d "$HOME/.cabal/bin" ]]; then
    path=("$HOME/.cabal/bin" $path)
fi

if [[ -x "$HOME/.krew/bin/kubectl-krew" ]]; then
    path=($HOME/.krew/bin $path)
fi

ldpath=($HOME/local/lib $ldpath)
pkg_path=($HOME/local/lib/pkgconfig $pkg_path)

if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi
