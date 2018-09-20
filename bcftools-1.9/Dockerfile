FROM debian:stretch-slim
label maintainer "Dave Larson <delarson@wustl.edu>"

# Volumes
VOLUME /build
VOLUME /release

COPY hall-lab-htslib-1.9_1.9-1debian9.5.deb .

# bootstrap build dependencies
RUN apt-get update -qq && \
    apt-get -y install apt-transport-https curl && \
    #apt-get -y install apt-transport-https curl gnupg && \
    #echo "deb https://packages.cloud.google.com/apt cloud-sdk-trusty main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    #curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -qq && \
    apt-get -y install \
    #google-cloud-sdk \
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
    --no-install-recommends && \
    #gsutil cp gs://mgi-ccdg-sw/bootstrap/gs . && \
    #chmod 0755 gs && \
    #mv -v gs /usr/lib/apt/methods && \
    #echo "deb [trusted=yes] gs://mgi-ccdg-sw/apt stretch main" | tee -a /etc/apt/sources.list && \
    #apt-get update -qq && \
    #apt-get install hall-lab-htslib-1.9
    dpkg --install hall-lab-htslib-1.9_1.9-1debian9.5.deb

WORKDIR /build

# Import resources
COPY ./Makefile /build

CMD make
