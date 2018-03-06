#! /usr/bin/env bash

if [[ ! "$@" ]] && [[ -t 1 ]]
then
  : ${LINES=`tput lines`}
  let head_lines=$(( LINES - 2 ))
  args="-n $head_lines"
fi

case "${0##*/}" in
  head*) head $args "$@" ;;
  tail*) tail $args "$@" ;;
esac
