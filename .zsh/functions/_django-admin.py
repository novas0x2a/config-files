#compdef django-admin.py

typeset -ga nul_args
nul_args=(
  '--settings=-[the Python path to a settings module.]:file:_files'
  '--pythonpath=-[a directory to add to the Python path.]::directory:_directories'
  '--traceback[print traceback on exception.]'
  "--version[show program's version number and exit.]"
  {-h,--help}'[show this help message and exit.]'
)

_djangoadminpy-adminindex(){
  _arguments -s : \
    $nul_args \
    '*::directory:_directories' && ret=0
}

_djangoadminpy-createcachetable(){
  _arguments -s : \
    $nul_args && ret=0
}

_djangoadminpy-dbshell(){
  _arguments -s : \
    $nul_args && ret=0
}

_djangoadminpy-diffsettings(){
  _arguments -s : \
    $nul_args && ret=0
}

_djangoadminpy-dumpdata(){
  _arguments -s : \
    '--format=-[specifies the output serialization format for fixtures.]:format:(json yaml xml)' \
    '--indent=-[specifies the indent level to use when pretty-printing output.]:' \
    $nul_args \
    '*::appname:_applist' && ret=0
}

_djangoadminpy-flush(){
  _arguments -s : \
    '--verbosity=-[verbosity level; 0=minimal output, 1=normal output, 2=all output.]:Verbosity:((0\:minimal 1\:normal 2\:all))' \
    '--noinput[tells Django to NOT prompt the user for input of any kind.]' \
    $nul_args && ret=0
}

_djangoadminpy-help(){
  _arguments -s : \
    '*:command:_djangoadminpy_cmds' \
    $nul_args && ret=0
}

_djangoadminpy_cmds(){
    local line
    local -a cmd
    _call_program help-command ./django-admin.py help \
      |& sed -n '/^ /s/[(), ]/ /gp' \
      | while read -A line; do cmd=($line $cmd) done
    _describe -t djangoadminpy-command 'django-admin.py command' cmd
}

_djangoadminpy-inspectdb(){
  _arguments -s : \
    $nul_args && ret=0
}

_djangoadminpy-loaddata(){
  _arguments -s : \
    '--verbosity=-[verbosity level; 0=minimal output, 1=normal output, 2=all output.]:Verbosity:((0\:minimal 1\:normal 2\:all))' \
    '*::file:_files' \
    $nul_args && ret=0
}

_djangoadminpy-reset(){
  _arguments -s : \
    '--noinput[tells Django to NOT prompt the user for input of any kind.]' \
    '*::appname:_applist' \
    $nul_args && ret=0
}

_djangoadminpy-runfcgi(){
  local state
  
  local fcgi_opts
  fcgi_opts=(
    'protocol[fcgi, scgi, ajp, ... (default fcgi)]:protocol:(fcgi scgi ajp)'
    'host[hostname to listen on..]:'
    'port[port to listen on.]:'
    'socket[UNIX socket to listen on.]::file:_files'
    'method[prefork or threaded (default prefork)]:method:(prefork threaded)'
    'maxrequests[number of requests a child handles before it is killed and a new child is forked (0 = no limit).]:'
    'maxspare[max number of spare processes / threads.]:'
    'minspare[min number of spare processes / threads.]:'
    'maxchildren[hard limit number of processes / threads.]:'
    'daemonize[whether to detach from terminal.]:boolean:(False True)'
    'pidfile[write the spawned process-id to this file.]:file:_files'
    'workdir[change to this directory when daemonizing.]:directory:_files'
    'outlog[write stdout to this file.]:file:_files'
    'errlog[write stderr to this file.]:file:_files'
  )
  
  _arguments -s : \
    $nul_args \
    '*: :_values "FCGI Setting" $fcgi_opts' && ret=0
}

_djangoadminpy-runserver(){
  _arguments -s : \
    '--noreload[tells Django to NOT use the auto-reloader.]' \
    '--adminmedia[specifies the directory from which to serve admin media.]:directory:_files' \
    $nul_args && ret=0
}

_djangoadminpy-shell(){
  _arguments -s : \
    '--plain[tells Django to use plain Python, not IPython.]' \
    $nul_args && ret=0
}

_djangoadminpy-sql(){}
_djangoadminpy-sqlall(){}
_djangoadminpy-sqlclear(){}
_djangoadminpy-sqlcustom(){}
_djangoadminpy-sqlflush(){}
_djangoadminpy-sqlindexes(){}
_djangoadminpy-sqlinitialdata(){}
_djangoadminpy-sqlreset(){}
_djangoadminpy-sqlsequencereset(){}
_djangoadminpy-startapp(){}

