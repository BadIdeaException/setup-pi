#!/bin/bash
#
# Install tvheadend as a docker container

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

docker pull lsioarmhf/tvheadend

mkdir --parents /var/vol/tvheadend/config
mkdir --parents /var/vol/tvheadend/recordings

# Because of a docker issue with multicast, need to use net=host here
# Also, to enable use of the dvb usb stick, run with group id owning the adapter's subdevices
docker run \
	--detach \
	--volume=/var/vol/tvheadend/config:/config \
	--volume=/var/vol/tvheadend/recordings:/recordings \
	--net=host \
	--device=/dev/dvb \
	--env PUID=$(stat -c %u /dev/dvb/adapter0/frontend0) \
	--name=tvheadend \
	lsioarmhf/tvheadend

echo "The TVHeadend container was just started. If this was the first start ever, it will take a long time for it to be available (> 15min)"