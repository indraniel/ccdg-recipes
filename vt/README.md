# Production mode

    docker build -t vt:v1 .
    docker run -i -t -v $PWD:/release --rm vt:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile, and then run:

    docker build -t vt:v1 .
    docker run -i -t -v $PWD:/build --rm vt:v1 bash

# Testing

    docker build -t vt:v1 .
    docker run -i -t -v $PWD:/release --rm vt:v1 bash

    # inside the container
    cd /release
    # manually install the prerequisites for the package
    apt-get install libc6 libstdc++6 bzip2 libbz2-1.0 liblzma5 libcurl3 libssl1.0.2
    dpkg --install hall-lab-vt-f6d2b5d_f6d2b5d-1debian9.5.deb
