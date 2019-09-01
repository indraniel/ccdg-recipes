# production mode

    docker build -t rfmix-2.03r0-build:v1 .
    docker run -i -t -v $PWD:/release --rm rfmix-2.03r0-build:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile AND uncomment the VOLUME /build command, and then run:

    docker build -t rfmix-2.03r0-build:v1 .
    docker run -i -t -v $PWD:/build --rm rfmix-2.03r0-build:v1 bash

# Testing

    docker build -t rfmix-2.03-r0-build:v1 .
    docker run -i -t -v $PWD:/release --rm rfmix-2.03r0-build:v1 bash

    # inside the container
    cd /release
    # manually install the prerequisites for the package
    dpkg --install hall-lab-rfmix-2.03r0_2.03r0-1debian9.9.deb
