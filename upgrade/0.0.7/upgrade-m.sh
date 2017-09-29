#!/bin/bash
#:REV: 0.0.7m
#:DESC: Upgrade Bitcoin Core to version 0.14.2 BIP148

VERSION='0.14.2'
SUBVERSION='-uasfsegwit1.0'
CHKSUM='f07f6c29d63492120ff770ee50875d60354f420ee9272c419dd1321493a6d656'
DLDIR_URL='https://github.com/UASF/bitcoin/releases/download/v0.14.2-uasfsegwit1.0'
ARCHIVE='bitcoin-0.14.2-uasfsegwit1.0-x86_64-linux-gnu.tar.gz'

echo "Skipping upgrade of Bitcoin Core to version '$VERSION' (newer version available)"
exit 0

set -e

function do_install {
	echo "Upgrading Bitcoin Core to version '$VERSION'"
	(
		cd /setup/git/MMGenLive/
		TARGET='chroot_install_bitcoind_archive'
		eval "$BUILD_SYSTEM $TARGET 'IN_MMLIVE_SYSTEM=1' 'VER=$VERSION' 'SUBVER=$SUBVERSION' 'BITCOIND_CHKSUM=$CHKSUM' 'DLDIR_URL=$DLDIR_URL' 'ARCHIVE=$ARCHIVE'"
	)
}

which 'bitcoind-uasfsegwit1.0' >/dev/null || do_install
echo -e "${YELLOW}To select the UASF client, run 'mmlive-node-start' with the '-U' switch$RESET"

exit 0
