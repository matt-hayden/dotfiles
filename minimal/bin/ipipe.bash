#! /usr/bin/env bash
set -e

FILEOUT="/dev/shm/content.$$"

if [[ -d "$HOME/.config/ipipe" ]]
then
	HISTFILE="$HOME/.config/ipipe/history"
else
	HISTFILE="/dev/shm/ipipe_history"
fi
export HISTFILE

export PS5="Enter command"

if [[ "$@" ]]
then
	eval "$@" | pv > "$FILEOUT"
else
	pv > "$FILEOUT"
fi

${XTERM-x-terminal-emulator} -e "$HOME/.local/lib/ipipe_term.bash" "$FILEOUT" < /dev/null
[[ -s "$FILEOUT" ]] && echo "$FILEOUT"

