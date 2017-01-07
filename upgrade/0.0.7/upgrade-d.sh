#!/bin/bash
#:REV: 0.0.7d
#:DESC: edit grub.cfg after kernel upgrade, run from rc.local.shutdown
#:DESC: put all grub-* packages on hold

set -e

KVER_UPDATE='/usr/local/sbin/update-grub-cfg-kver.sh'
TMP_FILE=$(tempfile)
RC_LOCAL_SHUTDOWN='/etc/rc.local.shutdown'
HOLD_PKGS=(grub-common grub-gfxpayload-lists grub-pc grub-pc-bin grub2-common)

function hold_grub_packages {
	echo 'Putting not-to-upgrade packages on hold'
	for i in ${HOLD_PKGS[*]}; do echo $i hold | sudo dpkg --set-selections; done
	dpkg --get-selections | grep '\<hold\>'
}

function add_kver_update {
	echo "Creating '$KVER_UPDATE'"
	cat > $TMP_FILE <<'EOFF'
#!/bin/bash

set -e

ver_lib_modules=$(ls /lib/modules | sort -V | tail -n1)
ver_boot=$(ls /boot/initrd.img* | sort -V | tail -n1 | sed 's/.*initrd\.img-//')

[ "$ver_lib_modules" == "$ver_boot" ] || {
	echo "Last kernel version in /lib/modules ($ver_lib_modules)"
	echo "doesn't match last version in /boot ($ver_boot)"
	echo "Will not update grub.cfg file to version '$ver_boot'"
	exit
}

GRUB_CFG='/boot/grub/grub.cfg'
PAT='^set kver='
ver_grub_cfg=$(egrep "$PAT" $GRUB_CFG | sed -r "s/$PAT//" | tr -d "'\"")
if [ "$ver_grub_cfg" == "$ver_boot" ]; then
	echo "Kernel version has not changed, so not updating 'grub.cfg'"
else
	echo "Updating grub.cfg file to version '$ver_boot'"
	ed $GRUB_CFG <<EOF
/$PAT
s/.*/set kver='$ver_boot'/
p
wq
EOF
fi
EOFF

	sudo cp $TMP_FILE $KVER_UPDATE
	sudo chmod 755 $KVER_UPDATE
	rm $TMP_FILE
}

function add_kver_update_to_rc_local_shutdown {
	echo "Adding '$KVER_UPDATE' to '$RC_LOCAL_SHUTDOWN'"
	sudo ed $RC_LOCAL_SHUTDOWN <<EOF
/^exit 0
i

[ -x $KVER_UPDATE ] && $KVER_UPDATE

.
wq
EOF
}

dpkg --get-selections | grep ${HOLD_PKGS[0]} | grep -q hold || hold_grub_packages
[ -f $KVER_UPDATE ] || add_kver_update
grep -q $KVER_UPDATE $RC_LOCAL_SHUTDOWN || add_kver_update_to_rc_local_shutdown

exit 0
