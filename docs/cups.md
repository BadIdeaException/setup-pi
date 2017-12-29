# The CUPS container

This is a dockerized version of the CUPS print server. It allows to use a purely USB-enabled printer as a network printer.

## Printer as ephemeral device

Being a home printer, the device will not be on at all times. Docker's `device` flag isn't equipped to handle devices that disappear and reappear at container runtime. It would be possible to stop the container when the printer is turned off or otherwise disconnected, and resume it when it comes back online using udev. But this would mean the print server itself also becomes unavailable for configuration and such as long as the printer isn't on.

Therefore, a more complex approach is followed here. Using the `device-cgroup-rule` flag, permission is granted to create device files for the printer's major number. The utils scripts contain a simple script to add and remove devices from containers. Two udev rules are installed that invoke this script on addition and removal of the printer on the host. Execution of the addition is delayed using the `fork-delay` script (also from the utils scripts) to allow for group ownership and permissions to be set beforehand.
