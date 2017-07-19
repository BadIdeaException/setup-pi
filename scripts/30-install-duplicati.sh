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

docker build --file "$RESOURCE_LOCATION/duplicati-Dockerfile" \
			--tag "chrissrv/duplicati:1.0" \
			"$RESOURCE_LOCATION"


# Read target url if not already set on the system. Keep reading until not empty.
if [ ! $DUPLICATI_TARGET_URL ]; then
	echo -e "Specify the URL to store backups to. \n This should be in the format \"protocol://username:password@host:port/path\"\nRun this image with the help backup option for more help." # -e: Enable \n for newline
	while [ ! $DUPLICATI_TARGET_URL ]; do
		read -p "Enter a URL: " DUPLICATI_TARGET_URL # -p: Specify prompt
	done
   # Persist this variable
	echo "DUPLICATI_TARGET_URL=$DUPLICATI_TARGET_URL" >> /etc/environment
fi

docker run \
	--rm \
	--volume /var/vol/:/source \
	--volume /var/vol/duplicati/config:/config \
	--name duplicati \
	--env TARGET_URL=$DUPLICATI_TARGET_URL \
	--env PASSPHRASE="" \
	chrissrv/duplicati:1.0