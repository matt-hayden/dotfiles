#! /usr/bin/env head

[[ $TERM ]] && tput setaf 1 &> /dev/null || return

source-parts $HOME/etc/shell-available/dircolors.*
#[[ $COLORTERM ]] || export COLORTERM=$TERM
for _c in ls {,v}dir lz{,e,f}grep {,z,bz,lz,xz}{,e,f}grep {r,zip}grep
do
  alias ${_c}="${_c} --color=auto"
done
unset _c
alias tree='tree -C'

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
  
# glory to Apache: http://www.askapache.com/linux/rxvt-xresources.html
function aa_256 () 
{ 
  local o= i= x=`tput op` cols=`tput cols` y= oo= yy=;
  y=`printf %$(($cols-6))s`;
  yy=${y// /=};
  for i in {0..256};
  do
    o=00${i};
    oo=`echo -en "setaf ${i}\nsetab ${i}\n"|tput -S`;
    echo -e "${o:${#o}-3:3} ${oo}${yy}${x}";
  done
}
