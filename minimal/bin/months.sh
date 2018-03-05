#!/bin/bash

name_table_header="#	Abbrv3	MonthName	CommonMispelling"
name_table="01	jan	january	jan
02	feb	February	feb
03	mar	March	mar
04	apr	April	apr
05	may	May	may
06	jun	June	june
07	jul	July	july
08	aug	August	aug
09	sep	September	sep
10	oct	October	oct
11	nov	November	nov
12	dec	December	dec"

three_letters="jan feb mar apr may jun jul aug sep oct nov dec"
three_letters_plus_mis="jan feb mar apr may june july aug sep oct nov dec"
all_letters="january february march april may june july august september october november december"

## default:
dictionary="$three_letters"
newline=0

while getopts ":034achLlpNnUu" opt
do
	case $opt in
		h) echo help; exit ;;
		p) echo $name_table_header; echo $name_table; exit ;;
	esac
	case $opt in
		3) dictionary="$three_letters" ;;
		4) dictionary="$three_letters_plus_mis" ;;
		a) dictionary="$all_letters" ;;
	esac
	case $opt in
		0) echo $dictionary | tr -s [[:space:]] '\000' ;;
		c) echo $dictionary | sed -r 's/(^|[[:space:]])[[:lower:]]/\U&\E/g' ;;
		h) echo help ;;
		L|l) echo $dictionary | tr [A-Z] [a-z] ;;
		N) echo $dictionary | cat -n ;;
		n) echo $dictionary | tr ' ' '\n' ;;
		U|u) echo $dictionary | tr [a-z] [A-Z] ;;
	esac
done

# shift $(($OPTIND - 1))
