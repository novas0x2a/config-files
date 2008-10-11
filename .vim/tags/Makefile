all: python c cpp

python:
	paths=`python -c 'import sys;import os.path; print " ".join([i for i in sys.path if os.path.isdir(i)][1:])'`;\
	ctags -R -f python.tags $$paths

c:
	ctags    -f c.tags /usr/include/*
	ctags -a -f c.tags -R /usr/local/include
	ctags -a -f c.tags -R ${HOME}/local/include

cpp:
	ctags -f cpp.tags -R /usr/include/c++/`gcc -dumpversion`/


