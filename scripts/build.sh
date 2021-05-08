#!/bin/bash

export NAME="nullos"
export WORK_DIR=$(realpath out)
export ROOTFS_DIR="${WORK_DIR}/root"

dir=$(cd "${0%[/\\]*}" > /dev/null && pwd)

"${dir}/../alpibase/scripts/build.sh"

source "${dir}/../alpibase/scripts/qcow_handling.sh"

# mount the qcow image
mount_qimage "${ROOTFS_DIR}"

# do things in a chroot
chroot "${ROOTFS_DIR}" sh

# unmount the image
umount_qimage "${ROOTFS_DIR}"

# generate an SD image for pi
make_bootable_image "${WORK_DIR}/${CURRENT_IMAGE}" "${WORK_DIR}/${NAME}.img"

