#!/bin/bash
#:REV: 0.0.7k
#:DESC: Upgrade Bitcoin Core to version 0.14.1

VERSION='0.14.1'
CHKSUM='0c6920a9f3181a95ca029fdac5342b5702569ee441ec2128d19051f281683058'
set -e

echo "Skipping upgrade of Bitcoin Core to version '$VERSION' (newer version available)"
exit 0

function install_bitcoind {
	echo "Upgrading Bitcoin Core to version '$VERSION'"
	(
		cd /setup/git/MMGenLive/
		TARGET='chroot_install_bitcoind_version'
		eval "$BUILD_SYSTEM $TARGET 'IN_MMLIVE_SYSTEM=1' 'BITCOIND_VERSION=$VERSION' 'BITCOIND_CHKSUM=$CHKSUM'"
	)
}

bitcoind --version | head -n1 | grep -q 'v0\.14\.1$' || install_bitcoind

exit 0
