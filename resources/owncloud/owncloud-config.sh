#!/bin/bash
cd /var/www/owncloud

php occ  maintenance:install \
		--database "mysql" \
		--database-name "owncloud" \
		--database-user "root" \
		--database-host "mysql" \
		--database-pass "abc" \
		--admin-user "o" \
		--admin-pass "o" \
		--data-dir="/var/owncloud_data"

php occ maintenance:mode --on 
php occ config:system:set trusted_domains 1 --value 'chrissrv'
php occ config:system:set trusted_domains 2 --value 'chriscloud.privatedns.org'
php occ maintenance:mode --off