#!/bin/bash
#:REV: 0.0.7h
#:DESC: Upgrade Bitcoin Core to version 0.13.2


VERSION='0.13.2'
CHKSUM='29215a7fe7430224da52fc257686d2d387546eb8acd573a949128696e8761149'
set -e

echo "Skipping upgrade to version '$VERSION' (newer version available)"
exit 0

function install_bitcoind {
	echo "Upgrading Bitcoin Core to version '$VERSION'"
	(
		cd /setup/git/MMGenLive/
		TARGET='chroot_install_bitcoind_version'
		eval "$BUILD_SYSTEM $TARGET 'IN_MMLIVE_SYSTEM=1' 'BITCOIND_VERSION=$VERSION' 'BITCOIND_CHKSUM=$CHKSUM'"
	)
}

bitcoind --version | head -n1 | grep -q 'v0\.13\.2$' || install_bitcoind

exit 0
