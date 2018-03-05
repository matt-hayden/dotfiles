#!/bin/sh
: ${sep='|'} ${DATE="date --iso-8601=seconds"}

start=`$DATE`
if (($#))
then # assume args are a command line, stdin is passed to it
	( eval "$@" 2>&1; es=$? ) | command "$0"
	exit ${es:0}
elif ! [[ -t 0 ]]
then
	while read -r line
	do
		if [[ $line ]]
		then
			end=`$DATE`
			echo "${start}${sep}${end}${sep}${line}"
			start=$end
		fi
	done
fi
