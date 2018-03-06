#! /usr/bin/env bash
# Only return words 8-10 letters long
[[ $1 ]] && pattern="$1" || pattern='.\{8,10\}'

system-words.bash | if [[ -t 1 ]]
then
  grep -x "$pattern" | shuf | column -x | sed G | head.bash
else
  shuf
fi
