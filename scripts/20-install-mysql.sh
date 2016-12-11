#!/bin/bash

# Install MySQL as a docker container

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if [ ! $MYSQL_ROOT_PASSWORD ]; then
   echo "A MySQL root password has not been set. Please enter one now and make sure you remember it:"
   read MYSQL_ROOT_PASSWORD
fi

docker pull hypriot/rpi-mysql

docker run --detach --restart=always --network intercontainer --env MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" --name mysql hypriot/rpi-mysql
