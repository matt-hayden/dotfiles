#!/bin/sh
# http://stackoverflow.com/questions/1589114/opening-a-new-terminal-tab-in-osxsnow-leopard-with-the-opening-terminal-window

pwd=`pwd`
osascript -e "tell application \"Terminal\"" \
	  -e "tell application \"System Events\" to keystroke \"t\" using {command down}" \
	  -e "do script \"cd $pwd; clear\" in front window" \
	  -e "end tell" > /dev/null

