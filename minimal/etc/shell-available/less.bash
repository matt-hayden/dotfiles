#! /usr/bin/env head
: ${LESS="-eiqwJMRS --tabs=4"} ${PAGER=/usr/bin/less}
MANPAGER="$PAGER -nR"
export PAGER MANPAGER

if [[ -x ~/.lessfilter ]]
then
  if type lesspipe
  then
    eval $(lesspipe)
  elif type lesspipe.sh
  then
    eval $(lesspipe.sh)
  fi
fi > /dev/null
