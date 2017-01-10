#!/bin/bash
#:REV: 0.0.7i
#:DESC: Rewrite kernel version auto-update script

set -e

KVER_UPDATE='/usr/local/sbin/update-grub-cfg-kver.sh'
TMP_FILE=$(tempfile)

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

for f in $GRUB_CFG.bak $GRUB_CFG.mmgen.bak; do [ -f $f ] && GRUB_CFG_BAK=$f; done

PAT='^set kver='
ver_grub_cfg=$(egrep "$PAT" $GRUB_CFG_BAK | sed -r "s/$PAT//" | tr -d "'\"")
if [ "$ver_grub_cfg" == "$ver_boot" ]; then
	echo "Kernel version has not changed, so not updating 'grub.cfg'"
else
	echo "Updating grub.cfg file to version '$ver_boot'"
	ed $GRUB_CFG_BAK <<EOF
/$PAT
s/.*/set kver='$ver_boot'/
p
wq
EOF
fi

echo "Restoring '$GRUB_CFG' from '$GRUB_CFG_BAK'"
cp -f $GRUB_CFG_BAK $GRUB_CFG
EOFF

	sudo cp $TMP_FILE $KVER_UPDATE
	sudo chmod 755 $KVER_UPDATE
	rm $TMP_FILE
}

grep -q 'mmgen\.bak' $KVER_UPDATE || add_kver_update

exit 0
