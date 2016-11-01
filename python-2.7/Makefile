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
AR      := /usr/bin/ar
TEST    := /usr/bin/test

# basic workspace directories
WORK_DIR         := /build
BASE_INSTALL_DIR := $(WORK_DIR)
RELEASE_DIR      := /release

PYTHON_VERSION      := 2.7.12
PYTHON_REPO         := https://github.com/yyuu/pyenv.git
PYTHON_BUILD_DIR    := /build/py-$(PYTHON_VERSION)
PYTHON_INSTALL_DIR  := /opt/ccdg/python-$(PYTHON_VERSION)
PYTHON_BIN          := $(PYTHON_INSTALL_DIR)/bin/python

BUILD_DEPENDENCIES := /build/dependencies

DEB_BUILD_DIR       := $(WORK_DIR)/deb-build
UBUNTU_EDITION      := $(shell . /etc/lsb-release; echo $$DISTRIB_RELEASE)
DEB_RELEASE_VERSION := 1ubuntu$(UBUNTU_EDITION)
DEB_PKG             := ccdg-python-$(PYTHON_VERSION)_$(PYTHON_VERSION)-$(DEB_RELEASE_VERSION).deb
DEB_PKG_PATH        := $(RELEASE_DIR)/$(DEB_PKG)
DEB_BASE_INSTALL    := /opt/ccdg/python-$(PYTHON_VERSION)

all: $(DEB_PKG_PATH)

# DEBIAN CONTROL FILE ##########################################################
define debian_control
Package: ccdg-python-$(PYTHON_VERSION)
Architecture: amd64
Section: science
Maintainer: Indraniel Das <idas@wustl.edu>
Priority: optional
Depends: make, libncursesw5, libreadline6, libssl1.0.0, libdb5.3, libc6, libsqlite3-0, sqlite3, libbz2-1.0, zlib1g
Description: python2.7 for MGI's CCDG pipeline ( $(PYTHON_VERSION) )
Version: $(PYTHON_VERSION)-$(DEB_RELEASE_VERSION)
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

$(DEB_PKG_PATH): $(PYTHON_BIN)
	# setup the directory
	$(TEST) -d $(DEB_BUILD_DIR) || $(MKDIR) $(DEB_BUILD_DIR)
	
	# setup the debian package meta information
	$(ECHO) "$$debian_postrm" > $(DEB_BUILD_DIR)/postrm
	$(ECHO) "$$debian_control" > $(DEB_BUILD_DIR)/control
	$(ECHO) 2.0 > $(DEB_BUILD_DIR)/debian-binary
	
	# create the "installed" file directory structure
	$(MKDIR) -p $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# install the compiled R build directory
	$(CP) -rv $(PYTHON_INSTALL_DIR)/* $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# create the underlying tars of the debian package
	$(TAR) cvzf $(DEB_BUILD_DIR)/data.tar.gz --owner=0 --group=0 -C $(DEB_BUILD_DIR) opt
	$(TAR) cvzf $(DEB_BUILD_DIR)/control.tar.gz -C $(DEB_BUILD_DIR) control postrm
	
	# assemble the formal "deb" package
	cd $(DEB_BUILD_DIR) && \
		$(AR) rc $(DEB_PKG) debian-binary control.tar.gz data.tar.gz && \
		$(MV) $(DEB_PKG) $(RELEASE_DIR)

$(PYTHON_BIN): | $(BUILD_DEPENDENCIES) $(PYTHON_BUILD_DIR) 
	PYTHON_CONFIGURE_OPTS="--enable-shared" $(PYTHON_BUILD_DIR)/bin/python-build \
						  --verbose $(PYTHON_VERSION) $(PYTHON_INSTALL_DIR)
	$(PYTHON_BUILD_DIR)/bin/python-build \
		--verbose $(PYTHON_VERSION) $(PYTHON_INSTALL_DIR)
	$(PYTHON_INSTALL_DIR)/bin/pip install --upgrade pip
	$(PYTHON_INSTALL_DIR)/bin/pip install --upgrade virtualenv

$(PYTHON_BUILD_DIR): 
	cd /build && git clone $(PYTHON_REPO)
	cd /build/pyenv/plugins/python-build && \
		PREFIX=$(PYTHON_BUILD_DIR) bash -x install.sh

$(BUILD_DEPENDENCIES):
	$(APT_GET) update
	$(APT_GET) install -y build-essential
	$(APT_GET) install -y \
		libncursesw5-dev \
		libreadline6-dev \
		libssl-dev \
		libdb-dev \
		libc6-dev \
		libsqlite3-dev \
		libbz2-dev \
		zlib1g-dev \
		liblzma-dev
	$(TOUCH) $(BUILD_DEPENDENCIES)

# apt-get install gfortran libjpeg8 zip unzip libtiff5 libx11-6 libxt6 libcairo2 libpango1.0-0 libpangocairo-1.0-0 libcurl4-openssl-dev libxmu6
