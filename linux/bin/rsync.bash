#! /usr/bin/env bash

if [[ $DISPLAY ]] && [[ -t 1 ]]
then
  <&- ${XTERM-x-terminal-emulator} -title rsync -e \
    "${TIMER}" rsync "$@" &
else
  exec "${TIMER}" rsync "$@"
fi
