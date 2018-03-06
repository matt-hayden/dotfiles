#! /usr/bin/env bash

system-words.bash | if [[ -t 1 ]]
then
  grep -x '.\{8,10\}' | shuf | column | sed G | head.bash
else
  shuf
fi
