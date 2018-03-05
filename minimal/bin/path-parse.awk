#!/bin/awk -f
## PATH is : separated, with no field separator
BEGIN {RS=":"; FS="\0"}

## a is a hash table of seen values
#!($0 in a) {a[$0]; print}
## shorter version:
!x[$0]++

