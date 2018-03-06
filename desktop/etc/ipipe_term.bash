#! /usr/bin/env bash
set -e

: "${FILEIN=$1}" "${VISUAL=vim}"

history -n || echo exit > "$HISTFILE"
while [[ -s "$FILEIN" ]]
do
  read -e -r -p "$PS5 (Enter : to edit, nothing to quit) " cmd
  case "$cmd" in
    \:) "$VISUAL" "$FILEIN" ;;
    '') break ;;
    *)
        history -s "$cmd"
        if < "$FILEIN" eval $cmd
        then last_cmd="$cmd"
        else echo -n "(Exited ${?}) "
        fi
      ;;
  esac
done
echo "< \"$FILEIN\" $last_cmd"
history -a
