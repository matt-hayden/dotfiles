#! /bin/sh
: ${SUDO=sudo}

[ $# -eq 0 ] && kwatch.bash findmnt || $SUDO mount "$@"
