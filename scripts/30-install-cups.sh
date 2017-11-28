#!/bin/bash

# Install cups as a docker container

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Path to resources folder
SCRIPT=$(readlink -f "$0")
RESOURCE_LOCATION=$(dirname "$SCRIPT")/../resources/cups
IMAGENAME=chrissrv/cups:1.0

mkdir --parents /var/vol/cups

# Build the docker image
docker build \
         --file "$RESOURCE_LOCATION/cups-Dockerfile" \
         --tag "$IMAGENAME" \
         "$RESOURCE_LOCATION"

docker run --detach \
         --restart=always \
         --network intercontainer \      
         --publish 631:631 \ 
         --volume /var/vol/cups/:/etc/cups \
         --name cups \
         $IMAGENAME

# Install script to handle ephemeral device addition and removal in containers
cp $RESOURCE_LOCATION/container-manage-devices /usr/local/bin

# Install udev rule
cp $RESOURCE_LOCATION/50-docker-cups.rules /etc/udev/rules.d/
udevadm control --reload