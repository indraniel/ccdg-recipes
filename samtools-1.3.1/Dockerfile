FROM ubuntu:14.04
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
    libcurl4-openssl-dev \
    ca-certificates \
    curl \
    zlib1g \
    zlib1g-dev \
    libncurses5-dev \
    --no-install-recommends

WORKDIR /build

# Import resources
COPY ./Makefile /build

CMD make
