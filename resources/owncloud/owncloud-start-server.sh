#!/bin/bash

# Set environment variables needed by apache
source /etc/apache2/envvars

# If this is not the first start of this container, it won't start again if the pid file is still present
# So delete it
rm -f $APACHE_PID_FILE

echo "Starting owncloud on Apache 2 server"
/usr/sbin/apache2 -DFOREGROUND
