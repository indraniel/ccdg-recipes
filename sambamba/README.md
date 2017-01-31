# production mode

    docker build -t sambamba:v1 .
    docker run -i -t -v $PWD:/release --rm sambamba:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile, and then run:

    docker build -t sambamba:v1 .
    docker run -i -t -v $PWD:/build --rm sambamba:v1 bash

# Testing

    docker build -t sambamba:v1 .
    docker run -i -t -v $PWD:/release --rm sambamba:v1 bash

    # inside the container
    cd /release
    # manually install the prerequisites for the package
    dpkg --install ccdg-sambamba-0.6.5_0.6.5-1ubuntu14.04.deb
