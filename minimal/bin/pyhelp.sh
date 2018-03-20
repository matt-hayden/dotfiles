#! /bin/sh

[ "$MANPAGER" ] && PAGER="$MANPAGER"

for arg
do
  python3 -c "import $arg; help($arg)" || echo "No help for $arg" >&2
done
