#! /usr/bin/env bash
: ${FILE_BROWSER=xdg-open}

if [[ $DISPLAY ]] 
then
  typeset -a FM_OPTS
  for arg
  do
    case $arg in
      -*) FM_OPTS+=("$arg") ;;
      *) FM_OPTS+=("$(realpath -L "$arg")") ;;
    esac
  done
  [[ ${FM_OPTS} ]] || FM_OPTS="$PWD"
  cd ${TMPDIR-/tmp}
  $FILE_BROWSER "${FM_OPTS[@]}" < /dev/null &> bd-$$.log &
else
  ls -A "$@"
fi
