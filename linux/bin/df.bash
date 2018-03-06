#! /usr/bin/env bash

if [[ -t 1 ]]
then
  kwatch.bash df "$@"
else
  df "$@"
fi
