#!/bin/bash

OLD_VERSION=$1
NEW_VERSION=$2
WALLET_ADDR=$3

usage () {
  echo "Usage: run.sh <old_container_version> <new_container_version> <wallet_address>"
}
check_arg () {
  if [ -z $ARG ]; then
    usage
    exit 1
  fi
}

set -e 

ARG=$OLD_VERSION
check_arg
ARG=$NEW_VERSION
check_arg
ARG=$WALLET_ADDR
check_arg

STOP_TIMEOUT=300 # Allows monero to shutdown gracefully, to avoid corrupting DB
IMAGE_BASE="registry:80/monero"
CONT_NAME_BASE=monero
DATA_DIR_HOST=/usb/monero
DATA_DIR_CONT=/monero
HOST_PORT_RPC=18081
CONT_PORT_RPC=18081
HOST_PORT_P2P=18080
CONT_PORT_P2P=18080

OLD_CONT=$CONT_NAME_BASE-$OLD_VERSION
NEW_CONT=$CONT_NAME_BASE-$NEW_VERSION
NEW_IMAGE=$IMAGE_BASE:$NEW_VERSION

echo "Pulling new image ..."
docker pull $NEW_IMAGE
echo ""

set +e 

echo "Stopping old container ..."
docker stop -t $STOP_TIMEOUT $OLD_CONT
echo ""

echo "Removing old container ..."
docker rm -f  $OLD_CONT
echo ""

set -e

echo "Starting new container ..."
docker run --restart always \
           --name $NEW_CONT \
           -v $DATA_DIR_HOST:$DATA_DIR_CONT \
           -p $HOST_PORT_RPC:$CONT_PORT_RPC \
           -p $HOST_PORT_P2P:$CONT_PORT_P2P \
           -d \
           -e WALLET_ADDR=$WALLET_ADDR \
           $NEW_IMAGE
echo ""

echo "Tailing logs - Ctrl-C to exit ..."
docker logs -f $NEW_CONT
