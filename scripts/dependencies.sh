#!/bin/sh
#2017 - Zylla - adde88@gmail.com - https://www.github.com/adde88

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/sd/lib:/sd/usr/lib
export PATH=$PATH:/sd/usr/bin:/sd/usr/sbin

SIAB="https://github.com/adde88/SSHWebClient/raw/master/shellinabox_2.10-1_ar71xx.ipk"	# Remove this line after shellinabox has been uploaded to hak5 repos.

[[ -f /tmp/SSHWebClient.progress ]] && {
  exit 0
}

touch /tmp/SSHWebClient.progress

wget "$SIAB" -P /tmp/											# Remove this line after shellinabox has been uploaded to hak5 repos.

if [ "$1" = "install" ]; then
  if [ "$2" = "internal" ]; then
    opkg update
  	#opkg install shellinabox									# Use this line after shellinabox has been uploaded to hak5 repos.
	opkg install /tmp/shellinabox_2.10-1_ar71xx.ipk				# Remove this line after shellinabox has been uploaded to hak5 repos.
  elif [ "$2" = "sd" ]; then
    opkg update
  	#opkg install shellinabox --dest sd							# Use this line after shellinabox has been uploaded to hak5 repos.
	opkg install /tmp/shellinabox_2.10-1_ar71xx.ipk --dest sd	# Remove this line after shellinabox has been uploaded to hak5 repos.
  fi

  touch /etc/config/sshwebclient
  echo "config sshwebclient 'module'" > /etc/config/sshwebclient
  echo "config sshwebclient 'settings'" >> /etc/config/sshwebclient

  uci set sshwebclient.module.installed=1
  uci commit sshwebclient.module.installed

elif [ "$1" = "remove" ]; then
	opkg remove shellinabox

	rm -rf /etc/config/sshwebclient
	rm -rf /etc/init.d/shellinabox
fi

rm /tmp/SSHWebClient.progress
