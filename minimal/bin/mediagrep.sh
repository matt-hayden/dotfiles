#! /bin/bash
grep_options="$1"
shift
(( $# > 1 )) && grep_options="-H $grep_options"
for arg; do
	mediainfo "$arg" | grep --label="$arg" $grep_options
done | sort
