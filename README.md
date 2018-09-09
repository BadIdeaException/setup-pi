# setup-pi

Ansible-based provisioning of my server. Assumed to run on Raspbian. Ansible needs to be installed.

## Installing Ansible

Ansible can be installed by running (as root)

	echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" > /etc/apt/sources.list.d/ansible.list
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
    apt-get update
	apt-get install ansible

For more information see the [Ansible installation guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#id16)

## Running provisioning

Provisioning for all services can be started by running

	ansible-playbook -i hosts -e @conf all.yml

A 'conf' file is assumed to hold all sensitive data such as the mysql root password.

Alternatively, individual services can be provisioned by running e.g.
	
	ansible-playbook -i hosts -e @conf tvheadend

## System architecture

Documentation is available at [docs/system-architecture.md](docs/system-architecture.md)