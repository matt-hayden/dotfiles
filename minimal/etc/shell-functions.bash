#! /bin/head

SHELL_LIB_DIR=$HOME/etc/shell-available
SHELL_RUN_DIR=$HOME/etc/shell-enabled

function shell-available() {
  # TODO: this ain't pretty
  diff -s "$SHELL_LIB_DIR" "$SHELL_RUN_DIR"
}

function source-parts() {
  for arg
  do
    if [[ "$arg" ]]
    then
      if [[ -d "$arg" ]]
      then
        IFS=$'\t\n' source "${arg}"/*.bash
      elif [[ -s "$arg" ]]
      then
        source "${arg}"
      fi
    fi
  done
}

function source-first() {
  for arg
  do
    if [[ "$arg" ]]
    then
      if [[ -d "$arg" ]]
      then
        IFS=$'\t\n' source "${arg}"/*.bash
        break
      elif [[ -s "$arg" ]]
      then
        source "${arg}"
        break
      fi
    fi
  done
}

function shell-enable() {
  mkdir -p $SHELL_RUN_DIR
  for arg
  do
    cp -vsn -t $SHELL_RUN_DIR $SHELL_LIB_DIR/${arg}.*
  done
}

function shell-disable() {
  [[ -d $HOME/etc/shell-enabled ]] || return 0
  for arg
  do
    for f in $SHELL_RUN_DIR/${arg}.*
    do
      if [[ -h "$f" ]]
      then
        rm -vi "$f"
      else
        echo Not removing "$f" >&2
      fi
    done
  done
}
