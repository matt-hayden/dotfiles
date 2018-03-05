#! /usr/bin/env bash
set -e

if ! [[ $SUDO ]]
then
  SUDO=sudo
  case $(id -u) in
    0) SUDO= ;;
  esac
fi

echo Expect to finish at $(date --date="now + 828 seconds") >&2
if $SUDO cdrecord -eject -sao dev=/dev/dvdrw driveropts=burnfree "$@"
then
  echo Finished in $SECONDS seconds >&2
else
  status=$?
  (( status == 130 )) && eject -t
  exit $status
fi

