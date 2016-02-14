#!/bin/sh

export RANGE=40
export OFFSET=`expr 255 - $RANGE`

# Default to 'screen -RR' if no arguments are given.
#[ $# -eq 0 ] && set -- screen -RR

# LANG=C unless otherwise specified.
[ -z "$LANG" ] && export LANG=C

# Clear screen STY so calling 'run-xterm' from within screen will actually
# start a new xterm with a new screen session.
export STY=

# Pick our font.
#FONT="*suxus*"

# Generate two random colors. One dark for background, one a lighter version of
# the dark color. Eval the output and we'll have $BG and $FG as RGB hex values
# for colors to use.
eval $(perl -le 'sub c { int(rand() * $ENV{RANGE} + $ENV{OFFSET}) }; sub p { printf("%s=#%02x%02x%02x\n", @_) }; @f = (c, c, c); @b = map($_ - $ENV{OFFSET}, @f);  p("FG",@f); p("BG", @b);')

#exec xterm -fg white -ms "$FG" -bg "$BG" -fn "$FONT" -cr green -e "$@"
exec xterm -fg white -ms "$FG" -bg "$BG" "$@"
