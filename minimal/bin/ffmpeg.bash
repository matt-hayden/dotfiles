#! /usr/bin/env bash
: ${FFMPEG=/usr/bin/ffmpeg -hide_banner}
[[ -t 2 ]] && $FFMPEG "$@" || $FFMPEG -nostdin "$@"
