#! /usr/bin/env bash

if [[ $DISPLAY ]] && [[ -t 0 ]] && [[ -t 1 ]]
then
  <&- ${XTERM-x-terminal-emulator} -e \
    dmesg -H -w "$@" &
else
  exec dmesg "$@"
fi
