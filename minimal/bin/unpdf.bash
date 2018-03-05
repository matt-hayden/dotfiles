#! /usr/bin/env bash
MAKE_DIRS=1

for arg
do
	[[ -s "$arg" ]] || continue
	basename="${arg##*/}"
	dest="${basename%.*}"
	dest="${dest// /_}"
	if ((MAKE_DIRS))
	then
		[[ -d "$dest" ]] || mkdir "$dest"
		pdfimages -list "$arg" > "$dest"/images.list
		wc -l "$dest"/images.list
		pdfimages -p -all "$arg" "$dest"//"$dest"
		pdfinfo "$arg" > "$dest"/info.txt
	else
		pdfimages -p -all "$arg" "$dest"
	fi
done
