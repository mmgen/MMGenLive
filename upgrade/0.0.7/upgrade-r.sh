#!/bin/bash
#:REV: 0.0.7r
#:DESC: Upgrade MMGen to version 0.9.3
#:DESC: Add grub.cfg update hook to apt.conf

set -e

function upgrade_mmgen {
	echo "Upgrading MMGen to version '$VER'"
	(
		cd /setup/git/MMGenLive/
		eval "$BUILD_SYSTEM chroot_install_mmgen_user_at_commit 'IN_MMLIVE_SYSTEM=1' 'MMGEN_COMMIT=$VER'"
	)
}

function edit_apt_conf {
	CF='/etc/apt/apt.conf'
	grep -q update-grub $CF || {
		echo "Editing '$CF'"
		sudo ed $CF  <<EOF
$
a
DPkg::Post-Invoke { "/usr/local/sbin/update-grub-cfg-kver.sh"; };
.
w
q
EOF
	}
	return 0
}

edit_apt_conf

VER='v0.9.3'
echo "Skipping MMGen upgrade to version '$VER'"
echo "The 'mmlive-upgrade' utility will install the latest version automatically"
exit 0
[ -d ~mmgen/src/mmgen-0.9.3 ] || upgrade_mmgen

exit 0
