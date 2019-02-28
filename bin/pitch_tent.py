#!/usr/bin/env python2

import sys
from optparse import OptionParser
from twisted.web import server, static
from twisted.internet import reactor

p = OptionParser(usage='%prog [options] directory')
p.add_option('-p', '--port', dest='port', help='port to listen on', default=8888, type='int')

(opt,args) = p.parse_args()

if not args:
    print 'I need a directory'
    p.print_help()
    sys.exit(1)

directory = args[0]

print 'Sharing %s on port %i' % (directory, opt.port)

reactor.listenTCP(opt.port, server.Site(static.File(directory)))
reactor.run()
