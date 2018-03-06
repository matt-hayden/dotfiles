#! /usr/bin/env bash

if [[ -t 1 ]]
then
  kwatch.bash tree "$@"
else
  tree "$@"
fi
