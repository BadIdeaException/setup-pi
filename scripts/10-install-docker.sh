#!/bin/bash

# Sets up docker as described here: https://docs.docker.com/engine/installation/linux/raspbian/

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Required for installing from the repo
apt-get install -y apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# Set up ppa
echo "deb https://apt.dockerproject.org/repo raspbian-jessie main" > /etc/apt/sources.list.d/docker.list
apt-get update

# Make sure docker package will be pulled from the repo
if [ ! $(apt-cache policy docker-engine | grep dockerproject.org) ]; then
    echo "There was an error setting up the docker repo. Aborting."
    exit 1
fi

# Install
apt-get install -y docker-engine

# Start docker
service docker start

