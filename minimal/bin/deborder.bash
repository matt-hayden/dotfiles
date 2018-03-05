#! /usr/bin/env bash
# Automatically remove image borders
set -e
[[ $color ]] && CONVERT_OPTIONS="-bordercolor $color -border 1x1"

TMPFILE="/dev/shm/$$.jpg"
trap "rm -f $TMPFILE" EXIT

for arg
do
	if ! [[ -f "$arg" ]]
	then
		echo "Skipping $arg" >&2
		continue
	fi
	if convert "$arg" $CONVERT_OPTIONS -fuzz 15% -trim +repage "$TMPFILE"
	then
		dest="${arg##*/}" # basename
		dest="${dest// /_}"
		mv -b "$TMPFILE" "$dest"
	else
		exit 10
	fi
done
