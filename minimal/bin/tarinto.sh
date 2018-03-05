#!/bin/bash
: ${TAR=tar}

{
	tarfile="${@: -1}"
	target="${tarfile%.*}"
	target="${target##*/}"
}

[[ -f "$target" ]] && echo "$target" exists && exit -1
[[ -d "$target" ]] || mkdir "$target"
$TAR -C "$target" $*
