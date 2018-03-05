#! /usr/bin/env bash

function get_colors() {
	awk '/^\s*[!]/{next} {printf "#%02x%02x%02x\t%s\n", $1, $2, $3, $0}' \
		/usr/share/X11/rgb.txt
}

if [[ "$@" ]]
then
	# Note $* is used here intentionally over $@
	get_colors | grep -i "$*"
else
	get_colors
fi
