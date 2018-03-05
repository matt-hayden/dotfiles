#! /usr/bin/env bash
set -e
# To avoid ptrace attacks, Debian set-gid's the ssh-agent executable. Environmental variables like TMPDIR are not respected.

if [[ ! -e $SSH_AUTH_SOCK ]]
then
  if [[ -w "/var/run/user/$(id -u)" ]]
  then
    SSH_TMPDIR="/var/run/user/$(id -u)/ssh"
    mkdir -p "$SSH_TMPDIR"
    exec ssh-agent -a "$SSH_TMPDIR/agent.$PPID" "$@"
  fi
fi
[[ $SSH_AUTH_PID ]] && echo "WARNING: replacing process $SSH_AUTH_PID" >&2
exec ssh-agent "$@"
