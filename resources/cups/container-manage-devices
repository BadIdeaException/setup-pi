#!/bin/bash
#
# Script to determine the major/minor number of the printer on the host and add a respective device file in the container

OP=$1
CONTAINER=$2
DEV=$3

function add_device() {
	MAJOR=$(echo $((0x$(stat -c "%t" "$DEV")))) # Get major number and convert to decimal with echo
	MINOR=$(echo $((0x$(stat -c "%T" "$DEV")))) # Get minor number and convert to decimal with echo
	MODE=$(stat -c "%a" "$DEV") # Get device file permissions
	GID=$(stat -c "%g" "$DEV") # Get device file group id

	docker exec $CONTAINER /bin/bash -c "mkdir -p $(dirname $DEV) \
		&& mknod -m $MODE $DEV c $MAJOR $MINOR \
		&& chgrp $GID $DEV \
		&& echo Character device $DEV created as $MAJOR:$MINOR with owner root:$GID and permissions $MODE"
}

function rm_device() {
	docker exec $CONTAINER /bin/bash -c "rm $DEV && echo Device $DEV removed"
}

function print_usage() {
	echo "Manage ephemeral devices in running containers.

Usage:
	container-manage-devices add <CONTAINER> <DEVICE>
	container-manage-devices add <CONTAINER> <DEVICE>

where <CONTAINER> is the name or id number of the container and <DEVICE> is the full path to the device file to be added or removed. The container must be running."
}

function check_params_ok() {
	if [ -n $OP ] && [ -z $CONTAINER ]
	then
		echo "Missing argument: container not specified. Run container-manage-devices -h for instructions on how to use."
		exit 1
	elif [ -n $OP ] && [ -z $DEV ]
	then
		echo "Missing argument: device not specified. Run container-manage-devices -h for instructions on how to use."
		exit 1
	fi
}

case $OP in
	"add")
		check_params_ok
		add_device
		;;
	"rm")
		check_params_ok
		rm_device
		;;
	"-h")	print_usage
		;;
	*) 
		echo "Unknown or missing operation specified. Run container-manage-devices -h for instructions on how to use."
		exit 1
esac