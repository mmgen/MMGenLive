#!/bin/bash
#:REV: 0.0.7x
#:DESC: Upgrade kernel and microcode with Meltdown and Spectre fixes
#:DESC: Install MMGen v0.9.6 dependencies

. ~/scripts/include/functions.sh

upgrade_kernel() {
	eval "$APT_GET update"
	eval "$APT_GET upgrade"
	eval "$APT_GET install linux-image-generic intel-microcode"
}
remove_old_kernel() {
	eval "$APT_GET remove linux-image-4.4.0-53-generic"
}
install_mmgen_960_prereqs() {
	eval "$APT_GET install python-crypto python-nacl python-pysha3 python-pip"
	eval "$PIP install --upgrade pip"
	eval "$PIP install ed25519ll"
}

gecho 'Upgrading kernel and microcode with Meltdown and Spectre fixes'
set -e; upgrade_kernel

gecho 'Removing old kernel package'
set +e; remove_old_kernel

gecho 'Installing dependencies for MMGen v0.9.6'
set -e; install_mmgen_960_prereqs

yecho 'Please reboot your system for changes to take effect'

exit 0
