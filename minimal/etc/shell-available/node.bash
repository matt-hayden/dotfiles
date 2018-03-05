#! /usr/bin/env head

[[ -d "$HOME/node_modules/.bin" ]] && PATH="$PATH:$HOME/node_modules/.bin"
export PATH

[[ -d ~/node_modules/tabtab/.completions ]] && source-parts ~/node_modules/tabtab/.completions/*.bash
