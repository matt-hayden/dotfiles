#! /usr/bin/env bash
: ${SED=sed -r}

export TMPDIR="$(mktemp -d -t $$.XXXXXXXX)"

declare -a files
for arg
do
	this="$(mktemp)"
	$SED 's/^|$/"/g' "$arg" > "$this" && files+=( "$this" )
done
paste "${files[@]}"
