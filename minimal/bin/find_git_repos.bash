#! /usr/bin/env bash
set -e
: ${FIND=find}

function on_success() { echo "$@" ; }
function on_failure() { echo Not a repo: "$@" >&2 ; }

oldIFS="$IFS"
IFS= $FIND "$@" -ipath '*/.git' -printf '%h\0' | while read -d $'\0' root
do
  if ( cd "$root" && git rev-parse --git-dir ) &> /dev/null
  then
    on_success "$root"
  else
    on_failure "$root"
  fi
done
