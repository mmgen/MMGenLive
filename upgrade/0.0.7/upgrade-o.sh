#!/bin/bash
#:REV: 0.0.7o
#:DESC: Upgrade MMGen to btc_bch tag version

set -e

function upgrade_mmgen {
	echo "Upgrading MMGen to version '$VER'"
	(
		cd /setup/git/MMGenLive/
		eval "$BUILD_SYSTEM chroot_install_mmgen_user_at_commit 'IN_MMLIVE_SYSTEM=1' 'MMGEN_COMMIT=$VER'"
	)
}

VER='btc_bch'
echo "Skipping MMGen upgrade to version '$VER'"
echo "The 'mmlive-upgrade' utility will install the latest version automatically"
exit 0
[ -d ~mmgen/src/mmgen-$VER ] || upgrade_mmgen

exit 0
