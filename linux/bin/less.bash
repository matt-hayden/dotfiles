#! /usr/bin/env bash

if [[ $DISPLAY ]]
then
  ${XTERM-x-terminal-emulator} -name less -e \
    sh -c "less -R $@ <&3" 3<&0 <&- & disown
else
  less "$@"
fi
