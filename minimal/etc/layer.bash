#! /usr/bin/env bash
set -e
[[ -w /dev/shm ]] && TMPDIR=/dev/shm
TMPDIR=`mktemp -d`

for arg
do
	basename="${arg#*/}"
	filepart="${basename%.*}"
	output_dir=$TMPDIR/$filepart
	mkdir -p "$output_dir"
	output_zip="${arg%.*}_layers.zip"
	[[ -e "$output_zip" ]] && echo WARNING: "$output_zip" exists >&2
	gawk -f layer.awk output_dir="$output_dir" "$arg"
	zip -j -m -r "$output_zip" "$output_dir"
done
