#!/bin/bash
#
# Wrapper script to allow invocation of all util commands using chrissrv <COMMANDNAME> <ARGUMENTS...>

function check_command() {
	local DIRNAME=$(dirname $0)
	if [ -e "$1" ]
	then
		echo "Unknown command: $1"
		exit 1
	fi
}

check_command "$1"
CMD="$1"
shift # Remove <COMMANDNAME> from arguments
exec "$CMD" "$@"