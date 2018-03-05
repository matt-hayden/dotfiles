#! /bin/bash
args=( "${@:-"-"}" )

[[ -t 1 ]] && { type pv &> /dev/null; } && : ${PV:=pv}

WRITE=1
VERBOSE=0
MV="mv -b"

function verify() {
	# argument '-' is treated as regular file
	tf="$(mktemp)"
	for arg
	do
		if python -m json.tool "$arg" > "$tf"
		then
			# passed syntax text, now $tf holds pretty form
			if ! diff -qNa "$arg" "$tf" > /dev/null # note counterintuitive ! diff
			then
				if (($WRITE))
				then
					$MV "$tf" "$arg"
					(($VERBOSE)) && echo $(readlink -f "$arg"): modified
				else
					(($VERBOSE)) && echo $(readlink -f "$arg"): OK
				fi
			elif (($VERBOSE))
			then
				echo $(readlink -f "$arg"): OK
			fi
		else
			echo error: $(readlink -f "$arg") invalid >&2
		fi
	done
}
#
{
for arg in "${args[@]}"
do
	if [[ "$arg" == "-" ]]
	then
		jsonfile=$(mktemp)
		${PV:cat} > "$jsonfile"
		python -m json.tool "$jsonfile"
		continue
	elif [[ -d "$arg" ]]
	then
		verify "$arg"/*.json
	elif [[ -s "$arg" ]]
	then
		verify "$arg"
	else
		echo error: $(readlink -f "$jsonfile") not JSON >&2
	fi
done
}
