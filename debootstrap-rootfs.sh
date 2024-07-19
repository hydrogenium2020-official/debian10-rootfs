#!/bin/bash
set -eu

# Check if is running with root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Debootstrap a new environment
DebootstrapDir=/tmp/debootstrap
mkdir -p $DebootstrapDir

# Check if there is a first argument ands is --force
if [[ $# -gt 0 ]] && [[ $1 == "--force" ]]; then
    echo "Force debootstrap"
    rm -rf $DebootstrapDir
fi

[[ ! -d $DebootstrapDir ]]  && debootstrap --variant=minbase --arch amd64 buster $DebootstrapDir https://archive.debian.org/debian/


proot -0 -w / \
    -r /tmp/debootstrap \
    -b /dev \
    -b scripts:/scripts \
    /scripts/provision.sh

# Remove the apt cache
rm -rf $DebootstrapDir/var/cache/apt/*

tar -C $DebootstrapDir -c . | gzip -9 -n -v -S .gz > artifacts/debian_10_slim.tar.gz

du -sh artifacts/debian_10_slim.tar.gz

