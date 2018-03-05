#! /bin/bash
# wrapper for pass, which isn't cool with bash 3 and the old version of gpg shipped with git
: ${PASSWORD_STORE_DIR="$HOME/.password-store"}

if [[ $PASSWORD_STORE_KEY ]]
then	echo Using key id $PASSWORD_STORE_KEY
elif [[ -f ${PASSWORD_STORE_DIR}/.gpg-id ]]
then	PASSWORD_STORE_KEY=$(<"${PASSWORD_STORE_DIR}/.gpg-id")
fi

fi="$1"
fo="$2"
gpg -r ${PASSWORD_STORE_KEY} \
	-o "${PASSWORD_STORE_DIR}/${fo}" \
	-e "${fi}"
