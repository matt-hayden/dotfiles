#! /bin/sh

[ $# -eq 0 ] && set -- *

for arg
do
	[ -f "$arg" ] || continue
	/usr/bin/printf '%q\n' "$arg"
	od -An -t c -t x1 -N4 "$arg"
	echo
done
