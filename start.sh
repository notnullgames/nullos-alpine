#!/sbin/openrc-run

# this is run in default runlevel, to finish startup.
# It allows you to override how it boots

SD="/media/mmcblk0p1"

# setup wifi if there is a wpa_supplicant.conf on SD
setup_wifi() {
  if [ -f  "${SD}/wpa_supplicant.conf" ];then
    apk add wireless-tools wpa_supplicant
    mkdir -p /etc/wpa_supplicant/
    cp "${SD}/wpa_supplicant.conf" /etc/wpa_supplicant/wpa_supplicant.conf
    rc-service wpa_supplicant start
    if [ ! -f  "/etc/network/interfaces" ];then
      cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto wlan0
iface wlan0 inet dhcp
  hostname nullbox
EOF
    fi
    rc-service networking start
  fi
}

setup_ssh() {
  mkdir -p /etc/ssh/
  # copy ssh config, if it's on SD, so you can override settings
  if [ -f  "${SD}/sshd_config" ];then
    cp "${SD}/sshd_config" /etc/ssh/
  fi
  # if you didn't setup anything for ssh, allow root login with no password 
  if [ ! -f "/etc/ssh/sshd_config" ];then
    echo "PermitRootLogin without-password" > /etc/ssh/sshd_config
  fi
  # start ssh if there is a ssh file on SD, like how raspbian does
  if [ -f  "${SD}/ssh" ];then
    apk add openssh
    rc-service sshd start
  fi
}

start() {
  ebegin "Running start.sh on SD"
  setup_wifi
  setup_ssh
  eend $rc
}



