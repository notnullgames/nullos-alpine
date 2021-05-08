#!/bin/bash

export NAME="nullos"
export WORK_DIR=$(realpath out)
export ROOTFS_DIR="${WORK_DIR}/root"

dir=$(cd "${0%[/\\]*}" > /dev/null && pwd)

"${dir}/../alpibase/scripts/build.sh"

source "${dir}/../alpibase/scripts/qcow_handling.sh"

# mount the qcow image
mount_qimage "${WORK_DIR}/image-${NAME}.qcow2" "${ROOTFS_DIR}"

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

# basic net
cat << INTERFACES > "${ROOTFS_DIR}/etc/network/interfaces"
auto lo
iface lo inet loopback

auto wlan0
iface wlan0 inet static
  address 10.0.0.1
  netmask 255.255.255.0
INTERFACES

cat << CHROOT | chroot "${ROOTFS_DIR}" sh
apk add dropbear wireless-tools wpa_supplicant hostapd dnsmasq

rc-update add dropbear boot
rc-update add dnsmasq boot
rc-update add hostapd boot

CHROOT

# unmount the image
umount_qimage "${ROOTFS_DIR}"