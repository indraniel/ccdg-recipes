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

WORKDIR /src

# Import resources
COPY ./resources /src/resources
COPY ./Makefile /build

# production mode
#

# invoke the docker command as:
#     docker run -i -t -v $PWD:/release --rm jdk8:v1 bash  

# Development Mode
#
# don't invoke: "COPY ./Makefile /build" in the Dockerfile,
# rather run:
#     docker run -i -t -v $PWD:/build --rm jdk8:v1 bash