#! /usr/bin/env bash
eval "$@" || { [[ -t 0 ]] && read -r -s -n 1 key ; }
