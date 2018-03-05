#!/bin/head

[[ -d /opt/local ]] && export PATH=/opt/local/bin:/opt/local/sbin:$PATH

if ! [[ $EDITOR ]]
then
	EDITOR=vim
	alias vi=vim
	export EDITOR
fi

if ! type locate
then
	function locate() {
		echo Setting up locate, database may not be built >&2
		#sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
		if [[ -x /usr/libexec/locate.updatedb ]]
		then
			echo Update the database with:
			echo sudo /usr/libexec/locate.updatedb
		fi >&2
		unset locate
	}
fi

type airport || alias /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport airport
alias chmac='sudo ifconfig en0 ether'

### GNU toolkit:
alias seq='jot -'
for cmd in awk cp du find ls mv sed seq shred sort stat rm xargs
do type g$cmd && alias $cmd=g$cmd
done
###

type eject || alias eject='drutil tray eject'
alias indexdir='sudo mdutil -E'
alias indexfile=mdimport
command -v gls && alias ls=gls
alias mkisofs='hdiutil makehybrid -iso -joliet -o'
alias play=afplay

alias getclip=pbpaste
alias putclip=pbcopy

# old Windowsism:
alias start=open

# unlock a locked file:
alias unlock='chflags uchg'

