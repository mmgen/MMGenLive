#!/bin/bash
#:REV: 0.0.7b
#:DESC: git-config user,email
#:DESC: clone MMGenLive repo
#:DESC: make bin,doc,scripts directories symlinks

set -e
sudo apt-get update
sudo apt-get install git
git config --global user.email "mmlive@nowhere.com"
git config --global user.name "MMGenLive User"
sudo mkdir -p /setup/git
sudo chown mmgen.mmgen /setup/git
cd /setup/git
[ -d "MMGenLive" ] || git clone https://github.com/mmgen/MMGenLive.git
cd
rm -rf bin doc scripts
GIT_DIR=/setup/git/MMGenLive/home.mmgen
ln -s $GIT_DIR/bin
ln -s $GIT_DIR/doc
ln -s $GIT_DIR/scripts

. ~/scripts/include/functions.sh
echo 'b' > ~/var/revision
becho "Upgrade to revision 'b' successful!"
becho "Ignore the following error message and re-run 'mmlive-upgrade'"
exit 1
