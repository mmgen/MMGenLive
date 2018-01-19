#!/bin/bash
#:REV: 0.0.7w
#:DESC: Upgrade Bitcoin Core to version 0.15.1

VERSION='0.15.1'
CHKSUM='387c2e12c67250892b0814f26a5a38f837ca8ab68c86af517f975a2a2710225b'
set -e

echo "Skipping Bitcoin Core upgrade to version '$VERSION'"
echo "Use the 'mmlive-daemon-upgrade' utility to install the latest version"
exit 0

function install_bitcoind {
	echo "Upgrading Bitcoin Core to version '$VERSION'"
	(
		cd /setup/git/MMGenLive/
		TARGET='chroot_install_bitcoind_version'
		eval "$BUILD_SYSTEM $TARGET 'IN_MMLIVE_SYSTEM=1' 'BITCOIND_VERSION=$VERSION' 'BITCOIND_CHKSUM=$CHKSUM'"
	)
}

bitcoind --version | head -n1 | grep -q 'v0\.15\.1$' || install_bitcoind

exit 0
