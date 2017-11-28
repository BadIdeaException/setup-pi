# The CUPS container

This is a dockerized version of the CUPS print server. It allows to use a purely USB-enabled printer as a network printer.

## Printer as ephemeral device

Being a home printer, the device will not be on at all times. Docker's `device` flag isn't equipped to handle devices that disappear and reappear at container runtime. It would be possible to stop the container when the printer is turned off or otherwise disconnected, and resume it when it comes back online using udev. But this would mean the print server itself also becomes unavailable for configuration and such as long as the printer isn't on.

Therefore, a more complex approach is followed here. Using the `device-cgroup-rule` flag, permission is granted to create device files for the printer's major number. A simple device management script to add and remove device files in containers is installed to /usr/local/bin. Finally, two udev rules are installed that invoke this script on addition and removal of the printer on the host.

## Device management in the container

The `/usr/local/bin/container-manage-devices` script exists to remove device files from a running container, and to add device files to a running container that mirror their counterpart on the host. 

Thus, invoking `container-manage-devices rm cups /dev/usb/lp0` will remove the `lp0` device from the `cups` container. Running `container-manage-devices add cups /dev/usb/lp0` will create the path to the device file, create it using `mknod`, mirroring the permissions, major and minor numbers of the corresponding file on the host, and adjust its group id to that of the hosts file. (The user id doesn't need to be adjusted because devices are always owned by the root user.)