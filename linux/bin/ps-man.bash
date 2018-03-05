#! /usr/bin/env bash
set -e
[[ -t 1 ]] && [[ -t 2 ]] && [[ $DISPLAY ]] || exec man "$@"

if [[ ! $VIEWER ]]
then
  for cmd in okular evince qpdfview flpsed gv
  do
    type $cmd && VIEWER=$cmd && break
  done
  unset cmd
fi &> /dev/null
if [[ $VIEWER ]]
then
  ps="$(mktemp -t XXXXXXXX.ps)"
  man -t "$@" > "$ps" && ($VIEWER "$ps" &)
else
  man "$@"
fi
