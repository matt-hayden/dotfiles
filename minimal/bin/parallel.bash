#! /usr/bin/env bash
: ${PARALLEL=/usr/bin/parallel} ${SHELL=/bin/bash}
export SHELL
if [[ -t 2 ]]
then
  [[ -t 0 ]] && $PARALLEL --eta "$@" || $PARALLEL --progress "$@"
else
  $PARALLEL "$@"
fi
