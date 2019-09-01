FROM debian:stretch-slim
label maintainer "Indraniel Das <idas@wustl.edu>"

# Volumes
VOLUME /build
VOLUME /release

# bootstrap build dependencies
RUN apt-get update -qq && \
    apt-get -y install apt-transport-https && \
    apt-get update -qq && \
    apt-get -y install \
    build-essential \
    git-core \
    debhelper \
    bzip2 \
    libbz2-dev \
    liblzma-dev \
    libssl1.0-dev \
    libcurl4-openssl-dev \
    ca-certificates \
    curl \
    zlib1g-dev \
    libncurses5-dev \
    autoconf \
    automake \
    --no-install-recommends

WORKDIR /build

# Import resources
COPY ./Makefile /build
#RUN make debian-build

CMD make
