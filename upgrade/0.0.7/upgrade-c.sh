#!/bin/bash
#:REV: 0.0.7c
#:DESC: git-config core.pager 
#:DESC: edit privoxy/config to forward socks

set -e

echo 'Installing and configuring privoxy'

. ~/scripts/include/functions.sh

git config --global core.pager "less -R"
[ "$ONLINE" ] && { sudo apt-get --yes update; sudo apt-get --yes install privoxy; }

PC='/etc/privoxy/config'
grep -q ^forward-socks5 $PC || {
	gecho "Editing '$PC'"
	sudo ed $PC  <<EOF
/#\s*forward-socks5.*\s\/\s\s*127.0.0.1:9050
a
forward-socks5t / 127.0.0.1:9050 .
.
p
w
q
EOF
}


[ "$ONLINE" ] && sudo systemctl restart privoxy
