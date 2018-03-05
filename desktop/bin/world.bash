#! /usr/bin/env bash

# World Clock

# Set your foreign time zones in ~/.config/world.conf

# Install github.com/vain/asciiworld for fun

set -e
: ${COLUMNS=`tput cols`} ${LINES=`tput lines`} ${LABEL_FORMAT='%-32s'}

config="$HOME/.config/world.conf"

while getopts ":c:t:" opt; do
  case ${opt} in
    c) config="$OPTARG" ;;
    t) timestamp="$OPTARG" ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
    :)
      echo "Invalid option: $OPTARG requires an argument" >&2
      ;;
  esac
done
shift $((OPTIND -1))

if [[ "$timestamp" ]]
then
  function world_time() {
    for arg
    do
      z="$arg"
      printf "$LABEL_FORMAT" "$z"
      # Show the local time when it'll be $timestamp in each location
      date --date="TZ=\"$z\" $timestamp"
    done
  }
else
  function world_time() {
    for arg
    do
      z="$arg"
      printf "$LABEL_FORMAT" "$z"
      # Show the destination time now
      TZ="$z" date
    done
  }
fi

[[ "$config" ]] && sed -n '/\s*[#].*/!p' "$config" | while IFS=$'\n' read z
do
  [[ "$z" ]] && world_time "$z"
done
world_time "$@"
if [[ "$timestamp" ]] || type asciiworld &> /dev/null
then
  echo
  asciiworld -w $COLUMNS -h $(( LINES-8 )) -s -t "`date`"
fi
