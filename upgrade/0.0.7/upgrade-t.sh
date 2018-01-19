#!/bin/bash
#:REV: 0.0.7t
#:DESC: Upgrade MMGen to version 0.9.5

set -e

function upgrade_mmgen {
	echo "Upgrading MMGen to version '$VER'"
	(
		cd /setup/git/MMGenLive/
		eval "$BUILD_SYSTEM chroot_install_mmgen_user_at_commit 'IN_MMLIVE_SYSTEM=1' 'MMGEN_COMMIT=$VER'"
	)
}

VER='v0.9.5'
echo "Skipping MMGen upgrade to version '$VER'"
echo "The 'mmlive-upgrade' utility will install the latest version automatically"
exit 0
mmgen-tool --version | grep -q 0.9.5 || upgrade_mmgen

exit 0
