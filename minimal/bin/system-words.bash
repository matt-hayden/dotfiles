#! /usr/bin/env bash
pattern="$1"
# by default, skip all capitalized letters and contractions
[[ $pattern ]] || pattern="[=A-Z=]|[']"
DICT="${2-/usr/share/dict/words}"

grep -vE "$pattern" "$DICT"
