blstools
========

This is a small set of scripts that control some behaviour of Buffalo LinkStation
LS-WXL and LS-CHL (and possibly LS-XHL). They are supposed to be installed under
Debian Lenny/Squeeze, after a debootstrap installation which leaves active the
"buffalo kernel extensions", i.e. the `/proc/buffalo` stuff.

Scripts are partly derived from the stock LinkStation software but have been 
totally rewritten in order not to use the `/usr/sbin/miconapl` utility and to
rely only on `/proc/buffalo`, which greatly reduces dependencies.

Work is in progress to implement some interesting features such as handling the
"function" button in front/back of the unit.

Some technical documentation is available under `docs/` directory.


Disclaimer
----------

This is experimental software. I happen to be quite satisfied with it, but I cannot 
guarantee the same for other.

Whatever you do with it you do it at your own risk. Be aware that you may lose data
or even permanently damage or brick your unit.


Installation
------------

Supported products:

 - Buffalo LinkStation Duo (LS-WXL)
 - Buffalo LinkStation Live III (LS-CHL v2)
 - Buffalo LinkStation Pro (LS-XHL) [not tested]

Software prerequisite is a plain Debian Lenny/Squeeze installation. Guides are available at:

 - http://buffalo.nas-central.org/wiki/Debian_Squeeze_on_LS-WXL
 - http://buffalo.nas-central.org/wiki/Debian_Lenny_on_LS-WXL
 - http://buffalo.nas-central.org/wiki/Debian_Squeeze_on_LS-CHLv2
 - http://buffalo.nas-central.org/wiki/Debian_Lenny_on_LS-CHLv2

Also required is the `smartmontools` package in order to be able to get system temperature
from HDD:

	sudo apt-get install smartmontools

Installing should be as simple as downloading/unpacking the package directly on the
LinkStation and then running:

	sudo ./install.sh


Features
--------

### 1. lsmonitor (`/etc/init.d/lsmonitor`)

This is a daemon that is automatically started when the system boots. You don't need
to call it directly.

lsmonitor stops the blue led from flashing and provides a reassuring, still blue 
light. Also, when you move the switch in "off" position lsmonitor initiates system 
shutdown (which is nice, isn't it)?

lsmonitor controls the fan speed on system temperature. Since there are
no system temperature sensors, temperature is read from Hard Disk 
information (S.M.A.R.T.), which is managed through smartmontools (thanks 
to archonfx@Buffalo NAS central forums for suggestion). There are three 
thresholds, HDDTEMP0, HDDTEMP1 and HDDTEMP2 (defaults 40, 45 and 50 
Celsius degrees):

 - if T < HDDTEMP0 fan is stopped
 - if HDDTEMP0 <= T < HDDTEMP1 fan runs at slow speed
 - if HDDTEMP1 <= T < HDDTEMP2 fan runs at fast speed
 - if T >= HDDTEMP2 fan runs at full speed

Temperature thresholds can be configured in `/etc/default/lsmonitor`. 

lsmonitor checks if one presses the function button in the front of the unit. 
If so, it runs all the scripts and executables found in `/etc/blstools/func-scripts/`. 
During the execution of the scripts the function button is turned into flashing blue.
This is useful as a quick access method to special functions, such as a backup 
script that is run on demand by the user. You can know whether the scripts are 
running and when they finish by looking at the blinking light. Note that pressing
the function button while the func-scripts are running has no effect.
Note also that the scripts in `/etc/blstools/func-scripts/` are run as `root` user.
Output produced by the scripts is logged to `/var/log/blstools/func-scripts.log`, which
is rotated by `/etc/logrotate.d/blstools` script.

### 2. usb (`/etc/init.d/usb`)

Powers on and off the USB interface.

When you want to connect a USB disk to the LinkStation you should first call
`/etc/init.d/usb start` and then you will be able to mount the USB drive to the
desired location (generally, the device will be `/dev/sdb1`).


Development
-----------

This is open source software. The original sources are under SVN on SourceForge and
can be checked-out at the following URL:

 - https://blstools.svn.sourceforge.net/svnroot/blstools/trunk

You are welcome to contribute. Please write your ideas and suggestions to 
michele.manzato@gmail.com.


Contributors
------------

Thanks to the contributors:

 - Michele Manzato
 - Guilherme Cardoso
 - Christian Neff (secondtruth)
