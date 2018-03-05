#! /usr/bin/env bash
set -e
# CONVERT_OPTIONS="-border 1x1 -bordercolor white -fuzz 13% -trim +repage"

TMPFILE="/dev/shm/$$.jpg"
trap "rm -f $TMPFILE" EXIT

lhs=
rhs=

for arg
do
	if [[ "$lhs" ]]
	then
		rhs="$arg"
	else
		lhs="$arg"
	fi
	if [[ "$lhs" ]] && [[ "$rhs" ]]
	then
		[[ -f "$lhs" ]]
		[[ -f "$rhs" ]]
		if convert "$lhs" "$rhs" +append $CONVERT_OPTIONS "$TMPFILE"
		then
			dest="${lhs##*/}" # basename
			dest="${dest// /_}"
			mv -b "$TMPFILE" "$dest"

			lhs=
			rhs=
		else
			exit 10
		fi
	fi
done
