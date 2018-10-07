# production mode

    docker build -t r:v1 .
    docker run -i -t -v $PWD:/release --rm r:v1

# Development Mode

comment out the "COPY" commands in the Dockerfile, and then run:

    docker build -t r:v1 .
    docker run -i -t -v $PWD:/build --rm r:v1 bash

# Testing

    docker build -t r:v1 .
    docker run -i -t -v $PWD:/release --rm r:v1 bash

    # inside the container
    cd /release
    # manually install the prerequisites for the package
    apt-get install intel-mkl-core-rt-2019.0-117 intel-mkl-gnu-rt-2019.0-117 intel-mkl-gnu-f-rt-2019.0-117 intel-mkl-common-2019.0-117 intel-mkl-common-c-2019.0-117 intel-mkl-common-f-2019.0-117 build-essential g++ gfortran libncurses5 libreadline7 libjpeg62-turbo libpcre3 libpng16-16 zlib1g zip unzip libbz2-1.0 libc6 libgomp1 liblzma5 libtiff5 libx11-6 libxt6 libxmu6 libcairo2 libpango1.0-0 libpangocairo-1.0-0 libcurl3 libcurl4-openssl-dev curl

    dpkg --install hall-lab-r-3.5.1_3.5.1-1debian9.5.deb
