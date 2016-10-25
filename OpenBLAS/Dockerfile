FROM ubuntu:14.04
MAINTAINER Indraniel Das <idas@wustl.edu>

# Volumes
VOLUME /build
VOLUME /release

# Install basic build dependencies
RUN apt-get update -qq && apt-get -y install \
    build-essential \
    debhelper \
    automake \
    autotools-dev \
    git \
	curl \
    --no-install-recommends

WORKDIR /build

# Import resources
COPY ./Makefile /build

CMD make

# --------- Production Mode ---------
#
# invoke the docker command as:
#     docker build -t openblas:v1 .
#     docker run -i -t -v $PWD:/release --rm openblas:v1

# --------- Development Mode ---------
#
# don't invoke: "COPY ./Makefile /build" in the Dockerfile,
# rather run:
#     docker run -i -t -v $PWD:/build --rm jdk8:v1 bash