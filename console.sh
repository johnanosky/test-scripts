#!/bin/sh

# A quick script to automate minicom when using RS-232 to USB adapters.

if [ -z $2 ]
then
	C_BAUD=115200
else
	C_BAUD=$2
fi

case $1 in
	a)
		# Grep dmesg output for the last enumerated USB TTY interface
		# Useful when you plug in a new adapter and don't know the current iteration
		TTY_DEV=`dmesg | grep ttyUSB | tail -n1 | awk -F'ttyUSB' '{print $2}'`
		minicom -c on -D /dev/ttyUSB$TTY_DEV -8 -o -l -b $C_BAUD
		;;
	[0-9])
		minicom -c on -D /dev/ttyUSB$1 -8 -o -l -b $C_BAUD
		;;
	*)
		echo "Usage: $0 [a|0-9] [baudrate/115200 is default]"
esac
