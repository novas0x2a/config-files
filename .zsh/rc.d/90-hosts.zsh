# This code makes it fail gracefully on bsd hostname
host=$(hostname --fqdn 2>/dev/null)
test -z "$host" && host=$(hostname)

case $host in
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
        ulimit -s 1024000
        export HOME2=/nobackup/$USER
        if [[ -d "$HOME2" ]]; then
            export CCACHE_DIR="$HOME2/.ccache"
        fi
        ;;
esac
