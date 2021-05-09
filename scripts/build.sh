#!/bin/bash

export NAME="nullos"
export WORK_DIR=$(realpath out)
export ROOTFS_DIR="${WORK_DIR}/root"

dir=$(cd "${0%[/\\]*}" > /dev/null && pwd)

"${dir}/../alpibase/scripts/build.sh"

source "${dir}/../alpibase/scripts/qcow_handling.sh"

# mount the qcow image
mount_qimage "${WORK_DIR}/image-${NAME}.qcow2" "${ROOTFS_DIR}"

# this shouldn't be needed on recent alpine, but here's how to get proprietary firmware
# git clone --depth 1 https://github.com/RPi-Distro/firmware-nonfree.git "${WORK_DIR}/firmware-nonfree"
# mkdir -p "${ROOTFS_DIR}/firmware/brcm"
# cp "${WORK_DIR}/firmware-nonfree/brcm/*" "${ROOTFS_DIR}/firmware/brcm"

# basic net
cat << INTERFACES > "${ROOTFS_DIR}/etc/network/interfaces"
auto lo
iface lo inet loopback

# this allows AP mode, so you can connect and configure
auto wlan0
iface wlan0 inet static
  address 10.0.0.1
  netmask 255.255.255.0

INTERFACES

# setup initial "AP mode" so you can ssh in and configure
cat << CHROOT | chroot "${ROOTFS_DIR}" sh
apk add dropbear wireless-tools wpa_supplicant hostapd dnsmasq

rc-update add dropbear boot
rc-update add dnsmasq boot
rc-update add hostapd boot
CHROOT

cat << HOSTAPD > "${ROOTFS_DIR}/etc/hostapd/hostapd.conf"
interface=wlan0
driver=nl80211
ssid=NULLBOX
hw_mode=g
channel=1
macaddr_acl=0
auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_passphrase=pakemon
rsn_pairwise=CCMP
wpa_pairwise=CCMP
HOSTAPD

cat << DNSMASQ > "${ROOTFS_DIR}/etc/dnsmasq.conf"
interface=wlan0
dhcp-range=10.0.0.2,10.0.0.5,255.255.255.0,12h
DNSMASQ

# friendly welcome script
echo "" > "${ROOTFS_DIR}/etc/motd"
cp "${dir}/radical_edward.ans" "${ROOTFS_DIR}/etc/radical_edward.ans"
cat << HELLO > "${ROOTFS_DIR}/etc/profile.d/hello.sh"
#!/bin/sh
clear
echo "Howdy Hacker!"
cat /etc/radical_edward.ans
HELLO
chmod 755 "${ROOTFS_DIR}/etc/profile.d/hello.sh"

cat << ISSUE > "${ROOTFS_DIR}/etc/issue"

                  888 888                   
                  888 888                   
                  888 888                   
88888b.  888  888 888 888  .d88b.  .d8888b  
888 "88b 888  888 888 888 d88""88b 88K      
888  888 888  888 888 888 888  888 "Y8888b. 
888  888 Y88b 888 888 888 Y88..88P      X88 
888  888  "Y88888 888 888  "Y88P"   88888P' 
\s \r \v (\m)

ISSUE

# unmount the image
umount_qimage "${ROOTFS_DIR}"