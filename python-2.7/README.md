# Production mode

    docker build -t python:v1 .
    docker run -i -t -v $PWD:/release --rm python:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile, and then run:

    docker build -t python:v1 .
    docker run -i -t -v $PWD:/build --rm python:v1 bash

# Testing

    docker build -t python:v1 .
    docker run -i -t -v $PWD:/release --rm python:v1 bash

    # inside the container
    cd /release
    # manually install the prerequisites for the package
    apt-get instsall make libncursesw5 libreadline7 libssl1.1 libdb5.3 libc6 libsqlite3-0 sqlite3 libbz2-1.0 zlib1g
    dpkg --install hall-lab-python-2.7.15-1debian9.5.deb
