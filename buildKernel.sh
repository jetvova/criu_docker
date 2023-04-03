#!/bin/bash -xeu

cd linux

make bzImage -j9
cp arch/x86/boot/bzImage /area51/home-vova/criu/bzImage

make modules -j9 

sudo make modules_install
