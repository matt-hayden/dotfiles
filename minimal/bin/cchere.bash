#! /usr/bin/env bash
# gcc doesn't respect CFLAGS and LDLIBS
CFLAGS="$(pkg-config --cflags glib-2.0) $CFLAGS"
export CFLAGS
: ${LDLIBS=$(pkg-config --libs glib-2.0)}
export LDLIBS

# gcc wants all linking flags at the back of the bus
gcc $CFLAGS -fpic -include ~/include/cchere.h "$@" -v -xc - $LDLIBS
