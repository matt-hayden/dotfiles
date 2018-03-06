#! /usr/bin/env bash
: ${DICT=/usr/share/dict/words}
# Skip all contraction endings
[[ $1 ]] && pattern="$1" || pattern="/['](d|n|s|re|ll|t)$/!p"
# Skip all capitalized words
sed -nr -e '/^[a-z]/,$ p' "$DICT" | sed -nr -e "$pattern"
