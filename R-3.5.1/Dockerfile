FROM ubuntu:14.04
MAINTAINER Indraniel Das <idas@wustl.edu>

# Volumes
VOLUME /build
VOLUME /release

# bootstrap build dependencies
RUN apt-get update -qq && \
    apt-get -y install apt-transport-https curl gnupg && \
    curl -fsSL https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB | apt-key add - && \
    echo 'deb https://apt.repos.intel.com/mkl all main' > /etc/apt/sources.list.d/intel-mkl.list && \
    apt-get update -qq && \
    apt-get -y install \
    build-essential \
    debhelper \
    automake \
    autotools-dev \
    --no-install-recommends

WORKDIR /build

# Import resources
#COPY ./resources /src/resources
COPY ./Makefile /build

CMD make
