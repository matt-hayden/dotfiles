#! /usr/bin/env bash
: ${verbose=0}
if [[ "$@" ]]
then
  now=$(date -I --date="$@")
  verbose=1
else
  now=now
fi


for ndays in 1000 5000 10000 20000 30000 100000
do
  ypart=$(date '+%Y' --date="$now - $ndays days")
  dpart=$(date '+%m%d' --date="$now - $ndays days")
  
  (( verbose )) && echo "${ndays}	days ago was ${ypart}${dpart}"
  
  # quirk of BSD cal:
  (( 1899 < ypart )) && (( ypart < 2000 )) && (( ypart-=1900 ))
  calendar -t ${ypart}${dpart} | grep "\\b${ypart}\\b"
done
