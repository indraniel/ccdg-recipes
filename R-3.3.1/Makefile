.PHONY: clean debian

# external commands used
APT_GET := /usr/bin/apt-get
TOUCH   := /usr/bin/touch
GIT     := /usr/bin/git
CURL    := /usr/bin/curl
TAR     := /bin/tar
CP      := /bin/cp
RM      := /bin/rm
MV      := /bin/mv
LN      := /bin/ln
MKDIR   := /bin/mkdir
ECHO    := /bin/echo
CHMOD   := /bin/chmod
AR      := /usr/bin/ar
TEST    := /usr/bin/test

# basic workspace directories
WORK_DIR         := /build
BASE_INSTALL_DIR := $(WORK_DIR)
RELEASE_DIR      := /release

R_VERSION      := 3.3.1
R_INSTALL_DIR  := /opt/ccdg/R-$(R_VERSION)
R_BIN          := $(R_INSTALL_DIR)/bin/R
R_SRC_TAR      := R-$(R_VERSION).tar.gz
R_URL          := http://cran.wustl.edu/src/base/R-3/$(R_SRC_TAR)
R_BUILD_TAR    := /build/$(R_SRC_TAR)
R_BUILD_DIR    := /build/R-$(R_VERSION)

OPENBLAS_VERSION := 0.2.19
OPENBLAS_DIR     := /opt/ccdg/OpenBLAS-$(OPENBLAS_VERSION)

BUILD_DEPENDENCIES := /build/dependencies

DEB_BUILD_DIR       := $(WORK_DIR)/deb-build
UBUNTU_EDITION      := $(shell . /etc/lsb-release; echo $$DISTRIB_RELEASE)
DEB_RELEASE_VERSION := 1ubuntu$(UBUNTU_EDITION)
DEB_PKG             := ccdg-r-$(R_VERSION)_$(R_VERSION)-$(DEB_RELEASE_VERSION).deb
DEB_PKG_PATH        := $(RELEASE_DIR)/$(DEB_PKG)
DEB_BASE_INSTALL    := /opt/ccdg/R-$(R_VERSION)

all: $(DEB_PKG_PATH)

# DEBIAN CONTROL FILE ##########################################################
define debian_control
Package: ccdg-r-$(R_VERSION)
Architecture: amd64
Section: science
Maintainer: Indraniel Das <idas@wustl.edu>
Priority: optional
Depends: build-essential, g++, gfortran, libncurses5, libreadline6, libjpeg8, libpcre3, libpng12-0, zlib1g, zip, unzip, libbz2-1.0, libc6, libgomp1, liblzma5, libtiff5, libx11-6, libxt6, libxmu6, libcairo2, libpango1.0-0, libpangocairo-1.0-0, libcurl3, libcurl4-openssl-dev, curl, ccdg-openblas-0.2.19
Description: R for MGI's CCDG pipeline ( $(R_VERSION) )
Version: $(R_VERSION)-$(DEB_RELEASE_VERSION)
endef
export debian_control

# DEBIAN POSTRM FILE ###########################################################
define debian_postrm
#!/bin/bash

BASE=$(DEB_BASE_INSTALL)

if [ -e $${BASE} ]; then
    $(RM) -rfv $${BASE}
fi
endef
export debian_postrm

all: $(DEB_PKG_PATH)

