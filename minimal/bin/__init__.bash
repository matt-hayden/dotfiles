#! /usr/bin/env bash

#this_script=$(realpath -L "$BASH_SOURCE")

function make_aliases() {
	local basedir
	[[ "$1" ]] && basedir="$1" || basedir='.'
	local pathname
	local aname
	for bin in $basedir/*.{bash,csh,sh,py}
	do
		[[ -x "$bin" ]] || continue
		pathname="${bin##*/}"
		# Ignore any filenames that begin __
		{ expr "${pathname}" : '^__' > /dev/null; } && continue
		aname="${pathname%.*}"
		#aname="${aname// /_}"
		type ${aname} 2> /dev/null | sed 's/^[# ]*/# /'
		echo alias ${aname}=${pathname}
	done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]] # we're not sourcing...
then
	make_aliases "${BASH_SOURCE%/*}"
else
	source <(make_aliases "${BASH_SOURCE%/*}")
fi
