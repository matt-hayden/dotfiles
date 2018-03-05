#!/bin/sh
set -e

grep -hvE '^\s*[!]' /usr/share/fonts/X11/*/*.alias /etc/X11/fonts/*/*.alias | \
if [ $# -eq 0 ]
then
	sort | uniq
else
	grep "$@"
fi
