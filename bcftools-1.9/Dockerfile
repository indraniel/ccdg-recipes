FROM debian:stretch-slim
MAINTAINER Indraniel Das <idas@wustl.edu>

# Volumes
VOLUME /build
VOLUME /release

# bootstrap build dependencies
RUN apt-get update -qq && \
    apt-get -y install apt-transport-https && \
    apt-get update -qq && \
    apt-get -y install \
    build-essential \
    debhelper \
    bzip2 \
    libbz2-dev \
    liblzma-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    ca-certificates \
    curl \
    zlib1g \
    zlib1g-dev \
    --no-install-recommends

WORKDIR /build

# Import resources
#COPY ./Makefile /build

CMD make
