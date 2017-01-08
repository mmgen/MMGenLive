#!/bin/bash
#:REV: 0.0.7f
#:DESC: install unzip and pycurl packages
#:DESC: upgrade MMGen to commit eb6f7ef195bd391174bd6563d0c85b1f1934873f
#:DESC: this rev enables installation of node-tools

set -e

function install_unzip_pycurl {
	echo "Installing packages 'unzip' and 'python-pycurl'"
	eval "$APT_GET install unzip python-pycurl"
}

function upgrade_mmgen {
	echo "Upgrading MMGen to commit '$COMMIT'"
	(
		cd /setup/git/MMGenLive/
		eval "$BUILD_SYSTEM chroot_install_mmgen_user_at_commit 'IN_MMLIVE_SYSTEM=1' 'MMGEN_COMMIT=$COMMIT'"
	)
}

which unzip >/dev/null && dpkg -l python-pycurl >/dev/null 2>&1 || install_unzip_pycurl

COMMIT='eb6f7ef195bd391174bd6563d0c85b1f1934873f'
[ -d ~mmgen/src/mmgen-$COMMIT ] || upgrade_mmgen

exit 0
