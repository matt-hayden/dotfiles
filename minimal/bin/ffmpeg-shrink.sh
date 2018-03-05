#! /bin/bash
# SCALE='iw/2:-1'
: ${FFMPEG=ffmpeg} ${SCALE='0.25:0.25'}
for arg; do
	basename="${arg##*/}"
	ofn="scaled-$basename"
	if "$FFMPEG" -i "$arg" -vf scale="$SCALE" "$ofn" &>log
	then trash log
	else mv log "${ofn}.errors"
	fi
done
