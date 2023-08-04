#!/bin/sh
set -eu

BASE_IMAGE=debian:12-slim

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

rm -f /tmp/debian_12_slim.tar.gz
mkdir -p artifacts
docker rm devex 2>/dev/null|| true

echo "Starting docker container to build rootfs"
docker run \
    -v ${SCRIPT_DIR}:/build \
    --name devex \
    $BASE_IMAGE
echo "Exporting the tar file"
docker export -o artifacts/debian_12_slim.tar devex

rm -rf /tmp/rootfs && mkdir -p /tmp/rootfs
tar -C /tmp/rootfs -xf artifacts/debian_12_slim.tar

echo "Adding the DevEx User"
proot -b $(pwd) -r /tmp/rootfs useradd -m  devex
cp -v etc/* /tmp/rootfs/etc

echo "Rebuilding the tar file"
rm -f  artifacts/debian_12_slim.tar.gz
tar -C /tmp/rootfs -czvf artifacts/debian_12_slim.tar.gz .
du -sh artifacts/*
md5sum artifacts/*

