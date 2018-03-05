#! /usr/bin/env bash

du -S "$@" | pv -l | sort -rn
