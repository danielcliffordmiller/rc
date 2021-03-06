black='\[\e[0;30m\]'
red='\[\e[0;31m\]'
green='\[\e[0;32m\]'
yellow='\[\e[0;33m\]'
blue='\[\e[0;34m\]'
purple='\[\e[0;35m\]'
cyan='\[\e[0;36m\]'
gray='\[\e[0;37m\]'
nc='\[\e[0m\]'
# bold colors
black_b='\[\e[1;30m\]'
red_b='\[\e[1;31m\]'
green_b='\[\e[1;32m\]'
yellow_b='\[\e[1;33m\]'
blue_b='\[\e[1;34m\]'
purple_b='\[\e[1;35m\]'
cyan_b='\[\e[1;36m\]'
white_b='\[\e[1;37m\]'
# high intensty colors
black_hi='\[\e[0;90m\]'       # Black
red_hi='\[\e[0;91m\]'         # Red
green_hi='\[\e[0;92m\]'       # Green
yellow_hi='\[\e[0;93m\]'      # Yellow
blue_hi='\[\e[0;94m\]'        # Blue
purple_hi='\[\e[0;95m\]'      # Purple
cyan_hi='\[\e[0;96m\]'        # Cyan
white_hi='\[\e[0;97m\]'       # White
# underlined colors
nc_u='\[\e[0;4m\]'


working_dir="${BASH_SOURCE[0]%/*}"
os_name="$(uname | tr '[:upper:]' '[:lower:]')"
os_config_file="$working_dir/bashrc.$os_name"

eval "$(cat $os_config_file)"

export HISTCONTROL="ignorespace:erasedups"
export HISTIGNORE="h *:h:history:hh:hhh:history *"

alias cal="cal -3"

alias la="ls -la"
alias ll="ls -l"
alias lla="ls -la"
alias ltr="ls -ltr"
alias gl="git log --oneline"
alias glg="git log --oneline --graph"

alias tree="tree.exp"

export CD_ROOT=/mnt/cdrom

vd() {
    vim `date +"%m%d%y"`
}

h() {
    n=${1:-9}
    hist=$( history $n | sed -e 's/^[[:digit:] ]\{4\}[[:digit:]]/#####/' )
    lines=$( echo "$hist" | grep -c '^#####' )
    echo "$hist" | perl -pe 'BEGIN {$line='$lines'} s/^#{5}/sprintf("%5i",$line--)/e if /^#{5}/'
}
alias hh="h 20"
alias hhh="h 30"

f() {
    find . -name "$1" -print -quit
}

z() {
    if [ ! -d z ]; then
        mkdir z || return
    fi
    mv "$@" z
}

gz() {
    if [ ! -d z ]; then
        mkdir z || return
    fi
    git mv "$@" z
}

hg () { history | grep $1; }

esc_bs() {
    echo $1 | sed 's#\\#\\\\#g'
}

esc_s() {
    echo $1 | sed 's#\/#\\\/#g'
}

rm_brace() {
    echo $1 | sed -e 's/\\\(\[\|\]\)//g'
}

get_ip() {
    perl -e 'use strict;use IO::Socket::INET;my$s=new IO::Socket::INET(PeerAddr=>"ipaddress.com",PeerPort=>"80",Proto=>"tcp");print$s "GET / HTTP/1.1\r\nHost: ipaddress.com\r\nAccept: text/html\r\nConnection: close\r\n\r\n";while(<$s>){if(/Your IP/){s/^ *//;print s/<[^>]*>//gr;last}};close($s);'
}

get_country() {
    exec 9<>/dev/tcp/whatismyipaddress.com/80
    echo -ne "\
GET / HTTP/1.1\r\n\
Host: whatismyipaddress.com\r\n\
User-Agent: Mozilla/5.0\r\n\r\n" >&9
    sed -n -e '/Country/{s/^[[:space:]]*//;s/<[^>]*>//g;s/:/: /;p;q}' <&9
    exec 9>&-
    exec 9<&-
}

