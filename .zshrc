export TEXINPUTS=/home/mike/code/mine/code/latex:
export BSTINPUTS=/home/mike/code/mine/code/latex:
alias phone='obexftp -b 00:19:C0:C8:00:A1'
alias gdb='libtool --mode=execute gdb'
alias '...'='cd ../..'
alias '....'='cd ../../..'
alias '.....'='cd ../../../..'

#path+=/home/mike/work/code/learncs/connect-four/google_appengine
path+=~/build/bin

gdata_auth() {
    local email passwd ret state
    echo -n 'Email? '
    read email
    state=$(stty -g)
    echo -n 'Password? '
    stty -echo
    read passwd
    stty "$state"
    echo
    ret=$(curl                                          \
         -f -s -S                                       \
         -d accountType=GOOGLE                          \
         -d "Email=$email"                              \
         -d "Passwd=$passwd"                            \
         -d service=cp                                  \
         -d source='fluffypenguin,gdatashellauth,0.1'   \
         https://www.google.com/accounts/ClientLogin)
    if [[ $? -ne 0 ]]; then
        echo "Failed."
        return
    fi
    eval $(echo $ret | grep '^Auth')
    echo 'Auth set: ' $Auth[1,5]...
}

gdata_get() {
    local url ret
    if [[ $# -lt 1 ]]; then
        echo "Usage: $0 feed_url [addl-opts]"
    fi
    ret=$(curl -f -s -S \
        -H "Authorization: GoogleLogin auth=$Auth" \
        $2                                         \
        $1)
    if [[ $? -ne 0 ]]; then
        echo "Failed."
        return
    fi
    echo $ret
}

gdata_email() {
    [[ $# -ne 1 ]] && return
    gdata_get  'http://www.google.com/m8/feeds/contacts/default/base?max-results=999999' | xpath -q -e "//entry[contains(title/text(),'$1')]/gd:email/@address"
}

computer() {
    local cmd
    [[ $# -ne 1 ]] && return
    case "$1" in
        "suspend")
            cmd=Suspend
            ;;
        "hibernate")
            cmd=Hibernate
            ;;
        *)
            return
            ;;
    esac

    dbus-send \
        --session \
        --dest=org.freedesktop.PowerManagement \
        --type=method_call \
        --print-reply \
        --reply-timeout=2000 \
    /org/freedesktop/PowerManagement \
    org.freedesktop.PowerManagement.$cmd
}

my-tags-python() {
    ctags -R -f ~/.vim/tags/python.ctags /usr/lib/python2.5/
}


export spot0='0014.4F01.0000.4519'
export spot1='0014.4F01.0000.1F88'
export spot2='0014.4F01.0000.1F9A'
