#!/bin/bash

# Setup script for chrissrv:

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Run updates
apt-get -y update && apt-get -y upgrade

# Set up user "chris" as a replacement for "pi"
./scripts/00-setup-users.sh chris

# Install docker
./scripts/10-install-docker.sh

# Create a network for inter-container communication
docker network create intercontainer

# Install an apache server to act as a gateway
./scripts/20-install-gateway.sh

# Install certbot to enable Let's Encrypt certificates
./scripts/20-install-certbot.sh

# Install mysql
./scripts/20-install-mysql.sh

# Install owncloud
./scripts/20-install-owncloud.sh
