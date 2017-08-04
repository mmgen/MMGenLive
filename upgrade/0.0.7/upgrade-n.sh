#!/bin/bash
#:REV: 0.0.7n
#:DESC: Install Bitcoin ABC client with disclaimer

set -e

VERSION='0.14.6'
SUBVERSION='-abc'
CHKSUM='9f37b8ec36a37944b016bbbf07340adb8ba644abb897b2d2e0edeb99ccf709c0'
DLDIR_URL='https://download.bitcoinabc.org/0.14.6/linux'
ARCHIVE='bitcoin-0.14.6-x86_64-linux-gnu.tar.gz'

function do_install {
	echo "Installing Bitcoin ABC version '$VERSION'"
	(
		cd /setup/git/MMGenLive/
		TARGET='chroot_install_bitcoind_archive'
		eval "$BUILD_SYSTEM $TARGET 'IN_MMLIVE_SYSTEM=1' 'VER=$VERSION' 'SUBVER=$SUBVERSION' 'BITCOIND_CHKSUM=$CHKSUM' 'DLDIR_URL=$DLDIR_URL' 'ARCHIVE=$ARCHIVE'"
	)
}

which 'bitcoind-abc' >/dev/null || {
	do_install
	echo -e "${YELLOW}To select the Bitcoin ABC client, run 'mmlive-node-start' with the '-A' switch$RESET"
	echo -e "${YELLOW}This is untrusted software.  No warranty is provided by MMGen.$RESET"
	echo -e "${YELLOW}To minimize your risk, use MMGen only in online/offline mode.$RESET"
}
exit 0
