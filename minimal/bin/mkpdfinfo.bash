#! /usr/bin/env bash
set -e

show_filename=1

case $# in
	0) "$0" *.* ;;
	1) show_filename= ;;
esac

for arg
do
  [[ -f "$arg" ]] || continue # recursion not supported
  [[ $show_filename ]] && echo "Filename:	$arg"
  pdfinfo -l 1 "$arg" | grep -vE '[:]\s*$'
  echo
done
