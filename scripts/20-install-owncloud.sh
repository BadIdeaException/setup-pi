#!/bin/bash

# Install owncloud as a docker container. Configure it to include the calendar module

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Owncloud version to install
VERSION=9.1.2
# Image name prefix to use - default to hostname
IMAGENAME=$(hostname)/owncloud:$VERSION

# Path to resources folder
RESOURCE_LOCATION=$(dirname "$(readlink -f \"$0\")")/../resources/owncloud

# Get the db root password if not already available
if [ -z $MYSQL_ROOT_PASSWORD ]; then
	echo "Enter the MySQL root password"
	read MYSQL_ROOT_PASSWORD
fi

# Ask for owncloud admin user name and password
echo "Enter the owncloud admin username"
read ADMIN_USER
echo "Enter the owncloud admin password"
read ADMIN_PASSWORD

DATAPATH=/var/owncloud_data
# Create volumes
mkdir --parents /var/vol/owncloud/data
mkdir --parents /var/vol/owncloud/config

# Fix ownership and permissions
chown --recursive www-data:www-data /var/vol/owncloud/data /var/vol/owncloud/config
find /var/vol/owncloud -type d -print0 | xargs -0 chmod 751
find /var/vol/owncloud -type f -print0 | xargs -0 chmod 640
find /var/vol/owncloud/certs -type f -print0 | xargs -0 chmod 644
find /var/vol/owncloud -name ".htaccess" -print0 | xargs -0 chown root:www-data
find /var/vol/owncloud -name ".htaccess" -print0 | xargs -0 chmod 644

# Build the docker image 
docker build --file "$RESOURCE_LOCATION/owncloud-Dockerfile" \
			--tag "$IMAGENAME" \
			--build-arg OCVERSION=$VERSION \
      --build-arg DATAPATH=$DATAPATH \
			"$RESOURCE_LOCATION"

# Run it
docker run --detach \
           --restart=always \
           --network intercontainer \
           --publish 7080:7080 \
           --publish 7443:7443 \
           --volume /var/vol/owncloud/data:$DATAPATH \
           --volume /var/vol/owncloud/config:/var/www/owncloud/config \
           --name owncloud $IMAGENAME

# Set up owncloud
docker cp $RESOURCE_LOCATION/owncloud-config.sh owncloud:/tmp/ && docker exec --user www-data   owncloud /bin/bash -c "DATAPATH=\"$DATAPATH\" /tmp/owncloud-config.sh"

docker exec --interactive --user www-data \
            owncloud \
            /bin/bash <<EOF 
                cd /var/www/owncloud
                php occ  maintenance:install \
                         --database "mysql" \
                         --database-name "owncloud" \
                         --database-user "root" \
                         --database-host "mysql" \
                         --database-pass "$MYSQL_ROOT_PASSWORD" \
                         --admin-user "$ADMIN_USER" \
                         --admin-pass "$ADMIN_PASSWORD" \
                         --data-dir="$DATAPATH"
                php occ maintenance:mode --on
                php occ config:system:set trusted_domains 1 --value 'chrissrv'
                php occ config:system:set trusted_domains 2 --value 'chriscloud.privatedns.org'
                php occ maintenance:mode --off
EOF