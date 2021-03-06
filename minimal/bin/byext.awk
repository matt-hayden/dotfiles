#! /usr/bin/awk -f
# Intended to be used after a list of file size and filename, like so:
# $ find some_dir some_other_dir -type f -printf '%s\t%p\n' | byext.awk

BEGIN { OFS="\t" }

{
	sub(".*/", "", $2)
	label = sub(/.*[.]/, "", $2) ? $2 : "."
	sizes[label] += $1
	counts[label]++
}

END { for (key in sizes) print ( key, counts[key], sizes[key] ) }
