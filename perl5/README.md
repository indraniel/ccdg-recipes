# Production mode

    docker build -t perl:v1 .
    docker run -i -t -v $PWD:/release --rm perl:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile, and then run:

    docker build -t perl:v1 .
    docker run -i -t -v $PWD:/build --rm perl:v1 bash

# Testing

    docker build -t perl:v1 .
    docker run -i -t -v $PWD:/release --rm perl:v1 bash

    # inside the container
    cd /release
    # manually install the prerequisites for the package
    apt-get install make libc6
    dpkg --install ccdg-perl-5.24.0_5.24.0-1ubuntu14.04.deb