serv() {
    if [ $# -ne 1 ] && [ $# -ne 2 ]; then
        echo -e "usage: serv $(rm_brace $nc_u)file$(rm_brace $nc) [$(rm_brace $nc_u)port$(rm_brace $nc)]"
        return
    fi
    [ "$(uname)" = "Darwin" ] && opt="-p"
    port=${2:-8080}
    ( echo -ne "HTTP/1.1 200 OK\r
Content-Type: application/octet-stream\r
Connection: Keep-Alive\r
Content-Length: $(wc -c $1 | cut -d\  -f 1)\r
Content-Disposition: attachment; filename=\"$1\"\r
Connection: close\r\n\r\n"
    cat $1 ) | nc -l $opt $port
}

prompt_header() {
    let "cmd_num=$( jobs | wc -l )"
    git_string=$(git rev-parse --show-toplevel 2> /dev/null)
    if [ ! -z "$git_string" ]; then
        #-----
        git_string="$(git branch | sed -n '/\*/p' | sed 's/\* \+//')"
        #-----
        faux_git_string="[$git_string]─"
    else
        faux_git_string=""
    fi
    dir=`echo $PWD | sed "s#$HOME#~#"`
    termsize=$(tput cols)
    if  $($ps_hostname); then
        hostname="${HOSTNAME%%.*}:"
    else
        hostname=""
    fi
    prompt_string="---| ${USER} $hostname$dir |-$faux_git_string($cmd_num)-"
    numchars=${#prompt_string}
    let chardiff=$termsize-$numchars
    dashes=""
    if [ $chardiff -lt 0 ]; then
        let chardiff=-chardiff
        #ins="..."
        ins="'"
        ndir=${dir:0:$(((${#dir}-$chardiff-${#ins})/4))}
        ndir=$ndir$ins
        ndir=$ndir${dir:$((${#ndir}+$chardiff))}
        dir=$ndir
    else
        i=1
        while [ $i -le $chardiff ]; do
            dashes="─$dashes"
            let i++
        done
    fi

    if (($UID)); then

        if [ $($ps_hostname) ]; then
            hostname_t=""
        fi

        proto_PS1="$bar_c$()───┤$username_c ${USER} $hostname_c$hostname_t$dir_c\$dir$bar_c ├─${dashes}($job_c\j$bar_c)─\n \$$nc "
        if [ ! -z "$git_string" ]; then
            proto_PS1=$(echo $proto_PS1 | sed "s/\(.\)(\([^(]*\)$/─[$(esc_bs $git_c)$(esc_s "$git_string")$(esc_bs $bar_c)]\1(\2 /")
        fi
        export PS1="$proto_PS1"
    else
        unset PROMPT_COMMAND
        export PS1="$red_b\u $blue_b\h$nc:$blue_b\W $nc${black_hi}\\$ $nc"
    fi
}
#print_tty() {
#    tty=$(tty | sed -e 's#/dev/##')
#    tput sc
#    tput cup 0 $(($(tput cols)-${#tty}-1))
#    echo -e $tty
#    tput rc
#}
export PROMPT_COMMAND="prompt_header"

lowercase() {
    for file; do
        filename=${file##*/}
        case "$filename" in
            */*) dirname==${file%/*} ;;
            *)    dirname=.;;
        esac
        nf=$(echo $filename | tr A-Z a-z)
        newname="${dirname}/${nf}"
        if [ "$nf" != "$filename" ]; then
            mv "$file" "$newname"
            echo "lowercase: $file --> $newname"
        else
            echo "lowercase: $file not changed."
        fi
    done
}
make_keys() {
    sed -e 's/".*"/asdf/g' ~/.icewm/toolbar | awk -f ~/.icewm/make_keys.awk
}
notify-aptitude-finished() {
    while true; do
        if [ -z "$(pgrep aptitude)" ]; then
            notify-send "Aptitude is finished"
            break
        fi
    done
}

docker-rm-exited() {
    docker ps -a | awk '/Exited/ {print $1}' | xargs docker rm
}

docker-rmi-unamed() {
    docker images | awk '$1 == "<none>" {print $3}' | xargs docker rmi
}

cg() { cd $(git rev-parse --show-toplevel); }

export WINEDLLOVERRIDES='winemenubuilder.exe=d'

export EDITOR=vim

set -P

stty -ixon
