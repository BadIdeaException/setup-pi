#!/bin/bash

# Sets up the user passed as argument and adds it to all groups that the standard pi user is in.
# Then deletes the pi user

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Make sure the username argument isn't empty
if [ "$1" == '' ]; then
    echo "Pass a user name as argument."
    exit 1
fi

# Make sure the pi user exists
if [ ! $(users | grep pi) ]; then
    echo "Standard user pi does not exist. Aborting."
    exit 1
fi

USERNAME=$1

adduser $USERNAME

# Add new user to all groups that standard pi user is in
# groups command output will lead with username and colon, so remove that using sed
for grp in `groups pi | sed "s/.*: //"`
do
    adduser $USERNAME $grp
done

userdel pi


