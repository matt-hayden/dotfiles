#! /usr/bin/env bash
# see also ipecho.net/plain
: ${CURL='curl -s'}
set -e

if [[ -t 1 ]] & type cowsay &>/dev/null
then
  PAGER='cowsay -f eyes -n'
else
  PAGER=cat
fi

IP=$($CURL "$@" 'https://wtfismyip.com/text')
{ echo "$IP"; dig +noall +answer -x "$IP"; type geoiplookup &>/dev/null && geoiplookup "$IP"; } | $PAGER
