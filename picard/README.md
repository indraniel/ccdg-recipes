# production mode

    docker build -t picard:v1 .
    docker run -i -t -v $PWD:/release --rm picard:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile, and then run:

    docker build -t picard:v1 .
    docker run -i -t -v $PWD:/build --rm picard:v1 bash

# Testing

    docker build -t picard:v1 .
    docker run -i -t -v $PWD:/release --rm picard:v1 bash

    # inside the container
    cd /release
    # manually install the prerequisites for the package
    apt-get install ccdg-oracle-jdk-8u111 ccdg-r-3.3.1
    dpkg --install ccdg-picard-2.4.1_2.4.1-1ubuntu14.04.deb
