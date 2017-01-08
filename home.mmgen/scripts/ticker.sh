#!/bin/bash

PROXY_ARG='--proxy socks5h://localhost:9050'

function tor_running {
	return $(netstat -tnlW | grep LISTEN | awk '{ print $4 }' | grep -q ":9050$")
}

if ! tor_running; then
	echo -n 'The ticker can request data over Tor.  Start Tor? (Y/n) '; read
	if echo $REPLY | egrep -q '^(y|Y|)$'; then
		echo 'Starting Tor...'
		eval 'sudo systemctl start tor'
	else
		echo 'Proceeding without Tor'
		PROXY_ARG=
	fi
fi

eval "btc-ticker --resize-window $PROXY_ARG"
# echo -n 'Press ENTER to exit'; read
