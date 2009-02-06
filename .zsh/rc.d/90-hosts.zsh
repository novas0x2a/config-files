case $(hostname --fqdn) in
    *arc.nasa.gov)
        IRGPKG=/irg/packages/${(L)$(echo $(uname -m)_$(uname -s)_gcc$(gcc -dumpversion | cut -f-2 -d .))}
        ;;
esac
