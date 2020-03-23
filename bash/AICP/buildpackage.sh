#! /bin/bash


echo -e "    ----- Build package -----\n" 
if [ $# -ne 1 ]; then

	echo -e "Usage: buildpackage.sh <package name>"
	exit 16
fi
Package=$1

echo -e "building package: $Package"

adb root
#adb disable-verity
#adb reboot
adb remount -R
adb wait-for-device
adb root
adb remount

mmp $Package

exit 0
