#!/bin/bash
#
# As per https://doc.owncloud.org/server/9.0/admin_manual/installation/installation_wizard.html#strong-perms-label
OCPATH=${OCPATH:-'/var/www/owncloud'}
HTUSER=${HTUSER:-'www-data'}
HTGROUP=${HTUSER:-'www-data'}
ROOTUSER='root'


find ${OCPATH}/ -type f -print0 | xargs -0 chmod 0640
find ${OCPATH}/ -type d -print0 | xargs -0 chmod 0750

echo "Changing owner of ${OCPATH}/ to ${ROOTUSER}:${HTGROUP}"
chown -R ${ROOTUSER}:${HTGROUP} ${OCPATH}/
echo "Changing owner of ${OCPATH}/apps/ to ${HTUSER}:${HTGROUP}"
chown -R ${HTUSER}:${HTGROUP} ${OCPATH}/apps/
echo "Changing owner of ${OCPATH}/config/ to ${HTUSER}:${HTGROUP}"
chown -R ${HTUSER}:${HTGROUP} ${OCPATH}/config/
echo "Changing owner of ${DATAPATH}/ to ${HTUSER}:${HTGROUP}"
chown -R ${HTUSER}:${HTGROUP} ${DATAPATH}/
echo "Changing owner of ${OCPATH}/themes/ to ${HTUSER}:${HTGROUP}"
chown -R ${HTUSER}:${HTGROUP} ${OCPATH}/themes/

echo "Changing owner of ${OCPATH}/.htaccess to ${ROOTUSER}:${HTGROUP}"
chown ${ROOTUSER}:${HTGROUP} ${OCPATH}/.htaccess || true # Prevent non-zero exit code if no .htaccess file present
echo "Changing owner of ${DATAPATH}/.htaccess to ${ROOTUSER}:${HTGROUP}"
chown ${ROOTUSER}:${HTGROUP} ${DATAPATH}/.htaccess || true # Prevent non-zero exit code if no .htaccess file present

echo "Changing permissions of ${OCPATH}/.htaccess to 0644"
chmod 0644 ${OCPATH}/.htaccess || true # Prevent non-zero exit code if no .htaccess file present
echo "Changing permissions of ${DATAPATH}/.htaccess to 0644"
chmod 0644 ${DATAPATH}/.htaccess || true # Prevent non-zero exit code if no .htaccess file present
