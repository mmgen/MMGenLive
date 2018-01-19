#!/bin/bash
#:REV: 0.0.7f
#:DESC: Install unzip and pycurl packages
#:DESC: Upgrade MMGen to commit eb6f7e
#:DESC: Install mmgen-node-tools

set -e

function install_unzip_pycurl {
	echo "Installing packages 'unzip' and 'python-pycurl'"
	eval "$APT_GET update"
	eval "$APT_GET upgrade"
	eval "$APT_GET install unzip python-pycurl"
}

function upgrade_mmgen {
	echo "Upgrading MMGen to commit '$COMMIT'"
	(
		cd /setup/git/MMGenLive/
		eval "$BUILD_SYSTEM chroot_install_mmgen_user_at_commit 'IN_MMLIVE_SYSTEM=1' 'MMGEN_COMMIT=$COMMIT'"
	)
}

function install_node_tools {
	(
		echo "Installing mmgen-node-tools"
		cd /setup/git/node-tools
		sudo python ./setup.py install
	)
}

which unzip >/dev/null && dpkg -l python-pycurl >/dev/null 2>&1 || install_unzip_pycurl

COMMIT='eb6f7ef195bd391174bd6563d0c85b1f1934873f'
# [ -d ~mmgen/src/mmgen-$COMMIT ] || upgrade_mmgen

which btc-ticker >/dev/null || install_node_tools

exit 0
