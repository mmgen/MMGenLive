#!/bin/bash
#:REV: 0.0.7j
#:DESC: Upgrade Bitcoin Core to version 0.14.0

VERSION='0.14.0'
CHKSUM='06e6ceeb687e784e9aaad45e9407c7eed5f7e9c9bbe44083179287f54f0f9f2b'
set -e

function install_bitcoind {
	echo "Upgrading Bitcoin Core to version '$VERSION'"
	(
		cd /setup/git/MMGenLive/
		TARGET='chroot_install_bitcoind_version'
		eval "$BUILD_SYSTEM $TARGET 'IN_MMLIVE_SYSTEM=1' 'BITCOIND_VERSION=$VERSION' 'BITCOIND_CHKSUM=$CHKSUM'"
	)
}

bitcoind --version | head -n1 | grep -q 'v0\.14\.0$' || install_bitcoind

exit 0
