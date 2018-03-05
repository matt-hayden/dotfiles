#!/bin/bash
: ${CP='cp -i'} ${MKDIR='mkdir -p'} ${MV='mv -i'}
CMD=
check_for_options=1

for arg
do
	if [[ $arg = -- ]]
	then
		check_for_options=0
		continue
	fi
	if (( $check_for_options ))
	then
		[[ $arg = -* ]] && continue
	fi
	[[ -e "$arg" ]] || $CMD $MKDIR "$arg"
done
case ${0##*/} in
	cp*) $CMD $CP "$@" ;;
	mv*) $CMD $MV "$@" ;;
	*) echo $0: This is crap >&2 ;;
esac
