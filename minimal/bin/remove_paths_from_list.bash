#! /usr/bin/env bash
# Paths are removed, up to the filename, but comments are respected

sed --in-place='~' '/^[^#]/s|.*/||' "$@"
