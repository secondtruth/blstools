#!/bin/sh

# Check running user
USERID=$(id -u)
if [ $USERID -ne 0 ] ; then
	echo 'This program must be run as root.'
	exit 1
fi

# Is this machine a LinkStation?
FWINFO=/proc/buffalo/firmware
if [ ! -f $FWINFO ] || [ `grep SERIES $FWINFO` != 'SERIES=LinkStation' ] ; then
	echo 'This machine is not a LinkStation.'
	exit 1
fi

# Detect LinkStation model
MODEL=`grep PRODUCTNAME $FWINFO | cut -c 13-18`
case $MODEL in
	LS-WXL|LS-CHL)
		echo "Detected LinkStation model: $MODEL"
		;;

	LS-XHL)
		echo "Detected LinkStation model: $MODEL"
		while true; do
			read -p "Not yet tested on your platform. Install anyway? [y/n] " yn
			case $yn in
				[Yy]*) break;;
				[Nn]*) exit;;
				*) echo "Please answer 'yes' or 'no'.";;
			esac
		done
		;;

	*)
		echo "This LinkStation model ($MODEL) is not supported."
		exit 1
		;;
esac

# Create directories
mkdir /etc/blstools 2> /dev/null
mkdir /var/log/blstools 2> /dev/null
mkdir /etc/blstools/func-scripts 2> /dev/null
mkdir /etc/logrotate.d 2> /dev/null

# Install scripts 
cp init.d/* /etc/init.d
cp logrotate.d/* /etc/logrotate.d
cp default/$MODEL/* /etc/default

# Install lsmonitor daemon
update-rc.d -f lsmonitor remove
update-rc.d lsmonitor defaults 99 00
