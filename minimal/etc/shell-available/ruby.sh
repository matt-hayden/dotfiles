#! /usr/bin/env head

### Ruby
RB_USER_INSTALL=true
for _r in $HOME/.gem/ruby/*.*
do
  [ -d "$_r" ] && GEM_PATH="$_r"
  [ -d "$_r/bin" ] && PATH="$PATH:$_r/bin"
done 2> /dev/null
unset _r

export PATH GEM_PATH RB_USER_INSTALL
