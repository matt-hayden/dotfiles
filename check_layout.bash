#! /usr/bin/env bash
set -e

type lsb_release 2> /dev/null && lsb_release -s -c
grep . /etc/issue.net /etc/debian_version

for cmd in gcc python python3 vim virtualenv
do
	{ type $cmd 2> /dev/null; } && { $cmd --version 2>&1; }
done


if [[ -d ~/src ]]
then
	for repo in ~/src/*
	do
		[[ -e "$repo"/.git ]] && echo Repo in $repo
	done
else
	mkdir ~/src
fi

BUILD_DIR=/build/$USERNAME
if [[ -d $BUILD_DIR ]]
then
	echo Build dir $BUILD_DIR
	df -h $BUILD_DIR
else
	[[ -w /build ]] && mkdir $BUILD_DIR
fi

if [[ -d ~/etc/shell-enabled ]]
then
	echo Shell configs enabled:
	ls ~/etc/shell-enabled
elif [[ ! -d .dotfiles ]]
then
	echo dotfiles not cloned
fi

[[ -s ~/.rnd ]] && ( echo -n 'random seed: ' ; sha256sum .rnd; )
