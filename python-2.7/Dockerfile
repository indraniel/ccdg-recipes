FROM ubuntu:14.04
MAINTAINER Indraniel Das <idas@wustl.edu>

# Volumes
VOLUME /build
VOLUME /release

# bootstrap build dependencies
RUN apt-get update -qq && \
    apt-get -y install \
    build-essential \
    debhelper \
    automake \
    autotools-dev \
    git \
    curl \
    ca-certificates \
    xz-utils \
    --no-install-recommends

WORKDIR /build

# Import resources
#COPY ./resources /src/resources
COPY ./Makefile /build

CMD make
