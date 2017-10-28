#!/bin/bash
#:REV: 0.0.7s
#:DESC: Install Bitcoin ABC client version 0.15.1 with disclaimer
#:DESC: Install Litecoin client version 0.15.0.1rc1
#:DESC: Configure screensaver to blank screen by default

set -e

function install_abc {
	VERSION='0.15.1'
	SUBVERSION='-abc'
	CHKSUM='159713d24f73ed31bd9aa684b5951255d85de4c70f328838b93ea5d5487c57bb'
	DLDIR_URL='https://download.bitcoinabc.org/0.15.1/linux'
	ARCHIVE='bitcoin-abc-0.15.1-x86_64-linux-gnu.tar.gz'
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

function install_ltc {
	VERSION='0.15.0.1'
	SUBVERSION=''
	CHKSUM='b47171844cbd653cea95de5339259c484f94c5ec2ef69575b78207447b3c763f'
	DLDIR_URL='https://download.litecoin.org/litecoin-0.15.0.1rc1/linux'
	ARCHIVE='litecoin-0.15.0-x86_64-linux-gnu.tar.gz'
	echo "Installing Litecoin version '$VERSION'"
	(
		cd /setup/git/MMGenLive/
		TARGET='chroot_install_bitcoind_archive'
		eval "$BUILD_SYSTEM $TARGET 'IN_MMLIVE_SYSTEM=1' 'VER=$VERSION' 'SUBVER=$SUBVERSION' 'BITCOIND_CHKSUM=$CHKSUM' 'DLDIR_URL=$DLDIR_URL' 'ARCHIVE=$ARCHIVE'"
	)
}

function edit_ss_cfg {
	ed ~/.xscreensaver <<-'EOF'
	/mode:.*one
	s/one/blank/
	wq
	EOF
}

grep -q '^mode:.*one' ~/.xscreensaver && edit_ss_cfg
bitcoind-abc --version | grep -q v0.15.1 || install_abc
litecoind --version | grep -q v0.15.0.1 || install_ltc

exit 0
