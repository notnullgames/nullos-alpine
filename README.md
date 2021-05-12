# nullos

The minimal & fast-booting Alpine-based OS used on nullbox.

![screenshot](screenshot.png)

## installation

```
pip3 install pyyaml requests
```

## usage

Run `./nullos` to cretae an SD card or just the directory-structure. It has soem extra options, use `--help` but with no pramaters it will as a couple questions.

### getting started

Once you get booted, there are manual steps you need ot complete, to have a working device.

- Boot with screen & keyboard (or use ssh local overlay method, below)
- login with `root`
- run `setup-alpine`, it will ask you questions, and set things up.


### overlays

The config/install of most things is done with an alpine overlay, which are just tarballs named with `apkovl.tar.gz`.

All the folders in overlays will be turned into this kind of file, and there is a special one [overlays/local](overlays/local) which is just for your local config (and should not be checked into git.)

A useful example is headless ssh mode, so you can configure the device:

- download [this folder](https://github.com/mesca/alpine_headless/tree/master/ovl) and rename ovl to overlays/local
- edit overlay/local/etc/wpa_supplicant/wpa_supplicant.conf to have your wifi creds
- run `./nullos`
- format your SD card (single FAT32 partition)
- extract out/nullos.tar.gz to your SD
- boot it on pi, and login to your device over ssh
- do setup things, as above
- TODO: `lbu` commands to finalize/commit
