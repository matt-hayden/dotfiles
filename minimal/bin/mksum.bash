#!/bin/bash
set -e

if ! [[ $JOBS ]]
then
  JOBS=$(nproc --all) || JOBS=$(grep ^siblings /proc/cpuinfo | wc -l)
fi
echo Using $JOBS CPUs >&2

if type gfind &>/dev/null
then FIND=gfind
else FIND=find
fi

if [[ $@ ]]
then FIND_ARGS="$@"
else FIND_ARGS='-not -iname "SHA*SUM*" -not -empty'
fi

$FIND $FIND_ARGS -type f -print0 | parallel -j ${JOBS=1} -0 --progress sha256sum -b :::: -
#sort -k 2 --parallel=$JOBS
