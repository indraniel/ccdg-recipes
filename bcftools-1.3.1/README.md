# production mode

    docker build -t bcftools-1.3.1:v1 .
    docker run -i -t -v $PWD:/release --rm bcftools-1.3.1:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile, and then run:

    docker build -t bcftools-1.3.1:v1 .
    docker run -i -t -v $PWD:/build --rm bcftools-1.3.1:v1 bash

# Testing

    docker build -t bcftools-1.3.1:v1 .
    docker run -i -t -v $PWD:/release --rm bcftools-1.3.1:v1 bash

    # inside the container
    cd /release
    # manually install the prerequisites for the package
    dpkg --install ccdg-bcftools-1.3.1_1.3.1-1ubuntu14.04.deb
