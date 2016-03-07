#!/usr/bin/env python

import os
import sys

from functools import reduce
from hashlib import md5

TOPDIR = '/tmp/command-t-bullshit'
DEBUG  = len(sys.argv) > 1 and (sys.argv[1] == 'debug')

def hash_iterable(iterable):
    m = md5()
    for i in iterable:
        m.update(i.encode('utf-8'))
    return m.hexdigest()

h = hash_iterable(sys.path)

mydir = os.path.join(TOPDIR, h)

if not os.path.exists(mydir):
    os.makedirs(mydir)
    with open(os.path.join(mydir, '.path'), 'w') as f:
        f.write('%s' % sys.path)

    # eliminate paths that are inside other paths
    paths = sorted(set([os.path.realpath(p) + '/' for p in sys.path if p and os.path.isdir(p)]))
    paths = reduce(lambda x, y: x if os.path.commonprefix((x[-1], y)) == x[-1] else x + [y], paths, ['/nope'])
    paths = paths[1:]

    for idx, p in enumerate(paths):
        idx = '%03d' % idx
        os.symlink(p, os.path.join(mydir, idx))
sys.stdout.write(mydir)
