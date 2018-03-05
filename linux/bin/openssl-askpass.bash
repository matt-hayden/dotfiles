#! /usr/bin/env bash
set -e
PATH=$PATH:/usr/lib/openssh
if type gnome-ssh-askpass &>/dev/null
then
  #gnome-ssh-askpass >&3 ; openssl "$@" -pass fd:3
  openssl "$@" -pass file:<(gnome-ssh-askpass)
else
  echo "ssh-askpass-gnome not installed" >&2
fi
