#!/bin/bash
#:REV: 0.0.7p
#:DESC: Upgrade Bitcoin Core to version 0.15.0

VERSION='0.15.0'
CHKSUM='ed57f268d8b5ea5acfcb0666e801cf557a444720d8aed5e812071ab2e2913342'
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

bitcoind --version | head -n1 | grep -q 'v0\.15\.0$' || install_bitcoind

exit 0
