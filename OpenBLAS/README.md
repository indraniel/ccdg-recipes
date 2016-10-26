# production mode

    docker build -t openblas:v1 .
    docker run -i -t -v $PWD:/release --rm openblas:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile, and then run:

    docker build -t openblas:v1 .
    docker run -i -t -v $PWD:/build --rm openblas:v1 bash

# Testing

    docker build -t openblas:v1 .
    docker run -i -t -v $PWD:/release --rm openblas:v1 bash

    # inside the container
    cd /release
    dpkg --install ccdg-openblas-0.2.19-1ubuntu14.04.deb
