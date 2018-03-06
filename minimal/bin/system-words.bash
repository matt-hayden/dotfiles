#! /usr/bin/env bash
[[ $1 ]] && pattern="$1" || pattern="/'(d|n|s|re|ll|t)$/!p"
sed -E -n "$pattern" /usr/share/dict/words
