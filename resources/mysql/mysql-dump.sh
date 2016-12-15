#!/bin/bash

DATABASES=("owncloud")

for db in $DATABASES; do
	docker exec mysql /bin/sh -c "mysqldump --user=\"root\" --password=\"$MYSQL_ROOT_PASSWORD\" $db > $db_$(date +\"%Y%m%d\").dump"
done