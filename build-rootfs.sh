#!/bin/bash
set -eu

source config/base.sh

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

rm -f /tmp/debian_12_slim.tar.gz
mkdir -p artifacts
docker rm kindos 2>/dev/null|| true

echo "Starting docker container to build rootfs"

docker pull $BASE_IMAGE
docker inspect $BASE_IMAGE > artifacts/debian_12_slim.json

docker run \
    -v ${SCRIPT_DIR}:/build \
    --name kindos \
    -v $(pwd):/build \
    $BASE_IMAGE \
    /build/scripts/provision.sh

echo "Exporting the tar file"
docker export -o artifacts/debian_12_slim.tar kindos

rm -f  artifacts/debian_12_slim.tar.gz
gzip -9 -n -v -S .gz artifacts/debian_12_slim.tar

sha256sum artifacts/debian_12_slim.tar.gz > artifacts/debian_12_slim.tar.gz.sha256
tar tvf artifacts/debian_12_slim.tar.gz >  artifacts/filelist.txt

du -sh artifacts/*

