# production mode

    docker build -t htslib-1.9-build:v1 .
    docker run -i -t -v $PWD:/release --rm htslib-1.9-build:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile AND uncomment the VOLUME /build command, and then run:

    docker build -t htslib-1.9-build:v1 .
    docker run -i -t -v $PWD:/build --rm htslib-1.9-build:v1 bash

# Testing

    docker build -t htslib-1.9-build:v1 .
    docker run -i -t -v $PWD:/release --rm htslib-1.9-build:v1 bash

    # inside the container
    cd /release
    # manually install the prerequisites for the package
    apt-get install libc6 libcurl3 zlib1g ca-certificates libbz2-1.0 liblzma5 libssl1.0.2
    # actually install the pacakge of interest
    dpkg --install hall-lab-htslib-1.9_1.9-1debian9.5.deb
