#!/bin/bash
#:REV: 0.0.7z2
#:DESC: Upgrade Ubuntu from Xenial to Bionic

. ~/scripts/include/functions.sh

upgrade_ubuntu() {
	eval "$APT_GET -t bionic update"
	eval "$APT_GET -t bionic dist-upgrade"
	eval "$APT_GET remove linux-image-4.4.*generic"
	eval "$APT_GET autoclean"
	eval "$APT_GET autoremove"
}

SOURCES_LIST='/etc/apt/sources.list'
fix_apt_sources_list() {
	sudo ed $SOURCES_LIST <<EOF
%s/xenial/bionic/
wq
EOF
}

set -e

gecho 'Upgrading Ubuntu from Xenial to Bionic'
upgrade_ubuntu

grep -q 'xenial' $SOURCES_LIST && {
	gecho "Fixing $SOURCES_LIST"
	fix_apt_sources_list
}

exit 0
