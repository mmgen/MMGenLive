#!/bin/bash
#:REV: 0.0.7g
#:DESC: make ~/Desktop a symlink
#:DESC: install alsa-utils
#:DESC: this rev enables the ticker and alarm clock icons

set -e

function desktop_symlink {
	echo 'Making ~/Desktop a symlink'
	(
	 cd && rm -rf Desktop && ln -s /setup/git/MMGenLive/home.mmgen/Desktop
	)
}

function install_alsa_utils {
	echo "Installing package 'alsa-utils'"
	eval "$APT_GET update"
	eval "$APT_GET upgrade"
	eval "$APT_GET install alsa-utils"
}

[ -L ~/Desktop ] || desktop_symlink
which aplay >/dev/null || install_alsa_utils

exit 0
