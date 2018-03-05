#! /usr/bin/env bash
[[ $EDITOR ]] || EDITOR=vi
[[ $PAGER ]] || PAGER="less -is" # default for man
TMPDIR=`mktemp -d`

function proc() {
	[[ $COLUMNS ]] || COLUMNS=`tput cols`
	if pandoc -s --columns=$COLUMNS -t markdown "$1" -o "$TMPDIR"/$$.txt
	then
		cat "$TMPDIR"/$$.txt
	fi
}

while getopts em OPT
do
	case "$OPT" in
		e)	function proc() {
				if pandoc -s --no-wrap -t markdown "$1" -o "$TMPDIR"/$$.md
				then
					"$EDITOR" "${TMPDIR}"/$$.md
				fi
			}
			;;
		m)	function proc() {
				if pandoc -Ss -t man "$1" -o "$TMPDIR"/$$.man
				then
					man "$TMPDIR"/$$.man
				fi
			}
			;;
		\?)	echo "Usage: $0 [-s] [-d seplist] file ..." >&2
			exit 1
			;;
	esac
done
shift $((OPTIND - 1))

for arg
do
	proc "$arg" || exit $?
done
