#!/bin/bash
#
# Install duplicati as a docker container

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

docker pull lsioarmhf/duplicati

if [ ! $TARGET_URL ]; then
	echo "Specify the URL to store backups to.\nThis should be in the format \"protocol://username:password@host:port/path\"\nRun this image with the help backup option for more help."
	while [ ! $TARGET_URL ] do
		read "Enter a URL: " TARGET_URL
	done
fi

docker run --detach \
	--rm
	--volume /var/vol/:/source \
	--volume /var/vol/duplicati/config:/config \
	--name duplicati \
	--env TARGET_URL=$TARGET_URL \
	lsioarmhf/duplicati