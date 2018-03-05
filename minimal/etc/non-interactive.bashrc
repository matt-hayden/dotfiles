#! /bin/head

# .bashrc for non-login interactive sessions
BASH_LOGFILE=${TMPDIR-/tmp}/$$.log

# Sourcing this file should be completely silent under normal operation, or it
# will interfere with ssh. But, why? The documentation makes me think that only
# interactive shells load .bashrc, yet certain output from .bashrc causes, e.g. a
# bzr connection, to bomb.

source $HOME/etc/shell-functions.bash


# Override the defaults here by setting BASH_ENV, or forming ~/.env like so:
#	env > ~/.env
# Override aliases with:
#	alias -p > ~/.aliases


# root and system leave here
[[ 999 -lt $(id -u) ]] || return


# New environment
if [[ "$BASH_ENV" ]] || [[ -e ~/.env ]]
then
  [[ "$BASH_ENV" ]] || BASH_ENV=~/.env
  env > ~/.env~
  source "$BASH_ENV"
else
  source ~/etc/shrc
fi

### INTERACTIVE ###
# Different ways to test for an interactive shell:
#[ -z "$PS1" ] && return
[[ "$PS1" ]] || return
#[[ $- != *i* ]] && return
#[[ "${-#*i}" != "$-" ]] || return
#case $- in
#  *i*)  ;;
#  * )  return ;;
#esac

# bash 4 only:
#[[ $- =~ i ]] || return

# EOF