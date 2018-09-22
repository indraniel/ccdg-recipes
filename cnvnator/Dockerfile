FROM debian:stretch-slim
label maintainer "Indraniel Das <idas@wustl.edu>"

# Volumes
VOLUME /build
VOLUME /release

# bootstrap build dependencies
RUN apt-get update -qq && \
    apt-get -y install apt-transport-https && \
#    echo "deb [trusted=yes] https://bitbucket.org/idas/ccdg-apt-repo/raw/master ccdg main" | tee -a /etc/apt/sources.list && \
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
 #   hall-lab-python-2.7.15 \
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

ENV PATH=/hall-lab/ccdg/python-2.7.15/bin:${PATH}

# Import resources
COPY ./Makefile /build

CMD make && make debian
