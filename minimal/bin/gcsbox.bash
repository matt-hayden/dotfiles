#! /usr/bin/env bash
# exit the script on all errors, rather than plowing through them
set -e

# Config file is supposed to be here:
[[ -s ~/.config/GcsBox.conf ]] && source ~/.config/GcsBox.conf

### Instructions:
## Where is the local directory that will be synchonized with Google Cloud Storage?
: ${MYBOX=$HOME/GcsBox}

## Installation:
##  0) Install the Google Cloud SDK utilities (run this script with argument install)
##    - optionally install the crcmod package on your Python 2.7:
##      pip2 install --user crcmod
##  1) Dedicate a Google Cloud bucket (see gsutil mb) and enter it's name here:
: ${BUCKET=$USER-private} ${SUBDIR=GcsBox/$USER}
##  2) Create a directory in that bucket with a username

## For FUSE filesystem access: (not necessary to sync)
##  0) Enable gcsfuse:
##    - https://github.com/GoogleCloudPlatform/gcsfuse/blob/master/docs/installing.md
##  1) Dedicate a local mountpoint for filesystem access and enter it here:
: ${MOUNTPOINT=$HOME/gcloud/$BUCKET}

DEPS="gsutil" # space-separated list of commands this script depends on
# example: DEPS="gsutil findmnt fusermount gcsfuse"

[[ $SUBDIR ]] && dest="gs://$BUCKET/$SUBDIR" || dest="gs://$BUCKET"
# Python regular expression matching filenames to ignore:
EXCLUDES='[.]dropbox([.]cache)?$|[.]swp$|[.]Trash$'

# The official method for installing the gsutil dependency
function install_sdk() {
  curl https://sdk.cloud.google.com | bash
}

# This if syntax defines defines the same function in two different plans
# depending on whether the variable SUBDIR is empty:
if [[ $SUBDIR ]]
then
  function mount() {
    gcsfuse --only-dir "$SUBDIR" \
      $BUCKET "$MOUNTPOINT"
  }
else
  function mount() {
    gcsfuse $BUCKET "$MOUNTPOINT"
  }
fi
# Not all programming languages allow that.

function umount() {
  fusermount -u "$MOUNTPOINT"
}

function is_mounted() {
  findmnt "$MOUNTPOINT" > /dev/null
}

function GcsBox_diff() {
  if [[ "$@" ]]
  then
    for arg
    do
      command diff -r "$MOUNTPOINT"/"$arg" "$MYBOX"/"$arg"
    done
  else
    command diff -r "$MOUNTPOINT" "$MYBOX"
  fi
}
###


# We leave here if this script is not being run as a command:
[[ "${BASH_SOURCE[0]}" != "${0}" ]] && return

# I'm using a custom function 'err' to report objections. This allows me to change all error reporting at one single point, rather than editing through the entire script.
if [[ -t 0 ]] # if running with a user interface
then
  function err() {
    echo "$@" >&2
  }
else
  function err() {
    echo ${SECONDS}s "$@" >&2
  }
  ## Elaborate error-handling helps when running without a user interface
  trap 'err error on line ${LINENO} exited $?' ERR
  function exit_report() {
    return_code=$?
    (( $return_code )) || echo ${0} finished `date` after ${SECONDS}s
  }
  trap exit_report EXIT
  echo ${0} started at `date`
fi


# Investigate dependencies
for cmd in $DEPS
do
  type $cmd > /dev/null || exit 9
done

#[[ -d "$MOUNTPOINT" ]] || mkdir -p "$MOUNTPOINT"
#if ! [[ -d "$MOUNTPOINT" ]]; then
#  err "$MOUNTPOINT not created"
#  exit 10
#fi


### Parse command-line arguments
# case is a special, but very old, syntax. When parsing command line arguments (which run from ${1} to ${9}, as in first through ninth words on the command line) you'll see case and shift used like so:
case ${1} in
  install) shift
    install_sdk ;;
  mount) shift
    [[ "${1}" ]] && MOUNTPOINT="${1}"
    shift
    mount ;;
  umount|unmount) shift
    umount ;;
  check) shift
    echo -n "$MOUNTPOINT mounted: " ; is_mounted && echo yes || echo no
    ;;
  used) shift
    gsutil du -s $dest
    ;;
  ls) shift
    # The variable $@ refers to all command-line arguments. When quoted, "$@" allows filenames with spaces to be arguments. This is the most common form, "$@"
    if [[ "$@" ]] # if we have any command-line arguments
    then
      for arg
      do
        gsutil ls $dest/"$arg"
      done
    else
      gsutil ls $dest
    fi
    ;;
  up) shift
    # -d allows deletion on the right-hand-argument
    # -x accepts a Python regular expression
    gsutil -m rsync -r "$@" -x "$EXCLUDES" "$MYBOX" $dest
    ;;
  down) shift
    # -d allows deletion on the right-hand-argument
    # -x accepts a Python regular expression
    gsutil -m rsync -r "$@" -x "$EXCLUDES" $dest "$MYBOX"
    ;;
  diff) shift
    GcsBox_diff "$@"
    ;;
  *)
    err command \'"$@"\' not recognized
    echo ${0} install mount umount check used ls up down diff
    exit 1
    ;;
esac
