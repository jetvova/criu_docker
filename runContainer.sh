#!/bin/bash
set -xeu

docker build --build-arg HOME=$HOME --build-arg UNAME=$(id -un) --build-arg UID=$(id -u) --build-arg GNAME=$(id -gn) --build-arg GID=$(id -g) -t criu .

PROJECT_DIR=$HOME/criu
docker run --privileged --cap-add SYS_ADMIN -ti --rm -v $PROJECT_DIR:$PROJECT_DIR -v /area51/home-vova/criu:/area51/home-vova/criu --name criuContainer -w $PROJECT_DIR criu
