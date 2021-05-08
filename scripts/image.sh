#!/bin/bash

export NAME="nullos"
export WORK_DIR=$(realpath out)

dir=$(cd "${0%[/\\]*}" > /dev/null && pwd)
source "${dir}/../alpibase/scripts/qcow_handling.sh"

# generate an SD image for pi
make_bootable_image "${WORK_DIR}/image-${NAME}.qcow2" "${WORK_DIR}/image-${NAME}.img"

