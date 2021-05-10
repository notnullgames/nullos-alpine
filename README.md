# nullos

The minimal & fast-booting OS used on nullbox.

![screenshot](screenshot.png)

## installation

```
pip3 install pyyaml requests
```

## usage

Run `./nullos --help` to see available sub-commands.


### overlays

The config/install of mopst things is done with alpine overlays, which are just `apkovl.tar.gz` files.

All the folders in overlays will be turned into thse kind of files, and there is a special one [overlays/local](overlays/local) which is just for your local config (and should not be checked into git.)

A useful example is headless ssh mode, so you can configure the device:

- downlaod [this folder](https://github.com/mesca/alpine_headless/tree/master/ovl) and rename ovl to overlays/local
- edit overlay/local/etc/wpa_supplicant/wpa_supplicant.conf to have your wifi creds
- run `sudo ./nullos build`
- burn `out/nullos.img` on an SD card
- boot it on pi, and login to your device over ssh
- run `setup-alpine` to do basic config