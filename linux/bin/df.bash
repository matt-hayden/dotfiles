#! /usr/bin/env bash

if [[ $DISPLAY ]] && [[ -t 1 ]]
then
  <&- ${XTERM-x-terminal-emulator} -e kwatch.bash \
    df "$@" &
else
  exec df "$@"
fi
