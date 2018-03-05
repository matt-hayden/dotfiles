#! /usr/bin/env bash

if [[ $DISPLAY ]]
then
	${XTERM-x-terminal-emulator} -name less -e pause_on_error.bash less -eR "$@" &
else
	less -eFR "$@"
fi
