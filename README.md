# nullos

The minimal & fast-booting OS used on nullbox.

![screenshot](screenshot.png)

## installation

```
pip3 install pyyaml requests
```

## usage

Run `./nullos` to build out/nullos.tar.gz.

## installation

Format a microSD to fat32 (should be able to do this on any OS) then extract nullos.tar.gz he root of the disk.


### overlays

The config/install of mopst things is done with alpine overlays, which are just tarballs named with `apkovl.tar.gz`.

All the folders in overlays will be turned into these kind of files, and there is a special one [overlays/local](overlays/local) which is just for your local config (and should not be checked into git.)

A useful example is headless ssh mode, so you can configure the device:

- downlaod [this folder](https://github.com/mesca/alpine_headless/tree/master/ovl) and rename ovl to overlays/local
- edit overlay/local/etc/wpa_supplicant/wpa_supplicant.conf to have your wifi creds
- run `./nullos`
- for your SD card (single FAT32 partition)
- extract out/nullos.tar.gz to your SD
- boot it on pi, and login to your device over ssh
- run `setup-alpine` to do basic config