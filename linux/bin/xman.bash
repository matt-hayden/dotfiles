#! /usr/bin/env bash
COLUMNS=93
${XTERM-x-terminal-emulator} -name man -e man "$@"
