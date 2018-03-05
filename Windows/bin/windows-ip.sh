#!/bin/sh

case "$1" in
	addr*)
		shift
		ipconfig "$@"
		;;
	route)
		shift
		#netstat -r "$@"
		route print "$@"
		;;
	*)
		echo "Simulation of Linux-Foundation's IPRoute2 utility ip."
		echo "Only ip addr[ess] and ip route are currently simulated."
	;;
esac