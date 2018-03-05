#! /usr/bin/env bash

LANG=C # for xterm
if [[ $DISPLAY ]] && [[ -t 0 ]] && [[ -t 1 ]]
then
  <&- ${XTERM-x-terminal-emulator} -e \
    htop "$@" &
else
  exec htop "$@"
fi
