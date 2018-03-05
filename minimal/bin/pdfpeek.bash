#! /usr/bin/env bash
for arg
do
	# Test for OpenOffice content
	zipinfo "$arg" META-INF/manifest.xml &> /dev/null
	case $? in
		0|11) # actual purely zip file
			echo "$arg" may not be a valid PDF >&2
			;;
		1) # 'Hybrid' PDF has a zip signature
			echo "$arg" is a Hybrid ODT, you may want to save as .FODT >&2
			;;
	esac
	pdfinfo "$arg"
	pdftotext "$arg" -
	echo
done
