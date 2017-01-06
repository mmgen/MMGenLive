#!/bin/bash

set -e

SUDOERS='/etc/sudoers'
FUNCTIONS=~/scripts/include/functions.sh

function edit_sudoers {
	echo "Editing '$SUDOERS'"
	REPL='Defaults	env_keep="http_proxy HTTP_PROXY https_proxy HTTPS_PROXY all_proxy ALL_PROXY"'
	sudo bash -c ". $FUNCTIONS; cf_insert $SUDOERS '^Defaults' '$REPL'"
}

function install_kramdown_elinks {
	echo "Installing ruby-kramdown and elinks"
	eval "$APT_GET update"
	eval "$APT_GET install ruby-kramdown elinks"
}

sudo grep -q 'http_proxy' $SUDOERS || edit_sudoers
which kramdown elinks >/dev/null || install_kramdown_elinks

exit 0
