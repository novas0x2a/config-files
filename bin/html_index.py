#!/usr/bin/env python

from __future__ import with_statement

import os
import sys
import optparse
import mimetypes
import os.path as P

header = '''
<!DOCTYPE html>
<html>
<head>
  <title>Directory listing</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <style type="text/css">
    <![CDATA[
    .even-dir { background-color: #efe0ef }
    .even { background-color: #eee }
    .odd-dir {background-color: #f0d0ef }
    .odd { background-color: #dedede }
    body { border: 0; padding: 0; margin: 0; background-color: #efefef; }
    h1 {padding: 0.1em; background-color: #777; color: white; border-bottom: thin white dashed;}
    ]]>
  </style>
</head>
<body>
  <h1>Directory listing</h1>
  <table>
    <thead>
      <tr>
        <th>Filename</th>
        <th>Size</th>
        <th>Content type</th>
      </tr>
    </thead>
    <tbody>
'''
footer = ''''
    </tbody>
  </table>
</body>
</html>
'''

def hsize(path):
    size = P.getsize(path)
    if size < 1024:
        return '%iB' % size
    elif size < (1024 ** 2):
        return '%iK' % (size / 1024)
    elif size < (1024 ** 3):
        return '%iM' % (size / (1024 ** 2))
    else:
        return '%iG' % (size / (1024 ** 3))

class Item(object):
    def __init__(self, path):
        self.path = path
    def as_row(self, klass):
        name = P.basename(self.path)
        (typ, enc) = mimetypes.guess_type(self.path)
        if typ is None and P.isdir(self.path):
            typ = 'Directory'
        return '''
            <tr class="%s">
              <td><a href="./%s">%s</a></td>
              <td>%s</td>
              <td>[%s]</td>
            </tr>''' % (klass, name, name, hsize(self.path), typ)

if __name__ == '__main__':
    parser = optparse.OptionParser()
    parser.add_option('-f', dest='filename',  default=None, help='Output file')
    parser.add_option('-r', dest='recursive', default=False, action='store_true', help='Process recursively')
    (opt, args) = parser.parse_args()

    if len(args) != 1 or not P.isdir(args[0]):
        print 'Usage: %s <directory>' % P.basename(sys.argv[0])
        sys.exit(-1)

    if opt.filename is None:
        opt.filename = P.join(args[0], 'index.html')

    odd = 'odd'

    def pathtuple(path):
        full = P.join(args[0], path)
        return (not P.isdir(full), full)

    with file(opt.filename, 'w') as out:
        print >>out, header
        for isfile, path in sorted(map(pathtuple, os.listdir(args[0]))):
            if path == opt.filename:
                continue
            klass = odd
            if not isfile:
                klass += '-dir'
            print >>out, Item(path).as_row(klass)
            odd = 'odd' if odd == 'even' else 'even'
        print >>out, footer
