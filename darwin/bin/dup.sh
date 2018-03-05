#!/bin/sh
# http://stackoverflow.com/questions/1589114/opening-a-new-terminal-tab-in-osxsnow-leopard-with-the-opening-terminal-window
pwd=`pwd`
osascript -e "tell application \"Terminal\" to do script \"cd $pwd; clear\"" > /dev/null
