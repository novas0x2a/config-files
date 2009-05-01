case $(hostname --fqdn) in
    *arc.nasa.gov)
        IRGPKG=/irg/packages/${(L)$(echo $(uname -m)_$(uname -s)_gcc$(gcc -dumpversion | cut -f-2 -d .))}
        path=($HOME/local/$(mytuple)/bin $path)
        ldpath=($HOME/local/$(mytuple)/lib $ldpath)
        ;;
esac
