# Raspberry Pi System Architecture as set up by this collection of scripts

## Abstract

This script sets up a collection of web services and related infrastructure, which are isolated from each other through the use of docker containers. The containers are able to talk to each other on a network bus called _intercontainer_. All relevant data is stored outside the container (i.e. on the host) in mounted subdirectories under `/var/vol`.

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

No containers are directly accessible from the network. Instead, a special dedicated gateway container serves as a reverse proxy and distributes incoming connection requests to the individual services as applicable. Distribution is based on the requested domain name (the request's HTTP `Host` header). 
The gateway listens on all IP addresses on ports 80 and 443.
``` 
                                                                  +-------------+
                                                            +---> | Container 1 |
          .-~~~-.                                           |     +-------------+
  .- ~ ~-(       )_ _                                       |
 /                     ~ -.             +-------------+     |     +-------------+
|        INTERNET           \  <------> |   Gateway   | <---+---> | Container 2 |
 \                         .'           +-------------+     |     +-------------+
   ~- . _____________ . -~                                  |
                                                            |     +-------------+
                                                            +---> | Container 3 |
                                                                  +-------------+
```
See the [Gateway container documentation](doc/gateway.md) on how to add new services.

## Intercontainer bus

This is a simple docker network that serves as a bus for communication between containers. It backs both the gateway's distribution of incoming internet requests as well as communication between individual containers (for instance a web server talking to a database server). Host names are container names.

## Volumes

All data capturing a container's state should be stored outside that container in volumes located under `/var/vol/<container name>`. E.g. a container called `mysql` should store data either directly under `/var/vol/mysql/` or in subdirectories thereunder. This is to facilitate backups of the individual services' states.