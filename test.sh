#/bin/bash
proot -0 -w / \
    -r /tmp/debootstrap \
    curl -o /tmp/remote-install.sh -Ls https://raw.githubusercontent.com/KindOS-workspace/system-profile/master/remote-install.sh 

proot -0 -w / \
    -r /tmp/debootstrap \
    -b /dev \
    bash /tmp/remote-install.sh