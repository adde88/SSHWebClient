#!/bin/bash
#
# Installation script for SSHWebClient, for the Pineapple NANO and TETRA.
# Written by: Andreas Nilsen - adde88@gmail.com - https://www.github.com/adde88
#
# Starting SSHWebClient Install.
#
# Variables and colors.
RED='\033[0;31m'
NC='\033[0m'
SSHWC="https://github.com/adde88/SSHWebClient/raw/master/shellinabox_2.10-1_ar71xx.ipk"
MODULE="https://github.com/adde88/SSHWebClient"
#
echo -e "${RED}Installing: ${NC}SSHWebClient."
# Download installation-files to temporary directory. Then update OPKG repositories, and install dependencies.
cd /tmp
opkg update
wget "$SSHWC"
#
# Creating sym-link between python-directories located on the sd-card and internally.
# The main-directory will be located on the sd-card (/sd)
# This will only happen on the Pineapple NANO.
if [ -e /sd ]; then
	opkg --dest sd install git git-http "$sshwc"
	cd /sd/modules
	git clone "$MODULE"
	ln -s /sd/modules/SSHWebClient /pineapple/modules/SSHWebClient
else
	# Tetra installation / general install.
	opkg install git git-http "$sshwc"
	cd /pineapple/modules
	git clone "$MODULE"
fi
# Cleanup
cd /tmp
rm /tmp/shellinabox*
echo -e "${RED}SSHWebClient Installation completed!"
exit 0
