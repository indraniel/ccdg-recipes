FROM debian:stretch-slim
label maintainer "Indraniel Das <idas@wustl.edu>"

# Volumes
# VOLUME /build
VOLUME /release

# bootstrap build dependencies
RUN apt-get update -qq && \
    apt-get -y install apt-transport-https && \
    apt-get update -qq && \
    apt-get -y install \
    build-essential \
    debhelper \
    automake \
    autotools-dev \
    git \
    curl \
    unzip \
    ca-certificates \
    python python-pip \
    libgomp1 \
    libstdc++6 \
    libstdc++-6-dev \
    g++ \
    libgcc1 \
    libxpm4 \
    libxpm-dev \
    zlib1g \
    zlib1g-dev \
    libncurses5-dev \
    --no-install-recommends

WORKDIR /build

# Import resources
COPY ./Makefile /build
RUN make debian-build

CMD make
