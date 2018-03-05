#! /bin/bash
set -e
: ${FFMPEG=ffmpeg} ${MKVMERGE=mkvmerge}

TMPDIR="`mktemp -d`"

intermediate_audio="$TMPDIR"/intermediate_audio.mp3
log="$TMPDIR"/log

successes=0
for arg
do
	filename=`readlink -f "$arg"`
	dirname="${filename%/*}"
	basename="${filename##*/}"
	filepart="${basename%.*}"

	dest="$dirname"
	output="$dest/$filepart-%01d-Roku3.MKV"

	if [[ -e "$output" ]]
	then
		echo Refusing to overwrite "$output"
		continue
	fi
	if ($FFMPEG -nostdin -y -i "$filename" -vn -c:a mp3 "$intermediate_audio" &>"$log") && [[ -s "$intermediate_audio" ]]
	then
		echo Audio extracted from "$arg"
	else
		echo Audio extraction failed on "$arg" >&2
		continue
	fi
	if ($MKVMERGE --link --split size:2G -o "$output" -A "$filename" "$intermediate_audio" &>"$log")
	then
		successes=$((successes+1))
		echo "$successes/$# $arg: OK"
		unlink "$filename"
	else
		echo "$arg" container join failed: see "$output".errors.bz2 >&2
		bzip2 -c "$log" > "$output".errors.bz2 || cp "$log" "$output".errors
		continue
	fi
done
echo "finished $successes/$#"

unlink "$log"
unlink "$intermediate_audio"
