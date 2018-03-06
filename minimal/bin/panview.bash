#! /usr/bin/env bash
: ${COLUMNS=`tput cols} ${VISUAL=sensible-editor}
TMPDIR="$(mktemp -d -t panview.XXXXXXXX)"

function proc() {
  if pandoc -s --columns=$COLUMNS -t markdown "$1" -o "$TMPDIR"/$$.txt
  then
    cat "$TMPDIR"/$$.txt
  fi
}

while getopts em OPT
do
  case "$OPT" in
    e)  function proc() {
        if pandoc -s --no-wrap -t markdown "$1" -o "$TMPDIR"/$$.md
        then
          "$VISUAL" "${TMPDIR}"/$$.md
        fi
      }
      ;;
    m)  function proc() {
        if pandoc -Ss -t man "$1" -o "$TMPDIR"/$$.man
        then
          man "$TMPDIR"/$$.man
        fi
      }
      ;;
    \?)  echo "Usage: $0 [-s] [-d seplist] file ..." >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

for arg
do
  proc "$arg" || exit $?
done
