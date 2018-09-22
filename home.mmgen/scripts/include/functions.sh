#!/bin/bash

if which infocmp >/dev/null && infocmp $TERM 2>/dev/null | grep -q 'colors#256'; then
	RED="\e[38;5;210m" YELLOW="\e[38;5;228m" GREEN="\e[38;5;157m"
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
			VERSION='0.16.3'
			# https://github.com/bitcoin-core/gitian.sigs
			CHKSUM='5d422a9d544742bc0df12427383f9c2517433ce7b58cf672b9a9b17c2ef51e4f'
			DAEMON_NAME='bitcoind' ;;
		LTC)
			DESC='Litecoin'
			VERSION='0.15.1'
			SUBVERSION=''
			CHKSUM='77062f7bad781dd6667854b3c094dbf51094b33405c6cd25c36d07e0dd5e92e5'
			DLDIR_URL="https://download.litecoin.org/litecoin-${VERSION}/linux"
			ARCHIVE='litecoin-0.15.1-x86_64-linux-gnu.tar.gz'
			DAEMON_NAME='litecoind' ;;
		BCH)
			DESC='Bitcoin ABC'
			VERSION='0.18.2'
			SUBVERSION='-abc'
#			CHKSUM='5eeadea9c23069e08d18e0743f4a86a9774db7574197440c6d795fad5cad2084' # 0.16.2
#			CHKSUM='aa8961e11139ea071e1884e9604e67611b48ee76cdf55d05f9a8dfe25d8feeae' # 0.17.2
			CHKSUM='28d8511789a126aff16e256a03288948f2660c3c8cb0a4c809c5a8618a519a16' # 0.18.2
			DLDIR_URL="https://download.bitcoinabc.org/$VERSION/linux"
			ARCHIVE="bitcoin-abc-${VERSION}-x86_64-linux-gnu.tar.gz"
			DAEMON_NAME='bitcoind-abc' ;;
		XMR)
			DESC='Monerod'
			VERSION='0.12.3.0'
			CHKSUM='72fe937aa2832a0079767914c27671436768ff3c486597c3353a8567d9547487'
			# https://getmonero.org/downloads/#linux
			DLDIR_URL='https://dlsrc.getmonero.org/cli'
			ARCHIVE="monero-linux-x64-v${VERSION}.tar.bz2"
			DAEMON_NAME='monerod' ;;
		ETH)
			DESC='Parity'
			VERSION='1.11.7'
			CHKSUM='792fc2fa2c5653194764218076d86f1c8ea81d3f9410892aae171ec94fe20b1e'
			# https://releases.parity.io/v1.11.7/x86_64-unknown-linux-gnu/parity_1.11.7_ubuntu_amd64.deb.sha256
			DLDIR_URL="https://releases.parity.io/v${VERSION}/x86_64-unknown-linux-gnu"
			ARCHIVE="parity_${VERSION}_ubuntu_amd64.deb"
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

count_disk_passwds() {
	dev=$(sudo cryptsetup status root_fs | grep device | awk '{print $2}')
	sudo cryptsetup luksDump $dev | grep -i slot | grep ENABLED | wc -l
}
