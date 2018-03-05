#! /usr/bin/env bash

: ${size=2g}

[[ -t 1 ]] || RUN=echo

for f
do
  fp="${f%.*}"
  ext="${f##*.}"
  dest="${fp}-part_%d.${ext}"
  $RUN mkvmerge -o "$dest" --link --split size:"$size" "$f"
done
