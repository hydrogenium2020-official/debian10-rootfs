#!/bin/bash
set -eu

#check if is running with root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Check if a paramter was passwrd and it's local
if [[ $# -gt 0 ]] && [[ $1 == "--local" ]]; then
    proot -0 -w / \
    -r /tmp/debootstrap \
    -b $(pwd)/../system-profile:/system-profile \
    -b /dev \
    /system-profile/install.sh
fi

proot -0 -w / \
    -r /tmp/debootstrap \
    curl -o /tmp/remote-install.sh -Ls https://raw.githubusercontent.com/KindOS-workspace/system-profile/master/remote-install.sh 

proot -0 -w / \
    -r /tmp/debootstrap \
    -b /dev \
    bash /tmp/remote-install.sh