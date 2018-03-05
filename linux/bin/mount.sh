#! /bin/sh
: ${SUDO=sudo}

if [ $# -eq 0 ]
then
  if [ $DISPLAY ]
  then
    <&- ${XTERM-x-terminal-emulator} -title mount -e \
      kwatch.bash findmnt &
  else
    exec findmnt
  fi
else
  $SUDO mount "$@"
fi
