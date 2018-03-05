#! /usr/bin/env head
### .bash_profile for login shells; pulls in .bashrc

### Test if critical variables are unset. 
: ${HOME?} ${HOSTNAME?} ${TERM?}
: ${XTERM=xterm}

source ~/etc/non-interactive.bashrc

shopt -s cmdhist globasciiranges histappend histverify cdspell
set -o pipefail # exit status is 0 only if all members in the pipe exit 0
shopt -u mailwarn # Don't want mail checked

# globstar: pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
# nullglob: if * doesn't expand, then a literal * is passed
shopt -s globstar

case $LC_ALL in
  C) ;;
  *) shopt -s globasciiranges ;;
esac

source-parts ~/etc/shell-enabled/*.* &> $BASH_LOGFILE
### On Windows: git bash doesn't know USER. Also, you can set OSTYPE=%OS% on Windows.
#: ${USER=${USERNAME}} ${OSTYPE=`uname -o | tr '[[:upper:]]' '[[:lower:]]'`}
#export USER OSTYPE

## root and system leave here
[[ 999 -lt `id -u` ]] || return
### How to check for a login shell:
shopt -q login_shell || return

### LOGIN SHELLS ###
export LINES COLUMNS
#: ${HISTCONTROL=ignoreboth}
: ${HISTCONTROL=erasedups:ignorespace}
: ${HISTIGNORE="bd:[bf]g:disown:exit:fc *:ecryptfs*private:history *:jobs:openssl enc*:pass *:popd:pwd"}
export HISTCONTROL HISTIGNORE

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# SYSTEMD_PAGER=
# export SYSTEMD_PAGER

[[ -d /media/$USER ]] && CDPATH="${CDPATH-.}:/media/$USER"
export CDPATH

[[ -e $SSH_AUTH_SOCK ]] || eval `$HOME/bin/ssh-agent.bash -s`