#! /usr/bin/env bash
: ${XCLIP=xclip}
set -e

function xclip_cut() {
	$XCLIP < "$1"
	truncate -s 0 "$1"
	unlink "$1"
}

export TMPDIR=$(mktemp -d -t $$.XXXXXXXX)
buffer=$(mktemp -t xclip.XXXXXXXX)
trap "xclip_cut \"$buffer\"" INT TERM EXIT

if qdbus org.kde.klipper &> /dev/null
then
	trap 'qdbus org.kde.klipper /klipper org.kde.klipper.klipper.clearClipboardHistory' INT TERM EXIT
fi

$XCLIP -o > "$buffer" &
sleep "${1-45}"
