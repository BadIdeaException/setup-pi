#!/bin/bash

# Install MySQL as a docker container

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Path to resources folder
SCRIPT=$(readlink -f "$0")
RESOURCE_LOCATION=$(dirname "$SCRIPT")/../resources/mysql

if [ ! $MYSQL_ROOT_PASSWORD ]; then
   echo "A MySQL root password has not been set. Please enter one now and make sure you remember it:"
   read MYSQL_ROOT_PASSWORD
   # Persist this variable
   echo "MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD" >> /etc/environment
fi

mkdir --parents /var/vol/mysql/dumps

docker pull hypriot/rpi-mysql
docker run --detach \
		   --restart=always \
		   --network intercontainer \
		   --env MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
		   --volume /var/vol/mysql/dumps:/backups \
		   --name mysql hypriot/rpi-mysql

cp $RESOURCE_LOCATION/mysql-dump.sh /etc/cron.daily