FROM ubuntu:22.04

# Installing utils
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
	gcc-multilib \
	libnet-dev \
	libnl-route-3-dev \
	gcc \
	bsdmainutils \
	build-essential \
	git-core \
	iptables \
	libaio-dev \
	libbsd-dev \
	libcap-dev \
	libgnutls28-dev \
	libgnutls30 \
	libnftables-dev \
	libnl-3-dev \
	libprotobuf-c-dev \
	libprotobuf-dev \
	libselinux-dev \
	iproute2 \
	kmod \
	pkg-config \
	protobuf-c-compiler \
	protobuf-compiler \
	python-is-python3 \
	python3-minimal \
	python3-protobuf \
	python3-yaml \
	python3-future \
	libelf-dev \
	cmake \
    openssh-client \
    git \
    sudo \
    qemu-kvm virt-manager libvirt-daemon-system virtinst libvirt-clients bridge-utils \
    libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf llvm \
    bc nftables zstd cpio

ARG HOME
ARG UNAME
ARG UID
ARG GNAME
ARG GID

# Ensure sudo group users are not 
# asked for a password when using 
# sudo command by ammending sudoers file
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Python pip packages
# RUN pip install --upgrade pip
# RUN pip install ipaddress

RUN mkdir -p $HOME
RUN groupadd -g $GID $GNAME
RUN useradd -m -d $HOME -u $UID -g $GID -s /bin/bash $UNAME
RUN sudo usermod -aG sudo $UNAME
RUN chown -R $UNAME:$GNAME $HOME

USER $UNAME
WORKDIR $HOME

RUN echo 'export PATH=$PATH:$HOME' > $HOME/.bashrc
RUN echo 'export PATH=$PATH:$HOME/bin' > $HOME/.bashrc
CMD /bin/bash
