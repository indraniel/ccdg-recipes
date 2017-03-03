# production mode

    docker build -t extract-sv-reads:v1 .
    docker run -i -t -v $PWD:/release --rm extract-sv-reads:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile, and then run:

    docker build -t extract-sv-reads:v1 .
    docker run -i -t -v $PWD:/build --rm extract-sv-reads:v1 bash

# Testing

    docker build -t extract-sv-reads:v1 .
    docker run -i -t -v $PWD:/release --rm extract-sv-reads:v1 bash

    # inside the container
    cd /release
    # manually install the prerequisites for the package
    dpkg --install ccdg-extract-sv-reads-0.6.5_0.6.5-1ubuntu14.04.deb
