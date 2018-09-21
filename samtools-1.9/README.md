# production mode

    docker build -t samtools-1.9:v1 .
    docker run -i -t -v $PWD:/release --rm samtools-1.9:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile, and then run:

    docker build -t samtools-1.9:v1 .
    docker run -i -t -v $PWD:/build --rm samtools-1.9:v1 bash

# Testing

    docker build -t samtools-1.9:v1 .
    docker run -i -t -v $PWD:/release --rm samtools-1.9:v1 bash

    # inside the container
    cd /release
    # manually install the prerequisites for the package
    dpkg --install hall-lab-samtools-1.9_1.9-1debian9.5.deb
