#! /usr/bin/env head

if type dircolors && [ -s ~/.dircolors ]
then
  eval $(dircolors -b ~/.dircolors)
fi > /dev/null
