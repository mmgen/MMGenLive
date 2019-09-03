#!/bin/bash

if which infocmp >/dev/null && infocmp $TERM 2>/dev/null | grep -q 'colors#256'; then
	RED="\e[38;5;210m" YELLOW="\e[38;5;229m" GREEN="\e[38;5;157m"
	BLUE="\e[38;5;45m" RESET="\e[0m"
else
	RED="\e[31;1m" YELLOW="\e[33;1m" GREEN="\e[32;1m" BLUE="\e[34;1m" RESET="\e[0m"
fi

msg()  { echo ${2:+$1} $PROJ_NAME: "${2:-$1}"; }
rmsg() { echo -e ${2:+$1} $RED$PROJ_NAME: "${2:-$1}$RESET"; }
ymsg() { echo -e ${2:+$1} $YELLOW$PROJ_NAME: "${2:-$1}$RESET"; }
gmsg() { echo -e ${2:+$1} $GREEN$PROJ_NAME: "${2:-$1}$RESET"; }
bmsg() { echo -e ${2:+$1} $BLUE$PROJ_NAME: "${2:-$1}$RESET"; }
pause() { ymsg -n 'Paused.  Hit ENTER to continue: '; read junk; }

dbecho() { return; echo -e "${RED}DEBUG: $@$RESET"; }
recho() { echo -e ${2:+$1} "$RED${2:-$1}$RESET"; }
yecho() { echo -e ${2:+$1} "$YELLOW${2:-$1}$RESET"; }
gecho() { echo -e ${2:+$1} "$GREEN${2:-$1}$RESET"; }
becho() { echo -e ${2:+$1} "$BLUE${2:-$1}$RESET"; }

err_exit() { recho "$1"; exit 1; }

exec_or_die() {
	set +x
	eval "$@" || {
		echo -e "$RED$PROJ_NAME: '$@' failed, line number $BASH_LINENO$RESET"
		exit 1
	}
}

cf_write() {
	ACTION='write'
	PAT='^(cf_uncomment|cf_append|cf_edit|cf_insert)$'
	echo -n "${FUNCNAME[1]}" | egrep -q "$PAT" && ACTION=${FUNCNAME[1]/cf_}

	IN=$1 TEXT=$2 REPL=$3 SED_OUT='/tmp/sed.out'
#	echo -e  "$GREEN${ACTION%e}ing $IN $RESET"
	if true; then OUT=$1; else OUT='/tmp/debug.out'; fi # DEBUG
	if [ "$ACTION" == 'append' ]; then
		NLINES=`echo -e "$TEXT" | wc -l`
		A="`tail -n$NLINES $IN`"
		B=`echo -e "$TEXT"`
		[ "$A" == "$B" ] || echo -e "$TEXT" >> $OUT
	elif [ "$ACTION" == 'uncomment' ]; then
		PAT='^#\s*'${TEXT// /\\s*}'\s*'
		sed "s/$PAT/$TEXT/" $IN > $SED_OUT
		cat $SED_OUT > $OUT
	elif [ "$ACTION" == 'edit' ]; then
		sed "s/$TEXT/${REPL//\//\\/}/" $IN > $SED_OUT
		if diff $IN $SED_OUT >/dev/null; then
			return 1
		else
			su -c "cat $SED_OUT > $OUT"
			return 0
		fi
	elif [ "$ACTION" == 'insert' ]; then # insert REPL before first occurrence of TEXT
		LNUM=$(grep -n -m1 "$TEXT" $IN | sed 's/:.*//')
		(head -n$((LNUM-1)) $IN; echo "$REPL"; tail -n+$LNUM $IN) > $SED_OUT
		exec_or_die "cat $SED_OUT > $OUT"
	else
		echo -e "$TEXT" > $OUT
	fi
}
cf_append()    { cf_write "$@"; }
cf_uncomment() { cf_write "$@"; }
cf_edit()      { cf_write "$@"; }
cf_insert()    { cf_write "$@"; }

usb_system_running() {
	ub=($(lsblk -l -o NAME,LABEL | grep MMGEN_BOOT)) ur=${ub%1}2
	ROOT_DEV=$(sudo cryptsetup status root_fs | grep device | awk '{print $2}')
	[ "$ROOT_DEV" == "/dev/$ur" ]
}

daemon_upgrade_set_vars() {
	case $COIN in
		BTC)
			DESC='Bitcoin Core'
			VERSION='0.18.1'
			# https://github.com/bitcoin-core/gitian.sigs
			# https://bitcoin.org/bin/bitcoin-core-0.18.0/SHA256SUMS.asc
			# https://bitcoincore.org/bin/bitcoin-core-0.18.0/SHA256SUMS.asc (signed,laanwj)
			CHKSUM='600d1db5e751fa85903e935a01a74f5cc57e1e7473c15fd3e17ed21e202cfe5a' # 0.18.1
			DAEMON_NAME='bitcoind' ;;
		LTC)
			DESC='Litecoin'
			VERSION='0.16.3'
			SUBVERSION=''
			# https://download.litecoin.org/litecoin-0.16.3/linux/litecoin-0.16.3-linux-signatures.asc (signed)
			CHKSUM='686d99d1746528648c2c54a1363d046436fd172beadaceea80bdc93043805994'
			DLDIR_URL="https://download.litecoin.org/litecoin-${VERSION}/linux"
			ARCHIVE="litecoin-${VERSION}-x86_64-linux-gnu.tar.gz"
			DAEMON_NAME='litecoind' ;;
		BCH)
			DESC='Bitcoin ABC'
			VERSION='0.19.6'
			SUBVERSION='-abc'
			# https://download.bitcoinabc.org/0.18.8/jasonbcox-SHA256SUMS.0.18.8.asc (signed)
			CHKSUM='b84aad1c0061fcafdef1b89cb75e2fc79be8f0a872fad8b1c40eebe59652a2d2'
			DLDIR_URL="https://download.bitcoinabc.org/$VERSION/linux"
			ARCHIVE="bitcoin-abc-${VERSION}-x86_64-linux-gnu.tar.gz"
			DAEMON_NAME='bitcoind-abc' ;;
		XMR)
			DESC='Monerod'
			VERSION='0.14.1.2'
			# https://getmonero.org/downloads/hashes.txt (signed)
			CHKSUM='a4d1ddb9a6f36fcb985a3c07101756f544a5c9f797edd0885dab4a9de27a6228' # 0.14.1.2
			# https://getmonero.org/downloads/#linux
			DLDIR_URL='https://dlsrc.getmonero.org/cli'
			ARCHIVE="monero-linux-x64-v${VERSION}.tar.bz2"
			DAEMON_NAME='monerod' ;;
		ETH)
			DESC='Parity'
			VERSION='2.4.7'
			# https://github.com/paritytech/parity-ethereum/releases/ (no signature!)
			CHKSUM='c43b1b6e208cc505e75ec7e38e4b13064f9a5237e9deb4204d9ad158659b5bb5' # v2.5.2-beta (bad!)
			CHKSUM='8c9211a202750d9d655c6ab819a86774e0fb4086f2c6ad2d14d2df0e45898f8a' # v2.4.7 stable
			DLDIR_URL="https://releases.parity.io/ethereum/v${VERSION}/x86_64-unknown-linux-gnu"
			ARCHIVE='parity'
			DAEMON_NAME='parity' ;;
	esac
}

