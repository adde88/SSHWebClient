#!/bin/bash
#
# Installation script for SSHWebClient, for the Pineapple NANO and TETRA (OpenWRT)
# Written by: Andreas Nilsen - adde88@gmail.com - https://www.github.com/adde88
# 16 April 2019
# Starting SSHWebClient Install.
#
mkdir -p /tmp/ShellinaBox
wget https://github.com/adde88/openwrt-useful-tools/tree/master -P /tmp/ShellinaBox
SSHWC=`grep -F "shellinabox_" /tmp/ShellinaBox/master | awk {'print $5'} | awk -F'"' {'print $2'} | grep ar71xx`
MODULE="git://github.com/adde88/SSHWebClient"
#
echo -e "Installing: SSHWebClient"
# Download installation-files to temporary directory. Then update OPKG repositories, and install dependencies.
cd /tmp
opkg update
wget "https://github.com/adde88/openwrt-useful-tools/raw/master/"$SSHWC""
#
# SD Card check
if [ -e /sd ]; then
	# Nano install / SD card install
	opkg --dest sd install git git-http "$SSHWC"
	# Module installation
	mkdir -p /sd/modules
	cd /sd/modules
	git clone "$MODULE"
	ln -s /sd/modules/SSHWebClient /pineapple/modules/SSHWebClient
else
	# Tetra installation / general install.
	opkg install git git-http "$SSHWC"
	# Module installation
	cd /pineapple/modules
	git clone "$MODULE"
fi
#
# UCI related stuff
touch /etc/config/sshwebclient
echo "config sshwebclient 'module'" > /etc/config/sshwebclient
echo "config sshwebclient 'settings'" >> /etc/config/sshwebclient
uci set sshwebclient.module.installed=1
uci commit sshwebclient.module.installed
#
# Cleanup time!
rm -rf /tmp/ShellinaBox

echo -e "SSHWebClient Installation completed!"

exit 0
