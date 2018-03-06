#! /usr/bin/env bash

if [[ -t 0 ]] && [[ -t 1 ]]
then
  dmesg -H -w "$@"
else
  dmesg "$@"
fi
