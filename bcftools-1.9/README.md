# production mode

    docker build -t bcftools-1.9-build:v1 .
    docker run -i -t -v $PWD:/release --rm bcftools-1.9-build:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile AND uncomment the VOLUME /build command, and then run:

    docker build -t bcftools-1.9-build:v1 .
    docker run -i -t -v $PWD:/build --rm bcftools-1.9-build:v1 bash

# Testing

    docker build -t bcftools-1.9-build:v1 .
    docker run -i -t -v $PWD:/release --rm bcftools-1.9-build:v1 bash

    # inside the container
    cd /release
    # manually install the prerequisites for the package
    dpkg --install hall-lab-bcftools-1.9_1.9-1debian9.5.deb
