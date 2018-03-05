#! /usr/bin/env bash
[[ $1 ]] && pattern="$1" || pattern="/'(d|n|s|re|ll|t)$/!p"

if [[ -t 1 ]]
then
  function shuffle() { grep -x '.\{8,10\}' | shuf | column | sed G | head.bash; }
else
  function shuffle() { shuf; }
fi

sed -E -n "$pattern" /usr/share/dict/words | shuffle
