#!/usr/bin/env bash

###################################
# sudo visudo
# or
# nano /etc/sudoers.d/yomun
#
# yomun   ALL=(ALL) NOPASSWD: ALL
###################################
ID="jasonmun@yahoo.com"
UID="yomun"
DIR="/home/yomun"
###################################

chmod 755 ${DIR}/.local/share/gnome-shell/extensions/${ID}

cd ${DIR}/.local/share/gnome-shell/extensions/${ID}

# disable extension
gnome-shell-extension-tool -d ${ID}

# delete caches
rm -rf maps/*
rm -rf ovpn/*

# Zip
sudo chown -R root:root *
zip -r ${ID}.zip . -x \*.git* \*.idea* \others\* \locale\*.txt
sudo chown -R ${UID}:${UID} *

# Zip move to Desktop
mv ${ID}.zip ${DIR}/Desktop

# enable extension
gnome-shell-extension-tool -e ${ID}

# restart gnome-shell
dbus-send --type=method_call --print-reply --dest=org.gnome.Shell /org/gnome/Shell org.gnome.Shell.Eval string:'global.reexec_self()'
