# production mode

    docker build -t bedtools-2.23.0:v1 .
    docker run -i -t -v $PWD:/release --rm bedtools-2.23.0:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile, and then run:

    docker build -t bedtools-2.23.0:v1 .
    docker run -i -t -v $PWD:/build --rm bedtools-2.23.0:v1 bash

# Testing

    docker build -t bedtools-2.23.0:v1 .
    docker run -i -t -v $PWD:/release --rm bedtools-2.23.0:v1 bash

    # inside the container
    cd /release
    # manually install the prerequisites for the package
    dpkg --install ccdg-bedtools-2.23.0_2.23.0-1ubuntu14.04.deb
