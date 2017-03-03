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
    dpkg --install extract-sv-reads1.1-1.1.0-Linux-x86_64.deb
