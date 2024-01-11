#!/bin/bash
VER=$1
if [ -z $1 ]; then
  echo "Usage: status.sh <container_version>"
  exit 1
fi
docker exec monero-$VER monerod status
