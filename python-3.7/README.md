# Production mode

    docker build -t python-3.7:v1 .
    docker run -i -t -v $PWD:/release --rm python-3.7:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile, and then run:

    docker build -t python-3.7:v1 .
    docker run -i -t -v $PWD:/build --rm python-3.7:v1 bash

# Testing

    docker build -t python-3.7:v1 .
    docker run -i -t -v $PWD:/release --rm python-3.7:v1 bash

    # inside the container
    cd /release
    # manually install the prerequisites for the package
    apt-get install make libncursesw5 libreadline7 libssl1.1 libdb5.3 libc6 libsqlite3-0 sqlite3 libbz2-1.0 zlib1g libffi6 libffi-dev
    dpkg --install hall-lab-python-3.7.0_3.7.0-1debian9.5.deb
