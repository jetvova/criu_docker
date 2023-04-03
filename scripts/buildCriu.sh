#!/bin/bash -xeu
CC=gcc

cd criu
time make -j $(nproc) CC="$CC"
time make -j $(nproc) CC="$CC" -C test/zdtm

cd ./criu
cp ./criu /area51/home-vova/criu/criu
./criu --version
