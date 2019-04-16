#!/bin/sh
# 2019 - Zylla - adde88@gmail.com - https://www.github.com/adde88

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/sd/lib:/sd/usr/lib
export PATH=$PATH:/sd/usr/bin:/sd/usr/sbin

[[ -f /tmp/SSHWebClient.progress ]] && {
  exit 0
}

touch /tmp/SSHWebClient.progress
mkdir -p /tmp/ShellinaBox
wget https://github.com/adde88/openwrt-useful-tools/tree/master -P /tmp/ShellinaBox
SSHWC=`grep -F "shellinabox_" /tmp/ShellinaBox/master | awk {'print $5'} | awk -F'"' {'print $2'} | grep ar71xx`

# Download installation-files to temporary directory, and then update OPKG repositories.
cd /tmp
opkg update
wget "https://github.com/adde88/openwrt-useful-tools/raw/master/"$SSHWC""

if [ "$1" = "install" ]; then
  if [ "$2" = "internal" ]; then
    opkg install "$SSHWC"
  elif [ "$2" = "sd" ]; then
    opkg install "$SSHWC" --dest sd
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

rm -f /tmp/SSHWebClient.progress
rm -rf /tmp/ShellinaBox

exit 0
