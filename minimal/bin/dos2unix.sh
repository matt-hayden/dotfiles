#!/bin/bash
[[ $SED ]] || (type gsed &> /dev/null) && SED=gsed || SED=sed

if ($SED --version 2>&1 | grep -q GNU)
then	SED="$SED -si"
else	SED="$SED -s -i.bak" # BSD: create backup with extension
fi

case ${0##*/} in
	dos2unix*)	$SED -e 's/\r*$//'   "$@" ;;
	unix2dos*)	$SED -e 's/\r*$/\r/' "$@" ;;
	*)			echo Unaware of operation for $0 >&2 ;;
esac