_djangoadminpy-syncdb() {
  _arguments -s : \
    '--verbosity=-[verbosity level; 0=minimal output, 1=normal output, 2=all output.]:Verbosity:((0\:minimal 1\:normal 2\:all))' \
    '--noinput[tells Django to NOT prompt the user for input of any kind.]' \
    $nul_args && ret=0
}

_djangoadminpy-test() {
  _arguments -s : \
    '--verbosity=-[verbosity level; 0=minimal output, 1=normal output, 2=all output.]:Verbosity:((0\:minimal 1\:normal 2\:all))' \
    '--noinput[tells Django to NOT prompt the user for input of any kind.]' \
    '*::appname:_applist' \
    $nul_args && ret=0
}

_djangoadminpy-testserver() {
  _arguments -s : \
    '--verbosity=-[verbosity level; 0=minimal output, 1=normal output, 2=all output.]:Verbosity:((0\:minimal 1\:normal 2\:all))' \
    '--addrport=-[port number or ipaddr:port to run the server on.]' \
    '*::fixture:_files' \
    $nul_args && ret=0
}

_djangoadminpy-validate() {
  _arguments -s : \
    $nul_args && ret=0
}

_djangoadminpy-commands() {
  local -a commands
  
  commands=(
    'adminindex:prints the admin-index template snippet for the given app name(s).'
    'createcachetable:creates the table needed to use the SQL cache backend.'
    'dbshell:runs the command-line client for the current DATABASE_ENGINE.'
    "diffsettings:displays differences between the current settings.py and Django's default settings."
    'dumpdata:Output the contents of the database as a fixture of the given format.'
    'flush:Executes ``sqlflush`` on the current database.'
    'help:django-admin.py help.'
    'inspectdb:Introspects the database tables in the given database and outputs a Django model module.'
    'loaddata:Installs the named fixture(s) in the database.'
    'reset:Executes ``sqlreset`` for the given app(s) in the current database.'
    'runfcgi:Run this project as a fastcgi (or some other protocol supported by flup) application,'
    'runserver:Starts a lightweight Web server for development.'
    'shell:Runs a Python interactive interpreter.'
    'sql:Prints the CREATE TABLE SQL statements for the given app name(s).'
    'sqlall:Prints the CREATE TABLE, custom SQL and CREATE INDEX SQL statements for the given model module name(s).'
    'sqlclear:Prints the DROP TABLE SQL statements for the given app name(s).'
    'sqlcustom:Prints the custom table modifying SQL statements for the given app name(s).'
    'sqlflush:Returns a list of the SQL statements required to return all tables in the database to the state they were in just after they were installed.'
    'sqlindexes:Prints the CREATE INDEX SQL statements for the given model module name(s).'
    "sqlinitialdata:RENAMED: see 'sqlcustom'"
    'sqlreset:Prints the DROP TABLE SQL, then the CREATE TABLE SQL, for the given app name(s).'
    'sqlsequencereset:Prints the SQL statements for resetting sequences for the given app name(s).'
    "startapp:Creates a Django app directory structure for the given app name in this project's directory."
    "syncdb:Create the database tables for all apps in INSTALLED_APPS whose tables haven't already been created."
    'test:Runs the test suite for the specified applications, or the entire site if no apps are specified.'
    'testserver:Runs a development server with data from the given fixture(s).'
    'validate:Validates all installed models.'
  )
  
  _describe -t commands 'django-admin.py command' commands && ret=0
}

_applist() {
  local line
  local -a apps
  _call_program help-command "python -c \"import os.path as op, re, settings, sys;\\
                                          bn=op.basename(op.abspath(op.curdir));[sys\\
                                          .stdout.write(str(re.sub(r'^%s\.(.*?)$' %
                                          bn, r'\1', i)) + '\n') for i in settings.\\
                                          INSTALLED_APPS if re.match(r'^%s' % bn, i)]\"" \
                             | while read -A line; do apps=($line $apps) done
  _values 'Application' $apps && ret=0
}

_djangoadminpy() {
  local curcontext=$curcontext ret=1
  
  if ((CURRENT == 2)); then
    _djangoadminpy-commands
  else
    shift words
    (( CURRENT -- ))
    curcontext="${curcontext%:*:*}:djangoadminpy-$words[1]:"
    _call_function ret _djangoadminpy-$words[1]
  fi
}

_djangoadminpy "$@"
