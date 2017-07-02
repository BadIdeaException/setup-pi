#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Path to resources folder
SCRIPT=$(readlink -f "$0")
RESOURCE_LOCATION=$(dirname "$SCRIPT")/../resources/gateway

# Image name prefix to use - default to hostname
VERSION=1.0
IMAGENAME=$(hostname)/gateway:$VERSION

# Build the docker image
docker build --file "$RESOURCE_LOCATION/gateway-Dockerfile" \
			--tag "$IMAGENAME" \
			"$RESOURCE_LOCATION"

# Run it
docker run --detach \
           --restart=always \
           --network intercontainer \
           --publish 80:80 \
           --publish 443:443 \
           --name gateway $IMAGENAME
