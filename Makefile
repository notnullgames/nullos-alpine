.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

qcow: out/image-nullos.qcow2      ## Generate a qcow2 image (for qemu) in out/
image: out/image-nullos.img       ## Generate complete SD disk image in out/

emulate: out/image-nullos.qcow2   ## Run the OS in an emulator
	qemu-system-arm \
		-M versatilepb \
		-cpu arm1176 \
		-m 256 \
		-hda ./out/image-nullos.qcow2 \
		-net user,hostfwd=tcp::5022-:22 \
		-dtb qemu-rpi-kernel/versatile-pb-buster.dtb \
		-kernel qemu-rpi-kernel/kernel-qemu-4.19.50-buster \
		-append 'root=/dev/sda2 panic=1' \
		-no-reboot

.PHONY: clean
clean:                            ## Clean all built files
	sudo rm -rf out

out/image-nullos.qcow2:
	sudo ./scripts/build.sh
	sudo chown -R $(whoami) out

out/image-nullos.img: out/image-nullos.qcow2
	./scripts/image.sh
