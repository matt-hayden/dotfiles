#! /usr/bin/env bash
set -e

### Simple wrapper to /usr/bin/watch
cmd="$@"
[[ "$cmd" ]] || exec grep -E '^\s*[#]' "${0}"

echo
$TIMER sh -c "$cmd"
return_code=$?
[[ -t 0 ]] || exit $return_code
while read -r -s -n 1 key
do
  case $key in
    $'\x04') break ;; # ctrl-d
    $'\x20') clear ;; # space

    # (p)ager re-runs through your pager
    p) $TIMER sh -c "$cmd" 2>&1 | ${PAGER-less} && exit ;;
    # (q)uit 
    q|Q) break ;;
    # (t)imestamp and re-run
    t) cmd="date ; $cmd" ;;
    # (w)atch re-runs regularly
    w) exec watch -ec $cmd ;;
    # (x) open graphical
    x) exec ${XERM-x-terminal-emulator} -e kwatch.bash "$cmd" < /dev/null ;;
    # Any other key re-runs immediately
    *) echo ;;
  esac
  $TIMER sh -c "$cmd"
done
