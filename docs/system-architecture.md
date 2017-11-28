# Raspberry Pi System Architecture as set up by this collection of scripts

## General

This script sets up a collection of web services and related infrastructure, which are isolated from each other through the use of docker containers. Specifically, these are

- an Apache webserver hosting an Owncloud installation,
- a MySQL database server backing the Owncloud, but potentially open to other services as well,
- a [gateway](gateway.md) facilitating domain-based HTTP(S) proxying,
- a [Tvheadend](tvheadend.md) server distributing the TV signal into the LAN,
- a Duplicati installation responsible for backing up the other services' data,
- a CUPS print server.

The containers are able to talk to each other on a network bus called _intercontainer_. All relevant data is stored outside the container (i.e. on the host) in mounted subdirectories under `/var/vol`. 

## Intercontainer bus

This is a simple docker network that serves as a bus for communication between containers. It backs both the gateway's distribution of incoming internet requests as well as communication between individual containers (for instance a web server talking to a database server). Host names are container names.
```
+-------------+    
| Container 1 | ---+
+-------------+    |    +-------------+
                   +--- | Container 2 |
+-------------+    |    +-------------+
| Container 3 | ---+
+-------------+    |    +-------------+
                   +--- | Container 4 |
                   |    +-------------+
                   .
                   .
                   .
            Intercontainer
                   .
                   .
                   .
+-------------+    |
| Container n | ---+
+-------------+    
```

## Gateway

The gateway's purpose is to facilitate operating more than one webserver on the host. It distributes incoming HTTP(S) requests to other containers based on the requested domain name (the requests's HTTP `Host` header).
``` 
                                                                  +-------------+
                                                            +---> | Webserver 1 |
          .-~~~-.                                           |     +-------------+
  .- ~ ~-(       )_ _                                       |
 /                     ~ -.             +-------------+     |     +-------------+
|        HOST NIC           \  <------> |   Gateway   | <---+---> | Webserver 2 |
 \                         .'           +-------------+     |     +-------------+
   ~- . _____________ . -~                                  |
                                                            |     +-------------+
                                                            +---> | Webserver 3 |
                                                                  +-------------+
```
See the [Gateway container documentation](gateway.md) on how to add new HTTP services for domain-based proxying.

## Volumes

All data capturing a container's state should be stored outside that container in volumes located under `/var/vol/<container name>`. E.g. a container called `mysql` should store data either directly under `/var/vol/mysql/` or in subdirectories thereunder. This is to facilitate backups of the individual services' states.
