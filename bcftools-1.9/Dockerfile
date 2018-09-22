FROM debian:stretch-slim
label maintainer "Dave Larson <delarson@wustl.edu>"

# Volumes
#VOLUME /build
VOLUME /release

ARG LIBDEFLATE_VERSION=1.0

# bootstrap build dependencies
RUN apt-get update -qq && \
    apt-get -y install apt-transport-https curl && \
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
    zlib1g \
    zlib1g-dev \
    --no-install-recommends \
    && git clone https://github.com/ebiggers/libdeflate.git \
    && cd libdeflate \
    && git checkout v${LIBDEFLATE_VERSION} \
    && make -j 2 CFLAGS='-fPIC -O3' libdeflate.a \
    && install -Dm644 -t /usr/local/lib libdeflate.a \
    && install -Dm644 -t /usr/local/include libdeflate.h

WORKDIR /build

# Import resources
COPY ./Makefile /build
RUN make debian-build

CMD make
