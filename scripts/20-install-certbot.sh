#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Path to resources folder
SCRIPT=$(readlink -f "$0")
RESOURCE_LOCATION=$(dirname "$SCRIPT")/../resources/certbot

# Image name prefix to use - default to hostname
VERSION=1.0
IMAGENAME=$(hostname)/certbot:$VERSION

# Build the docker image
docker build --file "$RESOURCE_LOCATION/certbot-Dockerfile" \
			--tag "$IMAGENAME" \
			"$RESOURCE_LOCATION"

# Run it
docker run --detach \
           --restart=always \
           --network intercontainer \
           --publish 6080:80 \
           --name certbot $IMAGENAME
