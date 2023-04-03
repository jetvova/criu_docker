#!/bin/bash -xeu

rm -rf ./dump
mkdir ./dump

pkill -f udpClient.out || true
pkill -f socat || true

# Starting 2 servers to test behavior of a corked UDP socket calling sendto() on multiple destinations
setsid socat - UDP4-LISTEN:3000,fork < /dev/null &> ./dump/udpServer3000.log &
setsid socat - UDP4-LISTEN:3001,fork < /dev/null &> ./dump/udpServer3001.log &
sleep 0.1
setsid ./udpClient.out < /dev/null &> ./dump/udpClient.log &

sleep 1
grep "Dump here" ./dump/udpClient.log

./criu dump -t $(pgrep udpClient.out) -v4 -D ./dump -o ./criuDump.log || echo "Dump failed" 
chown -R vova:vova ./dump
cat ./dump/criuDump.log

./criu restore -d -vvv -o criuRestore.log -D ./dump && echo OK
chown -R vova:vova ./dump
