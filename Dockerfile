# Base image must be 20.04 for PetaLinux 2022.1 and Yocto
FROM ubuntu:24.04

# Prevent interactive prompts during apt installations
ENV DEBIAN_FRONTEND=noninteractive

# Add 32-bit architecture (required for zlib1g:i386 and other 32-bit libraries)
RUN dpkg --add-architecture i386

# Install dependencies required by PetaLinux and Yocto
RUN apt-get update && apt-get install -y \
    apt-utils \
    autoconf \
    bc \
    bison \
    build-essential \
    ca-certificates \
    chrpath \
    cpio \
    diffstat \
    expect \
    flex \
    gawk \
    gcc-multilib \
    git \
    gnupg \
    gzip \
    iproute2 \
    libglib2.0-dev \
    libncurses5-dev \
    libsdl2-dev \
    libselinux1 \
    libssl-dev \
    libtinfo6 \
    libtool \
    libtool-bin \
    locales \
    lsb-release \
    lz4 \
    make \
    net-tools \
    pax \
    python3 \
    python3-pip \
    python3-pexpect \
    python3-git \
    python3-jinja2 \
    screen \
    socat \
    sudo \
    tar \
    texinfo \
    tftpd-hpa \
    tofrodos \
    unzip \
    update-inetd \
    wget \
    xterm \
    xvfb \
    zlib1g-dev \
    zlib1g:i386 \
    zstd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up locale (Yocto/PetaLinux requires en_US.UTF-8)
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Change default shell from dash to bash (CRITICAL for Yocto/PetaLinux)
RUN echo "dash dash/sh boolean false" | debconf-set-selections && dpkg-reconfigure dash

# Create a non-root user named 'syvesdh' with sudo privileges to match the host workspace
RUN useradd -m -G dialout,sudo -s /bin/bash syvesdh && \
    echo "syvesdh ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set the working directory to match the host path exactly
WORKDIR /home/syvesdh/NinoxWorkspace/kv260-workspace

# Switch to the non-root user
USER syvesdh
