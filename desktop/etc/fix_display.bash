#! /bin/sh
# I guess?

TMPDIR="$(mktemp -d -t xsession.XXXXXXXX)"
export TMPDIR

xrandr --output LVDS1 --primary

## This doesn't work in Ubuntu 16+
[ -s "$HOME/.Xmodmap" ] && xmodmap "$HOME/.Xmodmap"

# .Xresources merged already

# Disable faulty GNOME Keyring SSH handling
# You may also need to delete ~/config/autostart/*ssh*
[ $GNOME_KEYRING_CONTROL ] && gnome-keyring-daemon --replace --components=secrets,pkcs11
[ $SSH_AGENT_PID ] || eval `$HOME/bin/ssh-agent.bash -s`
