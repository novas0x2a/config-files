# This code makes it fail gracefully on bsd hostname
case $(hostname --fqdn 2>/dev/null || hostname) in
    *arc.nasa.gov)
        IRGPKG=/irg/packages/${(L)$(echo $(uname -m)_$(uname -s)_gcc$(gcc -dumpversion | cut -f-2 -d .))}
        path=($HOME/local/$(mytuple)/bin $path)
        ldpath=($HOME/local/$(mytuple)/lib $ldpath)
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
