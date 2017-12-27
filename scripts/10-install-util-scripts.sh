#!/bin/bash
#
# Install helper scripts

SCRIPT=$(readlink -f "$0")
RESOURCE_LOCATION=$(dirname "$SCRIPT")/../resources
DEST=/usr/share/chrissrv

mkdir -p /usr/share/chrissrv
cp $RESOURCE_LOCATION/util/* $DEST

ln -s $DEST/chrissrv /usr/bin/chrissrv