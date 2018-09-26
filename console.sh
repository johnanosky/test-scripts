#!/bin/sh

set -x
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
		TTY_TEST=`ps -aux | grep minicom | grep ttyUSB$TTY_DEV | tail -n1`
		if [ -z $TTY_TEST ]; then
			minicom -c on -D /dev/ttyUSB$TTY_DEV -8 -o -l -b $C_BAUD
		else echo "A minicom session is already running on /dev/ttyUSB$TTY_DEV"
		fi
		;;
	imx7)
		# For NXP i.MX7 SABRE EVK
		TTY_DEV=`dmesg | grep ttyUSB | tail -n2 | head -n1 | awk -F'ttyUSB' '{print $2}'`
		TTY_TEST=`ps -aux | grep minicom | grep ttyUSB$TTY_DEV | tail -n1`
		if [ -z $TTY_TEST ]; then
			minicom -c on -D /dev/ttyUSB$TTY_DEV -8 -o -l -b $C_BAUD
		else echo "A minicom session is already running on /dev/ttyUSB$TTY_DEV"
		fi
		;;
	[0-9])
		TTY_TEST=`ps -aux | grep minicom | grep ttyUSB$1`
		if [ -z $TTY_TEST ]; then
			minicom -c on -D /dev/ttyUSB$1 -8 -o -l -b $C_BAUD
		else echo "A minicom session is already running on /dev/ttyUSB$1"
		fi
		;;
	*)
		echo "Usage: $0 [a|imx7|0-9] [baudrate/115200 is default]"
esac
