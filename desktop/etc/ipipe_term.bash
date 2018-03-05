#! /usr/bin/env bash
set -e

: "${FILEIN=$1}"

history -n || echo exit > "$HISTFILE"
while read -e -r -p "$PS5 (Enter : to edit, nothing to quit) " cmd
do
	[[ "$cmd" ]] || break
	if [[ "$cmd" == ":" ]]
	then "$EDITOR" "$FILEIN"
	else
		history -s "$cmd"
		eval $cmd < "$FILEIN" || echo -n "(Exited ${?}) "
	fi
	[[ -s "$FILEIN" ]] || break
done
history -a