daemon_test_installed() {
	$DAEMON_NAME --version | grep -q "v${VERSION//./\\.}\>" && return 0
	return 1
}

daemon_upgrade() {
	(
	echo "Installing $DESC version $VERSION"
	cd /setup/git/MMGenLive/
	if [ $COIN == 'BTC' ]; then
		TARGET='chroot_install_bitcoind_version'
		eval "$BUILD_SYSTEM $TARGET 'IN_MMLIVE_SYSTEM=1' 'BITCOIND_CHKSUM=$CHKSUM' 'BITCOIND_VERSION=$VERSION'"
	else
		TARGET='chroot_install_bitcoind_archive'
		eval "$BUILD_SYSTEM $TARGET 'IN_MMLIVE_SYSTEM=1' 'BITCOIND_CHKSUM=$CHKSUM' 'VER=$VERSION' 'SUBVER=$SUBVERSION' 'DLDIR_URL=$DLDIR_URL' 'ARCHIVE=$ARCHIVE'"
	fi
	)
}

relocate_tw_maybe() {
	set -e
	trap "recho 'An error occurred. Can not continue'" ERR

	[ -e "$TW_DIR/wallet.dat" ] && return
	mkdir -p "$TW_DIR"
	[ -e "$DATA_DIR/$TW_FILE" ] || return 0

	gecho "UPGRADE NOTICE: relocating $COIN ${TESTNET:+testnet }tracking wallet to encrypted partition"
	/bin/cp "$DATA_DIR/$TW_FILE" "$TW_DIR/wallet.dat"
	/bin/cp "$DATA_DIR/db.log" "$TW_DIR"
	echo '  Your tracking wallet and associated files have been copied to the encrypted partition.'
	echo -e "  New tracking wallet location: $YELLOW$TW_DIR/wallet.dat$RESET"
	echo -e "  ${BLUE}It's now recommended to securely delete these files at the old location.$RESET"
	echo    "  If you choose not to do this now, you may do so later with the command:"
	echo -e "      ${YELLOW}wipe $DATA_DIR/$TW_FILE $DATA_DIR/db.log$RESET"
	echo -n "  Delete tracking wallet at old location? (y/N): "
	read -n 1
	case "$REPLY" in
		y|Y) echo; wipe -f "$DATA_DIR/$TW_FILE" "$DATA_DIR/db.log" ;;
		*)  [ "$REPLY" ] && echo; becho 'Skipping wallet delete at user request' ;;
	esac
}

count_disk_passwds() {
	dev=$(sudo cryptsetup status root_fs | grep device | awk '{print $2}')
	sudo cryptsetup luksDump $dev | grep -i slot | grep ENABLED | wc -l
}
