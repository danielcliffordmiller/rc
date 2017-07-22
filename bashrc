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



export HISTCONTROL="ignoreboth"
export HISTIGNORE="h *:h"

if [ "$(uname)" = "Darwin" ]; then
	alias awk=gawk
	alias sed=gsed
	alias ls="ls -G"
fi

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
	let lines=$(echo $lines)
	echo "$hist" | awk 'BEGIN {line='$lines'} $1 ~ "#####" {
		printf("%5i  ", line--);
		for(i=2; i<NF; i++)
			printf $i " ";
		print $NF;
	} $1 !~ "#####" {print}'
}

f() {
	find . -name "$1" -print -quit
}

esc_bs() {
	echo $1 | sed 's#\\#\\\\#g'
}

rm_brace() {
	echo $1 | sed -e 's/\\\(\[\|\]\)//g'
}

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
		echo -e "usage: serv $(rm_brace $nc_u)file$(rm_brace $nc) [$(rm_brace $nc_u)port$(rm_brace $nc)]"
		return
	fi
	port=${2:-8080}
	( echo -ne "HTTP/1.1 200 OK\r
Content-Type: application/octet-stream\r
Connection: Keep-Alive\r
Content-Length: $(wc -c $1 | cut -d\  -f 1)\r
Content-Disposition: attachment; filename=\"$1\"\r
ETag: \"1a2s3d4f\"\r
Connection: close\r\n\r\n"
	cat $1 ) | nc -l -p $port
}

prompt_header() {
	#[ $cmd_num ] && let cmd_num++; let ${cmd_num:=0}
	cmd_num=$( date +%T )
	git_string=$(git rev-parse --show-toplevel 2> /dev/null)
	if [ ! -z "$git_string" ]; then
		git_string="$(basename $git_string)"
		git_string="$git_string:$(git branch | awk 'NF == 2 {print $2}')"
		#git_string="[$git_string]─"
		faux_git_string="[$git_string]─"
	else
		faux_git_string=""
	fi
	dir=`echo $PWD | sed "s#$HOME#~#"`
	termsize=$(tput cols)
	prompt_string="---| ${USER} ${HOSTNAME%%.*}:$dir |-$faux_git_string($cmd_num)-"
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

	if (($UID)); then
		proto_PS1="$black_hi$()───┤$green_hi ${USER} $blue_hi\h$nc:$blue_hi\$dir$black_hi ├─${dashes}($yellow_hi\$cmd_num$nc$black_hi)─\n \$$nc "
		if [ ! -z "$git_string" ]; then
			proto_PS1=$(echo $proto_PS1 | sed "s/\(.\)(\([^(]*\)$/─[$(esc_bs $red_hi)$git_string$(esc_bs $black_hi)]\1(\2 /")
		fi
		export PS1="$proto_PS1"
	else
		unset PROMPT_COMMAND
		export PS1="$red_b\u $blue_b\h$nc:$blue_b\W $nc${black_hi}\\$ $nc"
	fi
}
#print_tty() {
#	tty=$(tty | sed -e 's#/dev/##')
#	tput sc
#	tput cup 0 $(($(tput cols)-${#tty}-1))
#	echo -e $tty
#	tput rc
#}
export PROMPT_COMMAND="prompt_header"

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
