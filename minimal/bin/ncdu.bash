#! /usr/bin/env bash
: ${NCDU=/usr/bin/ncdu}
[[ -t 0 ]] && [[ -t 1 ]] && exec $NCDU "$@"
[[ -t 0 ]] || exec $NCDU -f -
[[ -t 1 ]] || exec $NCDU -o -
