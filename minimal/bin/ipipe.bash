#! /usr/bin/env bash
set -e
export PS5="Enter command"

CONFIG_DIR="$HOME/.config/ipipe"
export TMPDIR="$(mktemp -d -t ipipe.XXXXXXXX)"

FILEOUT="$(mktemp -t contents.XXXXXXXX)"

[[ -d "$CONFIG_DIR" ]] && HISTFILE="$CONFIG_DIR/history" || HISTFILE="$(mktemp -t history.XXXXXXXX)"
export HISTFILE

if [[ "$@" ]]
then eval "$@" | pv -l
else             pv -l
fi > "$FILEOUT"

"$HOME/etc/ipipe_term.bash" "$FILEOUT"

