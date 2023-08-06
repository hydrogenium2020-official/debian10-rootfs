#!/bin/bash
set -eu

source config/base.sh

# Get the json from the last docker build

# create a random tmp directory
TMP_DIR=$(mktemp -d)

last_artifacts=$(curl --silent "https://api.github.com/repos/KindOS-workspace/system-base-debian/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/')
last_json=$(echo $last_artifacts | grep -Po "\S+.json")
curl -sL $last_json -o $TMP_DIR/last.json

last_id=$(cat $TMP_DIR/last.json | jq -r '.[0].Id')

docker pull $BASE_IMAGE
docker inspect $BASE_IMAGE > $TMP_DIR/current.json
new_id=$(cat $TMP_DIR/current.json | jq -r '.[0].Id')

if ! echo "$last_id" | grep -q "^sha256:"; then
  last_id="sha256:$last_id"
fi
if ! echo "$new_id" | grep -q "^sha256:"; then
  new_id="sha256:$new_id"
fi

last_id="blablabh"
[[ "$last_id" == "$new_id" ]] && echo "SKIP rebuild because image did not change" && exit 0

echo "A rebuild is needed because there is an image update"
exit 0
