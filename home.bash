#! /usr/bin/env bash
set -e

# if run with debug, do a dry-run
case $- in
  *x*)
    RSYNC='rsync -nv -F'
    STOW='stow -n -v'
    ;;
  *)
    RSYNC='rsync -F'
    STOW='stow'
    ;;
esac
cd "$HOME/.dotfiles"

cmd="$1"
case $cmd in
  check) shift
    ./check_layout.bash
    ;;
  init|install) shift
    while read -d $'\n' d
    do
      dest="$HOME/$d"
      [[ -L "$dest" ]] && rm "$dest"
      [[ -e "$dest" ]] || mkdir -p "$dest"
    done < directories_not_completely_version_controlled.list
    
    [[ -d /opt/keybase/resources/app/desktop/dist/ ]] && \
           ( cd $HOME/.fonts/truetype ; cp -ns /opt/keybase/resources/app/desktop/dist/*.ttf . )
    [[ -d /usr/lib/firefox/fonts ]] && \
           ( cd $HOME/.fonts/truetype ; cp -ns /usr/lib/firefox/fonts/*.ttf . )
    
    $STOW -S minimal $OSTYPE
    [[ $SSH_TTY ]] || $STOW -S desktop
    [[ -d secret_dotfiles/ ]] && $STOW -S secret_dotfiles
    source ~/etc/shell-functions.bash
    					shell-enable unix
    [[ -s ~/.bash_aliases ]] ||		shell-enable aliases
    [[ $COLORTERM ]] &&			shell-enable colorterm
    [[ $color_term == yes ]] &&		shell-enable colorterm
    case $TERM in
      xterm-color|*-256color)	shell-enable colorterm
	      ;;
    esac
    [[ -d ~/.dh_make ]] &&		shell-enable dh_make
    type gcc &&				shell-enable gcc-dev
    [[ $LESSOPEN ]] ||			shell-enable less
    type node &&			shell-enable node
    type rustc &&			shell-enable rust
    if [[ ! -s ~/.bash_profile ]]
    then
      ./check_layout.bash || true
      cat <<'EOF'
Example .bash_profile:
source ~/.profile
source ~/etc/non-interactive.bashrc # lighter
# source ~/etc/interactive.bashrc # heavy
export CDPATH="${CDPATH-.}":~/src:/build/$USER # for example
EOF
    fi
    ;;
  deinit|remove|uninstall) shift
    $STOW -D minimal secret_dotfiles desktop $OSTYPE
    ;;
  backup) shift
    cd /
    [[ -d GcsBox ]] && gcsbox.bash up -n
    $RSYNC -rt "$@" $HOME/ Nimble:backup/$HOSTNAME/$HOME
    ;;
  *) cat << EOF
Usage:
$0 (install|remove) [stow options] [REPOS] ...  $OSTYPE
$0 (backup) [rsync options]
EOF
    exit 10
    ;;
esac
