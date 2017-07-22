black='\[\e[0;30m\]'
BLACK='\[\e[1;30m\]'
red='\[\e[0;31m\]'
RED='\[\e[1;31m\]'
green='\[\e[0;32m\]'
GREEN='\[\e[1;32m\]'
yellow='\[\e[0;33m\]'
YELLOW='\[\e[1;33m\]'
blue='\[\e[0;34m\]'
BLUE='\[\e[1;34m\]'
purple='\[\e[0;35m\]'
PURPLE='\[\e[1;35m\]'
cyan='\[\e[0;36m\]'
CYAN='\[\e[1;36m\]'
gray='\[\e[0;37m\]'
WHITE='\[\e[1;37m\]'
NC='\[\e[0m\]' 
# High Intensty
IBlack='\[\e[0;90m\]'       # Black
IRed='\[\e[0;91m\]'         # Red
IGreen='\[\e[0;92m\]'       # Green
IYellow='\[\e[0;93m\]'      # Yellow
IBlue='\[\e[0;94m\]'        # Blue
IPurple='\[\e[0;95m\]'      # Purple
ICyan='\[\e[0;96m\]'        # Cyan
IWhite='\[\e[0;97m\]'       # White

alias cal="cal -3"
alias la="ls -la"
alias ll="ls -l"
alias lla="ls -la"
alias ltr="ls -ltr"

export CD_ROOT=/mnt/cdrom

vd() {
	vim `date +"%m%d%y"`
}

h() {
	n=${1:-9}
	hist=$( history $n | sed -e 's/^[[:digit:] ]\{4\}[[:digit:]]/#####/' )
	lines=$( echo "$hist" | sed -ne '/^#####/p' | wc -l )
	echo "$hist" | awk 'BEGIN {line='$lines'} $1 ~ "#####" {
		printf("%5i  ", line--);
		for(i=2; i<NF; i++)
			printf $i " ";
		print $NF;
	} $1 !~ "#####" {print}'
}
export HISTIGNORE="h *:h"

get_ip() {
	exec 9<>/dev/tcp/whatismyip.com/80
	echo -ne "GET / HTTP/1.0\r\n\r\n" >&9
	sed -n -e '/Your IP:/{s/^ *//;s/<[^>]*>//g;p}' <&9
	exec 9>&-
	exec 9<&-
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
ice-add() {
	if [ $# != 1 ]; then
		echo "usage:  ice-add [program name]"
		return
	fi
	directory="~/.icewm/menu_files/"
	PS3="select program group: "
	select group in `ls $directory`; do
		break
	done
}
ice_icon() {
	if [ $# != 2 ]; then
		echo "usage:  ice_icons [program name] [picture name]"
		return
	fi

	if [ ! -e $2 ]; then
		echo "$2 not found"
		return
	fi

	for i in 16 32 48; do
		convert $2 -scale ${i}x$i ~/.icewm/icons/${1}_${i}x${i}.xpm
	done
	echo "Success! :)"
	rm -i $2
}

serv() {
	if [ $# -ne 1 ] && [ $# -ne 2 ]; then
		echo "usage: serv [file]"
		exit 1
	fi
	port=${2:-1234}
	( echo -ne "HTTP/1.0
Content-type: application/octet-stream
Content-length: $(wc -c $1 | cut -d\  -f 1)
Content-disposition: attachment; filename=\"$1\"\n"
	cat $1 ) | nc -l -p $port
}

prompt_header() {
	#[ $cmd_num ] && let cmd_num++; let ${cmd_num:=0}
	cmd_num=$( date +%T )
	dir=`echo $PWD | sed "s#$HOME#~#"`
	termsize=$(tput cols)
	prompt_string="───┤ ${USER} ${HOSTNAME%%.*}:$dir ├─($cmd_num)─"
	numchars=${#prompt_string}
	let chardiff=$termsize-$numchars
	dashes=""
	if [ $chardiff -lt 0 ]; then
		#--- use this:
		let chardiff=-chardiff
		#ins="..."
		ins="*"
		#ndir=$dir
		#ndir=$(echo $dir | sed 's#\(~\?/[^/]\+/\).*#\1#')
		ndir=${dir:0:$(((${#dir}-$chardiff-${#ins})/4))}
		#ndir=${dir:0:$(((${#dir}-$chardiff-${#ins})/2))}
		ndir=$ndir$ins
		ndir=$ndir${dir:$((${#ndir}+$chardiff))}
		dir=$ndir
		#--- or use this:
		#dir=$ins${dir:$(($numchars-$termsize+${#ins}))}
	else
		i=1
		while [ $i -le $chardiff ]; do
			dashes="─$dashes"
			let i++
		done
	fi
}
#print_tty() {
#	tty=$(tty | sed -e 's#/dev/##')
#	tput sc
#	tput cup 0 $(($(tput cols)-${#tty}-1))
#	echo -e $tty
#	tput rc
#}
if (($UID)); then
	export PROMPT_COMMAND="prompt_header"
if [ "$TERM" = "screen.linux" ]; then
	export PS1="───┤ $GREEN${USER} $BLUE\h$NC:$BLUE\$dir $NC├─\$dashes($YELLOW\$cmd_num$NC)─\n \$$NC "
else
	export PS1="$IBlack───┤$GREEN ${USER} $BLUE\h$NC:$BLUE\$dir $NC$IBlack├─\$dashes($YELLOW\$cmd_num$IBlack)─\n$IBlack \$$NC "
	fi
else
	unset PROMPT_COMMAND
	export PS1="$RED\u $BLUE\h$NC:$BLUE\W $NC${IBlack}\\$ $NC"
fi

lowercase() {
	for file; do
		filename=${file##*/}
		case "$filename" in
			*/*) dirname==${file%/*} ;;
			*)	dirname=.;;
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

export WINEDLLOVERRIDES='winemenubuilder.exe=d'
