#!/bin/bash
#:REV: 0.0.7l
#:DESC: Upgrade MMGen to v0.9.1

set -e

function upgrade_mmgen {
	echo "Upgrading MMGen to version '$VER'"
	(
		cd /setup/git/MMGenLive/
		eval "$BUILD_SYSTEM chroot_install_mmgen_user_at_commit 'IN_MMLIVE_SYSTEM=1' 'MMGEN_COMMIT=$VER'"
	)
}

VER='v0.9.1'
[ -d ~mmgen/src/mmgen-$VER ] || upgrade_mmgen

exit 0
