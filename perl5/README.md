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
    apt-get install make libc6 libssl1.1
    dpkg --install hall-lab-perl-5.28.0_5.28.0-1debian9.5.deb
