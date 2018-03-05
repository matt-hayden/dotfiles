#!/bin/bash
# Issue audible bell on program completion.

case $OSTYPE in
	msys*|cygwin*)
		success_command="echo -ne $'\a'"
		fail_command="echo -ne $'\a\a\a'"
		;;
	darwin*)
		success_command="say OK"
		fail_command="say waah"
		;;
	*)
		if type text_to_speech.bash &> /dev/null
		then
			success_command="echo deeng | text_to_speech.bash"
			fail_command="echo ruhroah | text_to_speech.bash"
		else
			success_command="tput bel"
			fail_command="tput bel bel bel"
		fi
		;;
esac

while getopts "ef:s:" flag
do
	case "${flag}" in
		e) quiet=1 ;;
		f) fail_command="$OPTARG" ;;
		s) success_command="$OPTARG" ;;
		:)
			echo "Option -$OPTARG requires an argument."
			exit 1
			;;
		\?) # Error condition is literal '?'
			cat <<-EOF
	-e		  Beep only on errors, and also if no other arguments
	-f command  Set the fail command (the default is system-dependent)
	-s command  Set the success command (the default is system-dependent)

EOF
			exit 1
			;;
		*) # Should not occur
			echo "Unknown error while processing options"
			;;
	esac
done >&2
shift $((OPTIND-1))

case $# in
	0) eval $success_command ;;
	*)
	eval "$@"; status=$?
	if (( status ))
	then
		eval $fail_command
		exit $status
	elif ! (( quiet ))
	then
		eval $success_command
	fi
	;;
esac
