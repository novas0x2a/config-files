# This code makes it fail gracefully on bsd hostname
case $(hostname --fqdn 2>/dev/null || hostname) in
    *arc.nasa.gov)
        IRGARCH=${(L)$(echo $(uname -m)_$(uname -s)_gcc$(gcc -dumpversion | cut -f-2 -d .))}
        IRGPKG=/irg/packages/$IRGARCH
        path=($HOME/local/$IRGARCH/bin $path)
        ldpath=($HOME/local/$IRGARCH/lib $ldpath)
        export HOME2=/usr/local/irg$HOME
        if [[ -d "$HOME2" ]]; then
            export CCACHE_DIR="$HOME2/.ccache"
        fi
        ;;
    *nas.nasa.gov)
        ulimit -s 256000
        export HOME2=/nobackup/$USER
        if [[ -d "$HOME2" ]]; then
            export CCACHE_DIR="$HOME2/.ccache"
        fi
        ;;
esac
