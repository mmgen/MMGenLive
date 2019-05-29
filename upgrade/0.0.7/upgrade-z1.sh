#!/bin/bash
#:REV: 0.0.7z1
#:DESC: Install Python 3 cryptography package

. ~/scripts/include/functions.sh

install_cryptography() {
	eval "$APT_GET update"
	eval "$APT_GET upgrade"
	eval "$APT_GET install python3-cryptography"
}

gecho 'Installing Python 3 cryptography package'
set -e; install_cryptography

exit 0
