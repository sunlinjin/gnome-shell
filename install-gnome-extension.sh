#!/usr/bin/env bash

#
# https://jasonmun.blogspot.my
# https://github.com/yomun
# 
# Copyright (C) 2017 Jason Mun
# 

OS_RELEASE=`cat /etc/os-release`

if [ `echo ${OS_RELEASE} | grep -c "ubuntu"` -gt 0 ] || [ `echo ${OS_RELEASE} | grep -c "linuxmint"` -gt 0 ] || [ `echo ${OS_RELEASE} | grep -c "debian"` -gt 0 ] || [ `echo ${OS_RELEASE} | grep -c "zorin"` -gt 0 ]
then
	sudo apt install gir1.2-gtop-2.0 gir1.2-networkmanager-1.0 -y
	sudo apt install openvpn network-manager-openvpn network-manager-openvpn-gnome curl -y

	sudo apt install gnome-shell-extension-caffeine -y
	sudo apt install gnome-shell-extension-top-icons-plus -y
	sudo apt install gnome-shell-extension-weather -y
fi

# -------------------------------------------------
# https://extensions.gnome.org/
# -------------------------------------------------
# Appfolders Management extension (1217)
# Auto-OVPN (1270)
# Caffeine (517)
# Clipboard Indicator (779)
# Dash to panel (1160)
# Datetime format (1173)
# Icon Hider (351)
# NetSpeed (104)
# OpenWeather (750)
# Place Status Indicator (8)
# Random Wallpaper (1040)
# Recent(Item)s (977)
# Remove Dropbox Arrows (800)
# Simple net speed (1085)
# Sound settings (1271)
# System-monitor (120)
# TopIcons Plus (1031)
# User themes (19)
# Window List (602)
# -------------------------------------------------
array=("1270" "779" "1160" "1173" "8" "1040" "1085" "1271" "120" "19")

GID=""

VERSION=`gnome-shell --version | sed 's/GNOME Shell //g'`
VER=`echo ${VERSION:0:4}`
echo ${VER}

LOCAL_PATH="${HOME}/.local/share/gnome-shell/extensions"

function getDownUrl()
{
	local URL=`curl "https://extensions.gnome.org/extension-info/?pk=${GID}&shell_version=${VER}" | sed 's/^.*download_url": "//g' | sed 's/", "pk".*//g'`
	local FULL_URL="https://extensions.gnome.org${URL}"
	local FOLDER_NAME=`echo ${URL} | sed 's/\/download-extension\///g' | sed 's/.shell-extension.zip.*//g'`
	
	echo [${ix}]${FULL_URL}
	echo [${ix}]${FOLDER_NAME}
	
	if [ -d "${LOCAL_PATH}/${FOLDER_NAME}" ]
	then
		echo "${FOLDER_NAME} installed already.."
	else
		wget -O /tmp/extension.zip "${FULL_URL}"
		mkdir -p "${LOCAL_PATH}/${FOLDER_NAME}"
		unzip /tmp/extension.zip -d "${LOCAL_PATH}/${FOLDER_NAME}"
	fi
}

for ix in ${!array[*]} 
do
	GID="${array[$ix]}"
	getDownUrl
done

# for ix in ${!array[*]} 
# do
	# enable extension
	# gnome-shell-extension-tool -e ${array[$ix]}
# done

# restart gnome-shell
dbus-send --type=method_call --print-reply --dest=org.gnome.Shell /org/gnome/Shell org.gnome.Shell.Eval string:'global.reexec_self()'
