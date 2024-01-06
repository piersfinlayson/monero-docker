#!/bin/bash

set -e

VER=$1
CONT_VER=$2

if [ -z $1 ]; then
  echo "No Monero version supplied (e.g. 0.18)"
  exit 1
fi
if [ -z $2 ]; then
  echo "No container version supplied (e.g. 0.18.01)"
  exit 1
fi

IMAGE_BASE="registry:80/monero"
IMAGE_NAME=$IMAGE_BASE:$CONT_VER

echo "Building container image $IMAGE_NAME ..."

# Note PARALLEL_MAKE=2 for a Raspberry Pi 5 with 4GB RAM and 2GB swap.  More threads will cause the build to fail as the OOM killer will kill the build.
docker build . -t $IMAGE_NAME --build-arg MONERO_VER=$VER --build-arg PARALLEL_MAKE=2

echo "Pushing container image $IMAGE_NAME ..."
docker push $IMAGE_NAME

