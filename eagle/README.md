# production mode

    docker build -t eagle-2.4.1-build:v1 .
    docker run -i -t -v $PWD:/release --rm eagle-2.4.1-build:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile AND uncomment the VOLUME /build command, and then run:

    docker build -t eagle-2.4.1-build:v1 .
    docker run -i -t -v $PWD:/build --rm eagle-2.4.1-build:v1 bash

# Testing

    # comment out the apt-get install <pkg-list> in the Dockerfile
    docker build -t eagle-2.4.1-build:v1 .
    docker run -i -t -v $PWD:/release --rm eagle-2.4.1-build:v1 bash

    # inside the container
    apt-get -y install apt-transport-https
    echo "deb [trusted=yes] https://gitlab.com/indraniel/hall-lab-debian-repo-1/raw/master stretch main" | tee -a /etc/apt/sources.list
    apt-get update -qq
    cd /release
    # manually install the prerequisites for the package
    apt-get install libopenblas-base libgomp1 libcurl3 libboost-iostreams1.62.0 libboost-program-options1.62.0 libboost-random1.62.0 hall-lab-htslib-1.9
    # install the package itself
    dpkg --install hall-lab-eagle-2.4.1_2.4.1-1debian9.9.deb
