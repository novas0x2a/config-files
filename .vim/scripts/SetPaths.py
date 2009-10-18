#!/usr/bin/env python

import os
import sys
import vim

for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
