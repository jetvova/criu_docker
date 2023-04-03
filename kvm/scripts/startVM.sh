#!/bin/bash -exu

# sudo ./virtiofsd --socket-path ./vhostqemu --shared-dir /area51/home-vova/criu/fakeRoot &
sleep 0.2
sudo chown vova:vova ./vhostqemu

kvm \
    -s \
    -cpu host \
    -accel kvm \
    -kernel "./bzImage" \
    -chardev socket,id=char0,path=./vhostqemu \
    -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs \
    -append "console=ttyS0 init=/area51/home-vova/criu/scripts/init.sh rootfstype=virtiofs root=myfs rw" \
    -serial mon:stdio \
    -drive format=raw,file=vmdisk.img \
    -m 8G \
    -object memory-backend-file,id=mem,size=8G,mem-path=/dev/shm,share=on \
    -numa node,memdev=mem \
    -nographic
