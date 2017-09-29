#!/bin/bash
#:REV: 0.0.7q
#:DESC: Install Intel X drivers, remove xl2tpd
set -e

echo 'Installing Intel X drivers, removing xl2tpd'

function f1 {
	eval "$APT_GET remove xl2tpd"
	eval "$APT_GET update"
	eval "$APT_GET install xserver-xorg-video-intel xserver-xorg-video-qxl"
}

function f2 {
	RC_LOCAL='/etc/rc.local'
	grep -q xl2tpd $RC_LOCAL && {
		echo "Editing '$RC_LOCAL'"
		sudo ed $RC_LOCAL  <<EOF
/xl2tpd
d
w
q
EOF
	}
	return 0
}

f1
f2
exit 0
