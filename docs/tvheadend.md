# The Tvheadend container

The purpose of this container is to run a [Tvheadend server][1] and stream TV channels received through an attached DVB USB device into the LAN. The [LinuxServer Tvheadend image][2] does this job nicely.

## Giving Tvheadend access to the device

Just passing the device into the container using docker's `device` flag isn't enough to make it work with Tvheadend. The reason for this is that Tvheadend doesn't run as root, but the device (on the host) is owned by user root and group video. This is propagated to the container, and the adapter never shows up in Tvheadend. To solve this, the image's `PGID` argument can be used by adding `--env PGID=$(stat -c %g /dev/dvb/adapter0/frontend0)` to the docker `run` command.

## Enabling multicast

According to the image usage notes, there is an issue with Docker that requires to use the host network for multicast to work properly. Therefore, the `--net=host` flag needs to be added to the `run` command.

## Working with the XBox One Digital TV tuner

One of the cheapest usb tuner cards out there is the [XBox One Digital TV tuner][3]. However, as of November 2017, this device is not supported out of the box by the Linux kernel. To check whether it is supported, plug it in and run `dmesg`. If the output looks like this

```
[    2.474202] usb 1-1.2: New USB device found, idVendor=045e, idProduct=02d5
[    2.477205] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.480107] usb 1-1.2: Product: Xbox USB Tuner
[    2.482890] usb 1-1.2: Manufacturer: Microsoft Corp.
[    2.485615] usb 1-1.2: SerialNumber: 002398080415
```

but doesn't have any additional lines, it's not supported. However if there are lines saying

```
[    4.608537] dvb-usb: found a 'Microsoft Xbox One Digital TV Tuner' in cold state, will try to load a firmware
[    4.610915] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[    4.671946] dib0700: firmware started successfully.
[    5.186951] dvb-usb: found a 'Microsoft Xbox One Digital TV Tuner' in warm state.
[    5.187204] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[    5.187312] dvbdev: DVB: registering new adapter (Microsoft Xbox One Digital TV Tuner)
[    5.187333] usb 1-1.2: media controller created
[    5.189161] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
[    5.449706] mn88472 3-0018: Panasonic MN88472 successfully identified
[    5.462705] tda18250 3-0060: NXP TDA18250BHN/M successfully identified
[    5.464584] usb 1-1.2: DVB: registering adapter 0 frontend 0 (Panasonic MN88472)...
[    5.464611] dvbdev: dvb_create_media_entity: media entity 'Panasonic MN88472' registered.
[    5.466383] dvb-usb: Microsoft Xbox One Digital TV Tuner successfully initialized and connected.
```
it's already supported.

### Adding support

A full set of instructions can be found in a thread on the Tvheadend board, particularly [this message][4]. However, before following the instructions in that post, two packages need to be installed, or the compilation process will fail: `sudo apt-get install raspberrypi-kernel-headers libproc-processtable-perl`. After that, proceed as per the instructions:

```
git clone git://linuxtv.org/media_build.git
git clone --depth=1 https://github.com/trsqr/media_tree.git -b xboxone ./media
cd media_build
git reset --hard 9ccb87d
make dir DIR=../media
make distclean
make
```

Afterwards, reboot. The tuner card should work now.

## Administration

Tvheadend offers an administration program that runs in the browser and is offered on port 9981.

[1]: https://tvheadend.org/
[2]: https://hub.docker.com/r/lsioarmhf/tvheadend/
[3]: https://www.amazon.de/Xbox-One-Digital-TV-Tuner/dp/B00E97HVJI
[4]: https://tvheadend.org/boards/5/topics/13685?r=28369#message-28369