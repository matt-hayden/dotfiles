#! /usr/bin/env bash
set -o errexit
BASE64='openssl base64' # BASE64='busybox base64'


function is_base64() {
	egrep -q '^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$' "$@"
}

if (( $# ))
then
	for arg
	do
		if is_base64 "$arg"
		then
			$BASE64 -d < "$arg" | xzcat
		else
			output_filename="${arg}.base64"
			if [[ -s "$output_filename" ]]
			then
				mv "$output_filename" "${output_filename}~"
			fi
			xz -cz "$arg" | $BASE64 > "$output_filename"
		fi
	done
else
	xz -cz | $BASE64
fi
