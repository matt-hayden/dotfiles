#! /usr/bin/env bash

find "$@" -printf '%s\t%p\n' | pv -l | sort -rn
