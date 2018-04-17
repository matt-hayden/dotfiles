#! /bin/sh
# BusyBox wget doesn't have the option for headers

#date -s "$(wget -S -O /dev/null google.com 2>&1 | sed -n -e 's/  *Date: *//p' -eT -eq)"
#wget -S -O /dev/null http://www.google.com 2>&1 | sed -n -e 's/  *Date: *//p' -eT -eq
#wget -S -O /dev/null http://www.google.com | sed -n -e 's/  *Date: *//p' -eT -eq
curl -sI http://www.comcast.com | sed -n -e 's/Date: *//p' -eT -eq
#curl -S 'https://time.akamai.com/?iso'
