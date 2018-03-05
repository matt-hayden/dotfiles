#! /usr/bin/env bash
: ${LINES=`tput lines`}
: ${HEAD=/usr/bin/head} ${TAIL=/usr/bin/tail}

let nfiles=0
for arg
do
  : $(( nfiles++ ))
done

let head_lines=$(( LINES - 2 ))
if [[ 1 -lt $nfiles ]]
then
  : $(( head_lines /= nfiles )) $(( head_lines-- ))
fi
[[ $head_lines -lt 2 ]] && head_lines=10

case "${0##*/}" in
  head*) $HEAD -n $head_lines "$@" ;;
  tail*) $TAIL -n $head_lines "$@" ;;
esac
