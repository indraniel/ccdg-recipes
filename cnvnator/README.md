# production mode

    docker build -t cnvnator-0.3.3:v1 .
    docker run -i -t -v $PWD:/release --rm cnvnator-0.3.3:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile, and then run:

    docker build -t cnvnator-0.3.3:v1 .
    docker run -i -t -v $PWD:/build --rm cnvnator-0.3.3:v1 bash

# Testing

    docker build -t cnvnator-0.3.3:v1 .
    docker run -i -t -v $PWD:/release --rm cnvnator-0.3.3:v1 bash

    # inside the container
    cd /release
    # manually install the prerequisites for the package
    apt-get install libc6 libc6-dev zlib1g libgomp1 libstdc++6 libstdc++-4.8-dev libgcc1 g++ libxpm4 ccdg-python-2.7.12
    dpkg --install ccdg-cnvnator-0.3.3_0.3.3-1ubuntu14.04.deb
