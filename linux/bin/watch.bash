#! /usr/bin/env bash

if [[ $DISPLAY ]] && [[ -t 0 ]] && [[ -t 1 ]]
then
  <&- ${XTERM-x-terminal-emulator} -name watch -e \
    watch "$@" &
else
  exec watch "$@"
fi
