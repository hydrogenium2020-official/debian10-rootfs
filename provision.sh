#!/bin/sh
apt-get update
apt-get install -y wget curl

apt-get clean
rm -rf /var/lib/apt/lists/*