CHPWD_MAX_FILES_LIST=1000

function chpwd() {
    emulate -L zsh
    if [[ ${CHPWD_INTERACTIVE_CD:-0} -eq 0 ]]; then
        return
    fi

    local links=$(stat --printf '%h' $PWD)
    if [[ $links -gt $CHPWD_MAX_FILES_LIST ]]; then
        echo "Refusing to list a directory with more than $CHPWD_MAX_FILES_LIST files"
    else
        ls
    fi
}

# title/precmd/postcmd
function precmd() {
  title "zsh $(print -Pn %~)"
}

function preexec() {
  # The full command line comes in as "$1"
  local cmd="$1"
  local -a args

  # add '--' in case $1 is only one word to work around a bug in ${(z)foo}
  # in zsh 4.3.9.
  tmpcmd="$1 --"
  args=(${(z)tmpcmd})

  # remove the '--' we added as a bug workaround..
  # per zsh manpages, removing an element means assigning ()
  args[${#args}]=()
  if [ "${args[1]}" = "fg" ] ; then
    local jobnum="${args[2]}"
    if [ -z "$jobnum" ] ; then
      # If no jobnum specified, find the current job.
      for i in ${(k)jobtexts}; do
        [ -z "${jobstates[$i]%%*:+:*}" ] && jobnum=$i
      done
    fi
    cmd="${jobtexts[${jobnum#%}]}"
  else
  fi
  title "$cmd"
}

autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
  colors
fi

#__kube_ps1
export PROMPT=$'%{\e[1;%(#|31|32)m%}%n@%m:%5~>%{\e[0m%} '
export RPROMPT=$'%(?..[%{\e[1;31m%}%?%{\e[0m%}])$(__kube_ps1)$(__git_ps1)'

function title() {
  # This is madness.
  # We replace literal '%' with '%%'
  # Also use ${(V) ...} to make nonvisible chars printable (think cat -v)
  # Replace newlines with '; '
  local value="${${${(V)1//\%/\%\%}//'\n'/; }//'\t'/ }"
  local location

  location="$HOST"
  [ "$USERNAME" != "$LOGNAME" ] && location="${USERNAME}@${location}"

  # Special format for use with print -Pn
  value="%70>...>$value%<<"
  unset PROMPT_SUBST
  case $TERM in
    screen)
      # Put this in your .screenrc:
      # hardstatus string "[%n] %h - %t"
      # termcapinfo xterm 'hs:ts=\E]2;:fs=\007:ds=\E]2;screen (not title yet)\007'
      print -Pn "\ek${value}\e\\"     # screen title (in windowlist)
      print -Pn "\e_${location}\e\\"  # screen location
      ;;
    xterm*)
      print -Pn "\e]0;${location}: ${value}\a"
      ;;
  esac
  setopt LOCAL_OPTIONS
  return 0
}
