#!/usr/bin/env python

if __name__ == '__main__':
    try:
        import vim
    except ImportError:
        # Not running inside vim. Just do doctests.
        import doctest
        doctest.testmod()
    else:
        import os
        import subprocess
        ver = subprocess.Popen(['g++', '-dumpversion'], stdout=subprocess.PIPE).communicate()[0]
        path = os.path.join('/usr/include/c++', ver.strip())
        if os.path.exists(path):
            vim.command('path+=%s/**' % path)

