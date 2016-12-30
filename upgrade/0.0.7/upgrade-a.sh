#!/bin/bash

PATCH1='--- bin/mmlive-node-setup.orig	2016-12-18 18:57:06.845667863 +0000
+++ bin/mmlive-node-setup	2016-12-18 15:35:10.492000000 +0000
@@ -38,6 +38,10 @@
 					[ "$b" -gt $MIN ] && echo $a $b "$(lsblk -n -o SIZE /dev/$a | head -n1)"
 				done
 			))
+	[ "$LARGE_DISKS" ] || {
+		echo "No disks larger than $MIN_DISK_SIZE GB found.  Aborting"
+		exit 1
+	}
 	NUM_LARGE_DISKS=$(echo "$LARGE_DISKS" | wc -l)
 	if [ "$NUM_LARGE_DISKS" -gt 1 ]; then
 		while true; do'
PATCH2='--- mmgen-test	2016-12-18 15:35:56.908000000 +0000
+++ mmgen-test.orig	2016-12-18 19:10:21.903166294 +0000
@@ -21,4 +21,4 @@
 }
 
 cd ~/src/mmgen-*
-test/test.py -Os
+test/test.py -s'

echo "$PATCH1" | patch -N ~/bin/mmlive-node-setup
echo "$PATCH2" | patch -N ~/bin/mmgen-test || true
