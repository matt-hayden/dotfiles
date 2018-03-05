#! /usr/bin/env bash

for arg
do
	mp="$(readlink -f $arg)"
	if mount | grep -q "$mp"
	then
		fusermount -u "$mp"
	else
		echo "$arg" not mounted >&2
	fi
done
