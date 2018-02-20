#!/bin/bash
#:REV: 0.0.7y
#:DESC: Update MMGen signing keys (add DSA key)

set -e

import_key() {
	echo "Importing DSA signing key"
	(
		cd /setup/git/MMGenLive
		sudo ./build_system.sh setup_sh_usb_import_signing_keys 'IN_MMLIVE_SYSTEM=1'
	)
}

gpg --list-key 'mmgen@tuta.io' >/dev/null 2>&1 || import_key

gpg --list-key 'mmgen@tuta.io' >/dev/null 2>&1

exit 0
