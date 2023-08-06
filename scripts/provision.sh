#!/bin/sh
set -eu

apt update && apt -y install curl

cd "$(dirname "$0")" 

# Crete a random temporary directory
TMP_DIR=$(mktemp -d)

LATEST_URL="https://github.com/KindOS-workspace/system-profile/releases/latest/download/debian12_requirements.txt"
curl -sL $LATEST_URL -o $TMP_DIR/requirements.txt

REQUIRE_PACKAGES=$(grep -vE '^\s*#' $TMP_DIR/requirements.txt)

apt-get update
apt-get install -y $REQUIRE_PACKAGES


apt-get clean
rm -rf /var/lib/apt/lists/*