#!/bin/sh
set -eu

cd "$(dirname "$0")" 

REQUIRE_PACKAGES=$(grep -vE '^\s*#' requirements.txt)

apt-get update
apt-get install -y --no-install-recommends $REQUIRE_PACKAGES


apt-get clean
rm -rf /var/lib/apt/lists/*