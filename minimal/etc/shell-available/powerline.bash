#! /usr/bin/env head

if type powerline-daemon >&/dev/null
then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  source-first {"$HOME"/.local/lib/python{3.5,2.7}/site-packages,/usr/share}/powerline/bindings/bash/powerline.sh
else
  # ~/.byobu/prompt appears to simply pull in /usr/share/byobu/profiles/bashrc
  source-first ~/.byobu/prompt /usr/share/byobu/profiles/bashrc
fi &> /dev/null
