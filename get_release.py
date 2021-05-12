#!/usr/bin/env python3

# this simply prints the current release URL

from sys import exit

try:
  from yaml import SafeLoader, load as yaml
  import requests
except ImportError:
  exit("Please install dependencies with: pip3 install yaml requests\n")


def get(arch="armhf", flavor="alpine-rpi"):
  r = requests.get(f'https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/{arch}/latest-releases.yaml')
  for release in yaml(r.text, Loader=SafeLoader):
    if release["flavor"] == flavor:
      return f'https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/{release["arch"]}/{release["file"]}'


if __name__ == "__main__":
  print(get())