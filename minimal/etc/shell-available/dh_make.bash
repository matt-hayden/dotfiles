#! /usr/bin/env head

if [[ -s ~/.dh_make ]]
then
  source-parts ~/.dh_make
  export DEBEMAIL DEBFULLNAME
fi
