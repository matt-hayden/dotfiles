#! /usr/bin/env bash
: ${WGET=/usr/bin/wget}
[[ -t 2 ]] && $WGET "$@" || $WGET --no-verbose "$@"
