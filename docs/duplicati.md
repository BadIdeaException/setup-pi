# The Duplicati container

The gateway is responsible creating backups of all containers' volumes. It uses the [duplicati docker image supplied by LinuxServer][1].

## Permissions

For security reasons, containers are likely to create dedicated users within themselves to facilitate running their offered services at reduced privileges. Files stored in their volumes are therefore likely to have a variety of owners and permissions, and are sometimes not world-readable. This, however, creates difficulties when trying to back them up using a dedicated container as the executing user of the backup process will frequently not be permitted to access the files it needs to back up (one example of this is mysql).

### Solution 1: Make all files world-readable

One solution would be to change file permissions in all volumes to allow at least read access to anyone. This is clearly undesirable for two reasons: 

1. It makes the system less secure, and, in fact, some services routinely check file permissions at start up and will refuse to progress if they detect unsafe settings
2. It is error prone, as adjusting the permissions would frequently have to be repeated to catch newly created files. Running a backup before rerunning the adjustment could result in an error if the new files have restrictive permissions.

## Solution 2: Add backup user to all groups

Another way would be to add the backup user to all groups. This is undesirable for reasons similar to those given above. In addition, this might fail in the presence of super-restrictive file permissions.

## Solution 3: Make use of Linux capability system

[Linux capabilities][2] allow for more fine-grained control over what a process is or isn't allowed to do. Docker offers an option to add or remove capabilities using the `--add-caps` option to the `run` command. The `DCA_READ_SEARCH` capability allows to ignore permission restrictions on file reads and directory listings, which is exactly what is needed here. 

_Note: It appears that this only pertains to the `root` user, therefore, the `PUID` environment variable offered by LinuxServer's image is used to make sure the container's `root` is running the duplicati server. By default, the image introduces a dedicated user for this.

Note that this is *not* the same as running the container in privileged mode (with the `--privileged` flag), which would allow the container to do almost anything on the host. Instead, the extensive permissions granted to `root` only apply inside the container._

[1]: https://hub.docker.com/r/lsioarmhf/duplicati/
[2]: https://www.google.de/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwjooOW5hMbXAhUGtBoKHWyYAYQQFggnMAA&url=http%3A%2F%2Fman7.org%2Flinux%2Fman-pages%2Fman7%2Fcapabilities.7.html&usg=AOvVaw1owhGtq9-Spz-8fdZMBcd7