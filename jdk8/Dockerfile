FROM ubuntu:14.04
MAINTAINER Indraniel Das <idas@wustl.edu>

# Volumes
VOLUME /build
VOLUME /release

# Install build dependencies
RUN apt-get update -qq && apt-get -y install \
    build-essential \
    debhelper \
    automake \
    autotools-dev \
    git \
    --no-install-recommends

WORKDIR /build

# Import resources
COPY ./resources /build/resources
COPY ./Makefile /build

CMD make
