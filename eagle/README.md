# production mode

    docker build -t eagle-2.4.1-build:v1 .
    docker run -i -t -v $PWD:/release --rm eagle-2.4.1-build:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile AND uncomment the VOLUME /build command, and then run:

    docker build -t eagle-2.4.1-build:v1 .
    docker run -i -t -v $PWD:/build --rm eagle-2.4.1-build:v1 bash

# Testing

    docker build -t eagle-2.4.1-build:v1 .
    docker run -i -t -v $PWD:/release --rm eagle-2.4.1-build:v1 bash

    # inside the container
    apt-get -y install apt-transport-https
    echo "deb [trusted=yes] https://gitlab.com/indraniel/hall-lab-debian-repo-1/raw/master stretch main" | tee -a /etc/apt/sources.list
    apt-get update -qq
    cd /release
    # manually install the prerequisites for the package
    dpkg --install hall-lab-eagle-2.4.1_2.4.1-1debian9.9.deb
