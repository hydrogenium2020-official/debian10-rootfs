#!/bin/sh
set -eu

BASE_IMAGE=debian:12-slim

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

rm -f /tmp/debian_12_slim.tar.gz
mkdir -p artifacts
docker rm devex 2>/dev/null|| true

docker run \
    -v ${SCRIPT_DIR}:/build \
    --name devex \
    $BASE_IMAGE

docker export -o artifacts/debian_12_slim.tar devex
rm -f  artifacts/debian_12_slim.tar.gz
gzip -9 artifacts/debian_12_slim.tar
du -sh artifacts/debian_12_slim.tar.gz

