# production mode

    docker build -t htslib-1.9:v1 .
    docker run -i -t -v $PWD:/release --rm htslib-1.9:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile, and then run:

    docker build -t htslib-1.9:v1 .
    docker run -i -t -v $PWD:/build --rm htslib-1.9:v1 bash

# Testing

    docker build -t htslib-1.9:v1 .
    docker run -i -t -v $PWD:/release --rm htslib-1.9:v1 bash

    # inside the container
    cd /release
    # manually install the prerequisites for the package
    dpkg --install hall-lab-htslib-1.9_1.9-1debian9.5.deb
