#! /usr/bin/env bash
set -e

cdrwtool -i -d /dev/dvdrw
echo 'hint: multiply free sectors and 2048'
