#!/bin/bash
#
# Execute backups for all definitions found at /etc/duplicati.d

CONFPATH=${1:="/etc/duplicati.d"}

echo $CONFPATH
for f in /etc/duplicati.d/*.backup; do
	source $f
	echo "$TARGET $SOURCE --auth-username=$BACKUP_USER --auth-password=$BACKUP_PASSWORD"
done;