#!/bin/bash
#:REV: 0.0.7c
#:DESC: Add core.pager to git config
#:DESC: Edit /etc/privoxy/config to forward to Socks proxy

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
