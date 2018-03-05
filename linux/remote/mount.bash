#! /usr/bin/env bash

script="$0"
[[ $@ ]] || $script *

for arg
do
	arg="${arg%%/}"
	if ! [[ -d "$arg" ]]
	then
		echo Skipping "$arg" >&2
		continue
	fi
	mp="$(readlink -f $arg)"
	if mount | grep -q "$mp"
	then
		echo "$arg" already mounted >&2
	else
		sshfs "$arg": "$mp"
	fi
done
