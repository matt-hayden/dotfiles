#! /usr/bin/env bash
: ${FIREWALLCMD="firewall-cmd"}
function whitelist() {
	for arg
	do
		if $FIREWALLCMD -q --zone=drop --query-source "$arg"
		then
			$FIREWALLCMD --zone=drop --remove-source "$arg"
		else
			$FIREWALLCMD --zone=trusted --change-source "$arg"
		fi
	done
}

function blacklist() {
	for arg
	do
		$FIREWALLCMD --zone=drop --change-source "$arg"
	done
}

case $1 in
	bl|black*) shift
		blacklist "$@"
		;;
	wl|white*) shift
		whitelist "$@"
		;;
	*)
		echo Invalid argument: "$@"
		exit -1
		;;
esac
