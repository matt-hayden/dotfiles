#! /usr/bin/env bash
# Only return words 4-8 letters long. This is slightly more than 15 bits of randomness per word on my system.
[[ $1 ]] && pattern="$1" || pattern='.\{4,8\}'

system-words.bash | if [[ -t 1 ]]
then
  grep -x "$pattern" | ushuf.bash -r -n 333 | column -x | sed G | head.bash
else
  ushuf.bash -r
fi
