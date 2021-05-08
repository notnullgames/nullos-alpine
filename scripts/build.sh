#!/bin/bash

export NAME="nullos"
export WORK_DIR=$(realpath out)
export ROOTFS_DIR="${WORK_DIR}/root"

dir=$(cd "${0%[/\\]*}" > /dev/null && pwd)

"${dir}/../alpibase/scripts/build.sh"

source "${dir}/../alpibase/scripts/qcow_handling.sh"

# mount the qcow image
mount_qimage "${WORK_DIR}/image-${NAME}.qcow2" "${ROOTFS_DIR}"

# do things in a chroot
chroot "${ROOTFS_DIR}" sh

# unmount the image
umount_qimage "${ROOTFS_DIR}"
