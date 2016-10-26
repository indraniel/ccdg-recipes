# production mode

    docker build -t r:v1 .
    docker run -i -t -v $PWD:/release --rm r:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile, and then run:

    docker build -t r:v1 .
    docker run -i -t -v $PWD:/build --rm r:v1 bash

# Testing

    docker build -t r:v1 .
    docker run -i -t -v $PWD:/release --rm r:v1 bash

    # inside the container
    cd /release
    dpkg --install ccdg-r-3.3.1-1ubuntu14.04.deb
