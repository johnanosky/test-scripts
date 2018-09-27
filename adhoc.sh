#!/bin/sh

# This is a script to help automate testing ad-hoc mode between two host machines.
# It assumes you have an interface up on each host and a wpa_supplicant.conf file
# configured for ad-hoc mode named either open_adhoc or wep_adhoc.
# The first interface from iw dev is used.
# A sample conf file for each can be found in this repo.


# Check to see if the host machine has an IP associated with the interface
LOCAL_ADDR=`ip addr | grep 192 | awk -F '.' '{print $4}' | awk -F '/' '{print $1}'`
W_DEV=`iw dev | grep -i interface | awk -F ' ' '{print $2}'`
case $1 in
	open)
		ip link set $W_DEV down
		killall NetworkManager >/dev/null 2>&1
		killall wpa_supplicant >/dev/null 2>&1
		ip link set $W_DEV up
		wpa_supplicant -i $W_DEV -Dnl80211 -c open_adhoc.conf &
		;;
	wep)
		ip link set $W_DEV down
		killall NetworkManager >/dev/null 2>&1
		killall wpa_supplicant >/dev/null 2>&1
		ip link set $W_DEV up
		wpa_supplicant -i $W_DEV -Dnl80211 -c wep_adhoc.conf &
		;;
		*)
		echo "Usage: $0 [open|wep] [local 4th octect] [remote 4th octect]"
		exit 0
esac
sleep 10
iw $W_DEV link
if [ -z $LOCAL_ADDR ]
then
	ip addr add 192.168.1.$2/24 dev $W_DEV
	ip route add 192.168.1.0/24 dev $W_DEV
	ip route add default via 192.168.1.254
else
	if [ $LOCAL_ADDR != $2 ]
	then
		ip addr del 192.168.1.$LOCAL_ADDR/24 dev $W_DEV
	fi
fi
ping -c 10 192.168.1.$3 &
