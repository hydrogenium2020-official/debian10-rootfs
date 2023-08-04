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

rm -f  artifacts/debian_12_slim.tar.gz
gzip -9 -n -v -S .gz artifacts/debian_12_slim.tar
du -sh artifacts/*

