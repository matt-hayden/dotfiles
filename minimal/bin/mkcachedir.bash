#! /usr/bin/env bash
tag_identifier="Signature: 8a477f597d28d172789f06886806bc55"

case $# in
	0) echo $tag_identifier > CACHEDIR.TAG ;;
	*)
		for arg # in "$@"
		do
			echo $tag_identifier > "$arg"/CACHEDIR.TAG
		done
		;;
esac
