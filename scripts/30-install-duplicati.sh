#!/bin/bash
#
# Install duplicati as a docker container

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Path to resources folder
SCRIPT=$(readlink -f "$0")
RESOURCE_LOCATION=$(dirname "$SCRIPT")/../resources/duplicati

mkdir --parents /var/vol/duplicati/config

docker pull lsioarmhf/duplicati:latest

# Need to run with PUID=0 to make the added capability work
docker run \
	--detach \
	--restart=always \
	--volume /var/vol:/source \
	--volume /var/vol/duplicati/:/config \
	--env PUID=0 \
	--add-cap=DAC_READ_SEARCH \
	--publish 8200:8200
	--name duplicati
	lsioarmhf/duplicati

echo "Visit this server at port 8200 to configure backups"