# production mode

    docker build -t cnvnator-multi:v1 .
    docker run -i -t -v $PWD:/release --rm cnvnator-multi:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile, and then run:

    docker build -t cnvnator-multi:v1 .
    docker run -i -t -v $PWD:/build --rm cnvnator-multi:v1 bash

# Testing

    docker build -t cnvnator-multi:v1 .
    docker run -i -t -v $PWD:/release --rm cnvnator-multi:v1 bash

    # inside the container
    cd /release
    # manually install the prerequisites for the package
    apt-get install libc6 zlib1g libstdc++6 libgcc1 libxpm4 ccdg-python-2.7.12
    dpkg --install cnvnator-multi_multi-1ubuntu14.04.deb
