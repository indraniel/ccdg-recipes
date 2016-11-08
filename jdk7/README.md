# production mode

    docker build -t jdk7:v1 .
    docker run -i -t -v $PWD:/release --rm jdk7:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile, and then run:

    docker build -t jdk7:v1 .
    docker run -i -t -v $PWD:/build --rm jdk7:v1 bash

# Testing

    docker build -t jdk7:v1 .
    docker run -i -t -v $PWD:/release --rm jdk7:v1 bash

    # inside the container
    cd /release
    dpkg --install ccdg-oracle-jdk-7u79_7u79-1ubuntu14.04.deb
