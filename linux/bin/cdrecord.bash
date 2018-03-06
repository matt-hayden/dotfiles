#! /usr/bin/env bash
: ${TIMER=/usr/bin/time}

if [[ $XTERM ]] && [[ -t 0 ]] && [[ -t 1 ]]
then
  <&- ${XTERM-x-terminal-emulator} -title cdrecord -hold -e \
    ${TIMER} cdrecord "$@" &
else
  ${TIMER} cdrecord "$@"
fi
