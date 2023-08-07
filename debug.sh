#/bin/bash
sudo proot -0 -w / \
    -r /tmp/debootstrap \
    -b $(pwd)/../system-profile:/etc/system-profile \
    -b /dev \
    bash
