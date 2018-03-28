# dotfiles #

Clone this somewhere memorable, like ~/.dotfiles

Required packages:

 * stow

## Utilities ##

File | Use
--- | ---
check_layout.bash | Enumerate common system facilities
home.bash | Run `.dotfiles/home.bash install`

directories_not_completely_version_controlled.list
These directories will be created (empty) to prevent linking by stow

## Major Sections ##
Folder | Use
--- | ---
desktop | X win stuff
minimal | Server-side stuff
secret_dotfiles | Example of a link to, say, keybase

## Operating System specific sections ##

Ought to be selected automatically in `home.bash`

Folder | Use
--- | ---
darwin | BSD customizations
darwin10.8.0 |
linux | GNU (as in, not BSD) customizations
linux-gnu |
linux-gnueabihf | ARM-specific
Windows | Basically unmaintained

