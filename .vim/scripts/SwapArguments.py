#!/usr/bin/env python

import re

def swap(text):
    '''Swap the args of a 2-argument macro

    >>> swap('a(b,c);')
    'a( c, b );'

    >>> swap('a(b(c,d),e);')
    'a( e, b(c,d) );'

    >>> swap('a((b,c));')
    'a((b,c));'

    >>> swap('a(b(c,d),e(f,g));')
    'a( e(f,g), b(c,d) );'

    >>> swap('a(b,c,d);')
    'a(b,c,d);'

    >>> swap('a(b,c);\\nd(e,f);')
    'a( c, b );\\nd( f, e );'

    >>> swap('a(b,c)')
    'a(b,c)'

    >>> swap('    a(b,c);')
    '    a( c, b );'

    >>> swap('    a(b,c,d);')
    '    a(b,c,d);'

    >>> swap('blah blah a(b,c);')
    'blah blah a(b,c);'

    >>> swap('a(b,c); blah blah')
    'a(b,c); blah blah'
    '''

    result = []
    for line in text.split('\n'):
        result.append(swapline(line))
    return '\n'.join(result)

def swapline(line):
    m = re.search('^(\s*)([A-Za-z_]\w*)\(\s*(.*)\s*\);\s*$', line)
    if not m:
        return line

    indent, func = m.group(1), m.group(2)
    args = parse_args(m.group(3))

    if len(args) != 2:
        return line

    return '%s%s( %s, %s );' % (indent, func, args[1], args[0])

def parse_args(s):
    args = []
    pending = ''
    depth = 0
    for c in s:
        if c == '(':
            depth += 1
            pending += c
        elif c == ')':
            depth -= 1
            pending += c
        elif depth == 0 and c == ',':
            args.append(pending)
            pending = ''
        elif depth == 0 and c == ' ':
            pass
        else:
            pending += c
    assert(depth == 0)
    args.append(pending)

    return args

if __name__ == '__main__':
    try:
        import vim
    except ImportError:
        # Not running inside vim. Just do doctests.
        import doctest
        doctest.testmod()
    else:
        r = vim.current.range
        vim.current.buffer[r.start:r.end+1] = map(swapline, r)
