local PROJECT_DIR=~/Code

# Make sure current directory is always searched first for CDPATH, some build
# scripts depend on this
cdpath=("" $cdpath)

perl_path=($HOME/local/lib/perl5/site_perl $HOME/local/lib/perl5 $perl_path)

fpath=($HOME/.zsh/functions $fpath)
cdpath+=$PROJECT_DIR
path=(~/bin ~/.local/bin ~/local/bin /opt/local/bin $path)

# Doesn't seem to be supported anymore?
if which ruby &>/dev/null; then
    local rubydir=$(ruby -rrubygems -e 'puts Gem.user_dir')
    if [[ -d $rubydir ]]; then
        path=("$rubydir/bin" $path)
    fi
fi

if which npm &>/dev/null; then
    local npm=$HOME/.local/npm
    path+=($npm/bin)
    manpath+=($npm/share/man)
fi

if which go &>/dev/null; then
    export -TU GOPATH go_path
    export -TU GOPROXY go_proxy ,
    go_path=(~/.local/go)
    path=(~/.local/go/bin $path)
    if test -d ~/.local/go/src; then
        cdpath+=(~/.local/go/src/*)
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

if [[ -d ~/.kube ]]; then
    export -TU KUBECONFIG kube_config
    kube_config=(~/.kube/*.conf)
    if [[ -r ~/.kube/config ]]; then
        kube_config+=(~/.kube/config)
    fi
fi

if [[ -d ~/.linuxbrew ]]; then
    eval "$(~/.linuxbrew/bin/brew shellenv)"
    fpath+=(~/.linuxbrew/share/zsh/site-functions)
fi

# move my bin dir up
path=(~/bin $path)
