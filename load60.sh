#!/bin/sh

ls -l /lib/firmware/lrdmwl/
read -p "If the firmware is linked properly, press enter to continue..."

rmmod mac80211 >/dev/null 2>&1
rmmod cfg80211 >/dev/null 2>&1
insmod compat.ko
insmod cfg80211.ko
insmod mac80211.ko
insmod lrdmwl.ko
case $1 in
	s99)
		echo 99000000 > /sys/kernel/debug/mmc0/clock
		cat /sys/kernel/debug/mmc0/ios
		INTERFACE="lrdmwl_sdio.ko"
		;;
	s)
		cat /sys/kernel/debug/mmc0/ios
		INTERFACE="lrdmwl_sdio.ko"
		;;
	p)
		INTERFACE="lrdmwl_pcie.ko pcie_intr_mode=1"
		;;
	u)
		INTERFACE="lrdmwl_usb.ko"
		;;
	*)
		echo -e "Usage:\n$0 [s99|s|p|u] [w|b|bf] [ttyDev] [sleep1] [sleep2]"
esac
case $2 in
	w)
		insmod $INTERFACE
		;;
	b)
		insmod $INTERFACE
		insmod bluetooth.ko
		insmod hci_uart.ko
		insmod rfcomm.ko
		echo "Done loading modules..."
		sleep $4
		echo "Attaching hci to $3"
		hciattach $3 any 3000000 0
		sleep $5
		hciconfig
		hciconfig hci0 up
		;;
	bf)
		insmod $INTERFACE
		insmod bluetooth.ko
		insmod hci_uart.ko
		insmod rfcomm.ko
		echo "Done loading modules..."
		sleep $4
		echo "Attaching hci to $3"
		hciattach $3 any -s 3000000 3000000 flow dtron
		sleep $5
		hciconfig
		hciconfig hci0 up
		;;
	bu)
		insmod $INTERFACE
		insmod bluetooth.ko
		insmod btusb.ko
		insmod rfcomm.ko
		echo "Done loading modules..."
		sleep $4
		echo "Attaching hci to $3"
		hciattach $3 any 3000000 0
		sleep $5
		hciconfig
		hciconfig hci0 up
		;;
esac
