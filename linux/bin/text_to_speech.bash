#! /usr/bin/env bash
type pico2wave > /dev/null || exit

TMPDIR=`mktemp -d`

# fallback could be padsp recite
PIPE=$TMPDIR/$$.wav
mkfifo $PIPE
while IFS='' read -r line
do
	[[ $line ]] || continue
	nice pico2wave -l en-GB --wave=$PIPE "$line" &
	paplay $PIPE
done
