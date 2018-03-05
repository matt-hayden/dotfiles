#! /usr/bin/env bash

if [[ $DISPLAY ]] && [[ -t 1 ]]
then
  <&- ${XTERM-x-terminal-emulator} -name tree -e \
    kwatch.bash tree "$@" &
else
  exec tree "$@"
fi
