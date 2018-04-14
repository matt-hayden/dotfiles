#! /usr/bin/env head
: ${SUDO=sudo}
# Override these defaults with alias > ~/.aliases

if [[ -e ~/.aliases ]]
then
  source-parts ~/.aliases # allows .aliases to be a directory of .bash files
  return
fi


alias dc=cd
alias chmox='chmod +x'

alias airodump-ng="$SUDO airodump-ng"
alias argon2=argon2-cli
if type dpkg
then
  alias aptfiles='dpkg-query -L'
  alias deps='apt-rdepends --build-depends --follow=DEPENDS'
  alias install="$SUDO apt install"
  alias pkggrep='dpkg-query -l'
  alias search='apt search'
fi
alias blkid="$SUDO blkid"
alias burn=burn.bash
alias cdrecord=cdrecord.bash
alias curl=curl.bash
alias df=df.bash
alias dmesg=dmesg.bash
if type dnf
then
  alias dnffiles='rpm -q -l'
  alias install="$SUDO dnf install"
  alias pkggrep='rpm -q -a | grep'
  alias search='dnf search'
fi
alias envgrep='env | grep'
alias ffmpeg=ffmpeg.bash
alias fold='fold -s -w 72'
if type gcloud
then
  alias activate='gcloud config configurations activate'
else
  alias activate='pkggrep google-cloud-sdk; echo'
fi
alias gimp='DISPLAY=:0.0 gimp-2.9'
if type git
then
  for _c in branch checkout commit fetch merge push
  do
    type "${_c}" || alias ${_c}="git ${_c}"
  done
fi
[[ -s ~/etc/greek.txt ]] && alias greek='cat -n ~/etc/greek.txt | grep -i'
type gzcat || alias gzcat=zcat
alias head=head.bash
alias ldgrep='ldconfig -p | grep'
alias less=less.bash
alias lineargs="xargs -d $'\n'"
alias mkpasswd="mkpasswd -m sha-256 -R 1000000"
alias mkvmerge=mkvmerge.bash
alias mount=mount.bash
alias ncdu=ncdu.bash
alias od='od -Ad'
type play || alias play='canberra-gtk-play --file'
alias psgrep='pgrep -a'
alias ptmp='pushd $(mktemp -d)'
alias pycheck='python -m py_compile'
alias py3check='python3 -m py_compile'
alias rm='rm -i'
alias rsync=rsync.bash
[[ -s ~/etc/russian.txt ]] && alias russian='cat -n ~/etc/russian.txt | grep -i'
type say || function say() { text_to_speech.bash <<< "$@"; }
[[ -s ~/etc/services ]] && function portnum { grep -hi "$@" /etc/services ~/etc/services; }
alias shcheck='bash -n'
alias sign='keybase sign -d'
if type systemctl
then
  for _c in start stop restart reload
  do  
    alias ${_c}="$SUDO systemctl ${_c}"
  done
fi
alias ta='touch -a'
alias taa='tee -a'
alias tail=tail.bash
if type tnef
then
  alias winmail_dat=tnef
else
  alias winmail_dat='pkggrep tnef; echo'
fi
alias watch=watch.bash
alias wget=wget.bash
alias xtar='tar --exclude-caches --exclude-vcs --exclude-vcs-ignores'
if type yum
then
  alias yumfiles='rpm -q -l'
  alias install="$SUDO yum install"
  alias pkggrep='rpm -q -a | grep'
  alias search='yum search'
fi
type gzcat || alias gzcat=zcat
unset _x _c
