#! /usr/bin/env bash
while read -r line
do
  echo "${SECONDS}	${line}"
done
