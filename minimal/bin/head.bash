#! /usr/bin/env bash
set -e
: ${LINES=`tput lines`}
let head_lines=$(( LINES - 2 ))
head -n $head_lines "$@"
