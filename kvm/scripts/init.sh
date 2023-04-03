#!/bin/bash -x

stty cols 500
stty rows 500

ip link set lo up
ip a a 127.0.0.1/8 dev lo

mount -t proc proc /proc
mount -t sysfs sysfs /sys

cd /area51/home-vova/criu

exec /bin/bash
