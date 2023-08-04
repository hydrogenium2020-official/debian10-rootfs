#!/bin/sh
rm -f /tmp/debian_12_slim.tar.gz
mkdir -p artifacts
docker pull debian:12-slim
docker save -o artifacts/debian_12_slim.tar debian:12-slim
gzip -9 artifacts/debian_12_slim.tar
du -sh artifacts/debian_12_slim.tar.gz

