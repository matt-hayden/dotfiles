#! /usr/bin/env bash
: ${CURL=/usr/bin/curl}
[[ -t 2 ]] && $CURL "$@" || $CURL -sS "$@"
