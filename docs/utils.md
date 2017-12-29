# The utils scripts

This is a small collection of scripts to make administration of the server easier. They are invoked centrally through the `chrissrv` script. Although these scripts are installed under `/usr/share/chrissrv/`, the invocation script `chrissrv` is symlinked to `/usr/bin/chrissrv` and therefore available from anywhere.

## `chrissrv`

Single point of access for all other scripts. 

```
SYNTAX

chrissrv <COMMAND> <PARAMETERS>
```

Accepted commands are the names of the other scripts in the utils collection.

## container-manage-devices

Remove device files from a running container, and add device files to a running container that mirror their counterpart on the host. 

```
SYNTAX

container-manage-devices add <CONTAINER> <DEVICE>
container-manage-devices rm <CONTAINER> <DEVICE>
```

Thus, invoking `container-manage-devices rm cups /dev/usb/lp0` will remove the `lp0` device from the `cups` container. Running `container-manage-devices add cups /dev/usb/lp0` will create the path to the device file, create it using `mknod`, mirroring the permissions, major and minor numbers of the corresponding file on the host, and adjust its group id to that of the hosts file. (The user id doesn't need to be adjusted because devices are always owned by the root user.) If a device file of that name already exists, it will be replaced.

The target container must have the required cgroup rule set. See the [device-cgroup-rule](https://docs.docker.com/edge/engine/reference/commandline/create/#dealing-with-dynamically-created-devices-device-cgroup-rule) option for `docker create` and `docker run`.

## fork-delay

Execute a command in a new and disowned process after a delay.

```
SYNTAX

fork-delay <DELAY> <COMMAND>
```

The delay is given in seconds, but floats are accepted if the system's implementation of `sleep` accepts them. Delaying is done in the forked process, so this script will return immediately.