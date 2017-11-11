#!/bin/bash
#:REV: 0.0.7v
#:DESC: Install Bitcoin ABC client version 0.16.0 with disclaimer

set -e

function install_abc {
	VERSION='0.16.0'
	SUBVERSION='-abc'
	CHKSUM='132912e57d28adc0dee8ad2beb6322e873310aa0c826b92f8c89a9b14c5b321a'
	DLDIR_URL='https://download.bitcoinabc.org/0.16.0/linux'
	ARCHIVE='bitcoin-abc-0.16.0-x86_64-linux-gnu.tar.gz'
	echo "Installing Bitcoin ABC version '$VERSION'"
	(
		cd /setup/git/MMGenLive/
		TARGET='chroot_install_bitcoind_archive'
		eval "$BUILD_SYSTEM $TARGET 'IN_MMLIVE_SYSTEM=1' 'VER=$VERSION' 'SUBVER=$SUBVERSION' 'BITCOIND_CHKSUM=$CHKSUM' 'DLDIR_URL=$DLDIR_URL' 'ARCHIVE=$ARCHIVE'"
	)
	echo -e "${YELLOW}To select the Bitcoin ABC client, run 'mmlive-node-start' with the '-A' switch$RESET"
	echo -e "${YELLOW}This is untrusted software.  No warranty is provided by the MMGen project.$RESET"
	echo -e "${YELLOW}To minimize your risk, generate seeds and keys and sign transactions OFFLINE.$RESET"
}

bitcoind-abc --version | grep -q v0.16.0 || install_abc

exit 0
