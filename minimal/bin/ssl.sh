#! /bin/sh

for arg
do
	case $arg in
		-*)
			opts="$opts $arg"
		;;
		*:*)
			opts="$opts -connect $arg"
		;;
		*)
			opts="$opts -connect ${arg}:443"
		;;
	esac
done
openssl s_client $opts
