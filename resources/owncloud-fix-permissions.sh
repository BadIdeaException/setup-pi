#!/bin/bash
#
# As per https://doc.owncloud.org/server/9.0/admin_manual/installation/installation_wizard.html#strong-perms-label
OCPATH=${OCPATH:-'/var/www/owncloud'}
HTUSER=${HTUSER:-'www-data'}
HTGROUP=${HTUSER:-'www-data'}
ROOTUSER='root'


find ${OCPATH}/ -type f -print0 | xargs -0 chmod 0640
find ${OCPATH}/ -type d -print0 | xargs -0 chmod 0750

chown -R ${ROOTUSER}:${HTGROUP} ${OCPATH}/
chown -R ${HTUSER}:${HTGROUP} ${OCPATH}/apps/
chown -R ${HTUSER}:${HTGROUP} ${OCPATH}/config/
chown -R ${HTUSER}:${HTGROUP} ${DATAPATH}/
chown -R ${HTUSER}:${HTGROUP} ${OCPATH}/themes/

chown ${ROOTUSER}:${HTGROUP} ${OCPATH}/.htaccess || true # Prevent non-zero exit code if no .htaccess file present
chown ${ROOTUSER}:${HTGROUP} ${DATAPATH}/.htaccess || true # Prevent non-zero exit code if no .htaccess file present

chmod 0644 ${OCPATH}/.htaccess || true # Prevent non-zero exit code if no .htaccess file present
chmod 0644 ${DATAPATH}/.htaccess || true # Prevent non-zero exit code if no .htaccess file present
