#! /usr/bin/env bash

#case "${0##*/}" in
case "${1}" in
	acro*) shift
		words="$@"
		section=vera
		;;
	comput*) shift
		words="$@"
		section=foldoc
		;;
	thes*) shift
		words="$@"
		section=moby-thesaurus
		;;
	elem*) shift
		words="$@"
		section=elements
		;;
	cia) shift
		words="$@"
		section=world02
		;;
	--help)
		curl 'dict://dict.org/SHOW DB'
		;;
	*)
		words="$@"
		section=english
		;;
esac
for arg
do curl dict://dict.org/d:${1}:${section}
done
