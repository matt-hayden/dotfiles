#! /usr/bin/env bash
: ${CURL='curl -s'}

diff -y <($CURL "$@" 'https://wtfismyip.com/headers') <($CURL "$@" 'http://wtfismyip.com/headers')
