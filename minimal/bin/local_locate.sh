#!/bin/sh
#
# Wrapper for locate(1) that also searches .locate/.locate.db from the current
# directory. .locate/.locate.db.lzma is also allowed. Safe to be aliased to
# "locate"
#

### locate variables:
# LOCATE_PATH (colon-separated)

: ${LOCATE="locate"} ${LOCATE_DB_NAME=".locate/locate.db"}
iam="$0"
args="$@"

if [[ -d ".locate/" ]]
then
	if [[ -e "$LOCATE_DB_NAME" ]]
	then
		[[ "$LOCATE_PATH" ]] && myLOCATE_PATH=${LOCATE_PATH}:${LOCATE_DB_NAME} || myLOCATE_PATH=${LOCATE_DB_NAME}
		LOCATE_PATH=$myLOCATE_PATH command $LOCATE $args
	elif [[ -e "$LOCATE_DB_NAME".lzma ]]
	then
		command $LOCATE $args
		lzma -dc "$LOCATE_DB_NAME".lzma | command $LOCATE --database=- $args
	else
		make_locate_database.sh && "$iam" $args
	fi
else
	command $LOCATE $args
fi