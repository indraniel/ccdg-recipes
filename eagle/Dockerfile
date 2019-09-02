FROM debian:stretch-slim
label maintainer "Indraniel Das <idas@wustl.edu>"

# Volumes
VOLUME /build
VOLUME /release

# bootstrap build dependencies
RUN apt-get update -qq && \
    apt-get -y install apt-transport-https \
    && apt-get -y install apt-transport-https \
    && echo "deb [trusted=yes] https://gitlab.com/indraniel/hall-lab-debian-repo-1/raw/master stretch main" | tee -a /etc/apt/sources.list \
    && apt-get update -qq \
    && apt-get -y install \
    build-essential \
    git-core \
    debhelper \
    libstdc++-6-dev \
    libgomp1 \
    libssl1.0-dev \
    libcurl4-openssl-dev \
    libcurl3 \
    libopenblas-dev \
    libboost-random-dev \
    libboost-iostreams-dev \
    libboost-program-options-dev \
    ca-certificates \
    curl \
    zlib1g-dev \
    hall-lab-htslib-1.9 \
    --no-install-recommends

WORKDIR /build

# Import resources
COPY ./Makefile /build
#RUN make debian-build

CMD make
