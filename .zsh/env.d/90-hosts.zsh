# This code makes it fail gracefully on bsd hostname
# hostname --fqdn will cause a dns hit, which means zsh will hang for a while
# with unreliable dns :/
#case $(hostname --fqdn 2>/dev/null || hostname) in
#    *.ndc.nasa.gov)
#        IRGARCH=${(L)$(echo $(uname -m)_$(uname -s)_gcc$(gcc -dumpversion | cut -f-2 -d .))}
#        IRGPKG=/irg/packages/$IRGARCH
#        path=($HOME/local/$IRGARCH/bin /usr/local/irg/releases/roversw/$IRGARCH/bin $path)
#        ldpath=($HOME/local/$IRGARCH/lib $ldpath)
#        pkg_path=($HOME/local/$IRGARCH/lib/pkgconfig $pkg_path)
#        export HOME2=/usr/local/irg$HOME
#        if [[ -d "$HOME2" ]]; then
#            export CCACHE_DIR="$HOME2/.ccache"
#        fi
#        ;;
#    *nas.nasa.gov)
#        ulimit -s 256000
#        export HOME2=/nobackup/$USER
#        if [[ -d "$HOME2" ]]; then
#            export CCACHE_DIR="$HOME2/.ccache"
#        fi
#        ;;
#esac
