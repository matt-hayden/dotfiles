#! /usr/bin/env bash
find "$@" -iname delme -prune -ok trash '{}' \;
