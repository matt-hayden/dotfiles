#! /usr/bin/env bash

set -e
case $(gsettings get org.gnome.settings-daemon.plugins.power button-power) in
	"'interactive'")
		gsettings set org.gnome.settings-daemon.plugins.power button-power 'suspend'
		;;
esac