$(DEB_PKG_PATH): $(R_BIN)
	# setup the directory
	$(TEST) -d $(DEB_BUILD_DIR) || $(MKDIR) $(DEB_BUILD_DIR)
	
	# setup the debian package meta information
	$(ECHO) "$$debian_postrm" > $(DEB_BUILD_DIR)/postrm
	$(ECHO) "$$debian_control" > $(DEB_BUILD_DIR)/control
	$(ECHO) 2.0 > $(DEB_BUILD_DIR)/debian-binary
	
	# create the "installed" file directory structure
	$(MKDIR) -p $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# install the compiled R build directory
	$(CP) -rv $(R_INSTALL_DIR)/* $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# create the underlying tars of the debian package
	$(TAR) cvzf $(DEB_BUILD_DIR)/data.tar.gz --owner=0 --group=0 -C $(DEB_BUILD_DIR) opt
	$(TAR) cvzf $(DEB_BUILD_DIR)/control.tar.gz -C $(DEB_BUILD_DIR) control postrm
	
	# assemble the formal "deb" package
	cd $(DEB_BUILD_DIR) && \
		$(AR) rc $(DEB_PKG) debian-binary control.tar.gz data.tar.gz && \
		$(MV) $(DEB_PKG) $(RELEASE_DIR)

$(R_BIN): export BLAS_LIBS := -L $(OPENBLAS_DIR)/lib
$(R_BIN): export LAPACK_LIBS := -L $(OPENBLAS_DIR)/lib
$(R_BIN): export LDFLAGS := -L $(OPENBLAS_DIR)/lib -L /usr/lib/x86_64-linux-gnu
$(R_BIN): export CFLAGS := -I $(OPENBLAS_DIR)/include
$(R_BIN): | $(BUILD_DEPENDENCIES) $(R_BUILD_DIR) 
	cd $(R_BUILD_DIR) && \
		./configure --prefix=$(R_INSTALL_DIR) \
					--x-includes=/usr/include/X11 \
					--x-libraries=/usr/lib/x86_64-linux-gnu \
					--enable-R-shlib \
					--disable-java \
					--enable-openmp \
					--enable-largefile \
					--with-blas \
					--with-lapack \
					--enable-BLAS-shlib \
					--without-tcltk \
					--with-cairo \
					--with-libpng \
					--with-libtiff \
					--with-recommended-packages \
					--with-gnu-ld \
					--with-x
	cd $(R_BUILD_DIR) && make
	cd $(R_BUILD_DIR) && make check
	cd $(R_BUILD_DIR) && make install
	$(MV) $(R_INSTALL_DIR)/lib/R/lib/libRblas.so $(R_INSTALL_DIR)/lib/R/lib/libRblas.so.orig
	$(LN) -s $(OPENBLAS_DIR)/lib/libopenblas.so $(R_INSTALL_DIR)/lib/R/lib/libRblas.so

$(R_BUILD_DIR): $(R_BUILD_TAR)
	cd /build && $(TAR) zxvf $(R_SRC_TAR)

$(R_BUILD_TAR):
	cd /build && $(CURL) -O $(R_URL)

$(BUILD_DEPENDENCIES):
	$(APT_GET) update
	$(APT_GET) install -y build-essential
	$(APT_GET) install -y gcc
	$(APT_GET) install -y g++
	$(APT_GET) install -y gfortran
	$(APT_GET) install -y libncurses5-dev
	$(APT_GET) install -y libncurses5
	$(APT_GET) install -y libreadline-dev
	$(APT_GET) install -y libreadline6
	$(APT_GET) install -y libjpeg-dev
	$(APT_GET) install -y libpcre3-dev
	$(APT_GET) install -y libpcre3
	$(APT_GET) install -y libpng-dev
	$(APT_GET) install -y zlib1g-dev
	$(APT_GET) install -y zlib1g
	$(APT_GET) install -y zip
	$(APT_GET) install -y unzip
	$(APT_GET) install -y libbz2-1.0
	$(APT_GET) install -y libbz2-dev
	$(APT_GET) install -y libc6
	$(APT_GET) install -y libgfortran3
	$(APT_GET) install -y libgomp1
	$(APT_GET) install -y libjpeg8
	$(APT_GET) install -y liblzma-dev
	$(APT_GET) install -y liblzma5
	$(APT_GET) install -y libpng12-0
	$(APT_GET) install -y libreadline6
	$(APT_GET) install -y libtiff5-dev
	$(APT_GET) install -y libx11-6
	$(APT_GET) install -y libx11-dev
	$(APT_GET) install -y libxt6
	$(APT_GET) install -y libcairo2
	$(APT_GET) install -y libcairo2-dev
	$(APT_GET) install -y libpango1.0-dev
	$(APT_GET) install -y xorg-dev
	$(APT_GET) install -y libcurl3
	$(APT_GET) install -y libcurl4-openssl-dev
	$(APT_GET) install -y curl
	$(APT_GET) install -y ca-certificates
	$(APT_GET) install -y ccdg-openblas-0.2.19
	$(TOUCH) $(BUILD_DEPENDENCIES)

# apt-get install gfortran libjpeg8 zip unzip libtiff5 libx11-6 libxt6 libcairo2 libpango1.0-0 libpangocairo-1.0-0 libcurl4-openssl-dev libxmu6
