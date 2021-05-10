# nullos

The minimal & fast-booting Alpine-based OS used on nullbox.

![screenshot](screenshot.png)

## installation

```
pip3 install pyyaml requests
```

## usage

Run `./nullos` to build out/nullos.tar.gz.


## installation

Format a microSD to fat32 (should be able to do this on any OS) and make the partition bootable. Next, extract nullos.tar.gz he root of the disk.

### getting started

Once you get booted, there are manual steps you need ot complete, to have a working device.

- Boot with screen & keyboard (or use ssh local overlay method, below)
- login with `root`
- run `setup-alpine`, it will ask you questions, and set things up.

### firmware

We included [brcm firmware](http://static.sevangelatos.com/raspberry_pi_firmware.tar.bz2) in overlays/firmware-nonfree, just to get pi wifi working, but you might need other [non-free firmware](https://github.com/wkennington/linux-firmware), which you can just put in there.


### overlays

The config/install of mopst things is done with alpine overlays, which are just tarballs named with `apkovl.tar.gz`.

All the folders in overlays will be turned into these kind of files, and there is a special one [overlays/local](overlays/local) which is just for your local config (and should not be checked into git.)

A useful example is headless ssh mode, so you can configure the device:

- downlaod [this folder](https://github.com/mesca/alpine_headless/tree/master/ovl) and rename ovl to overlays/local
- edit overlay/local/etc/wpa_supplicant/wpa_supplicant.conf to have your wifi creds
- run `./nullos`
- format your SD card (single FAT32 partition)
- extract out/nullos.tar.gz to your SD
- boot it on pi, and login to your device over ssh
- do setup things, as above
- TODO: `lbu` commands to finalize/commit
