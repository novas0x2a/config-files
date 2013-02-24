#!/usr/bin/env python

import os
import sys

from hashlib import md5

TOPDIR = '/tmp/command-t-bullshit'

def hash_iterable(iterable):
    m = md5()
    for i in iterable:
        m.update(i)
    return m.hexdigest()

h = hash_iterable(sys.path)

mydir = os.path.join(TOPDIR, h)

if not os.path.exists(mydir):
    os.makedirs(mydir)
    with file(os.path.join(mydir, '.path'), 'w') as f:
        f.write('%s' % sys.path)

    for idx, p in enumerate(sys.path):
        if p and os.path.isdir(p):
            os.symlink(p, os.path.join(mydir, str(idx)))
sys.stdout.write(mydir)
