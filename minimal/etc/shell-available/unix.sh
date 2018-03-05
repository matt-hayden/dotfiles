#! /usr/bin/env head

if [ -t 1 ]
then
  tput sgr0	# reset terminal
  stty stop undef
  stty start undef
  export GPG_TTY=$(tty)
fi

ulimit -S -c 0	# Don't want any coredumps
umask 027


############################# path preferences ###############################
[ -d "$HOME/info" ] && INFOPATH="$INFOPATH:$HOME/info"

### see manpath
if ! [ -f /etc/man.conf ]
then
	[ -d "$HOME/share/man" ] &&	MANPATH="$MANPATH:$HOME/share/man"
	[ -d "$HOME/man" ] &&		MANPATH="$MANPATH:$HOME/man"
fi

export INFOPATH MANPATH


if ! [ $GZIP ]
then
	gzip --help | grep -qi rsyncable && GZIP='--rsyncable'
fi > /dev/null 2> /dev/null

export GZIP
