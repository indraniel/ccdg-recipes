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

VT_VERSION        := 2018.10.07.f6d2b5d
VT_GIT_COMMIT     := f6d2b5d
VT_GIT_URL        := https://github.com/atks/vt
VT_BUILD_DIR      := $(WORK_DIR)/vt
VT_INSTALL_DIR    := /opt/hall-lab/vt-$(VT_VERSION)
VT_BIN_DIR        := $(VT_INSTALL_DIR)/bin
VT_BIN            := $(VT_BIN_DIR)/vt

BUILD_DEPENDENCIES := /build/dependencies

DEB_BUILD_DIR       := $(WORK_DIR)/deb-build
DEBIAN_EDITION      := $(shell cat /etc/debian_version)
DEB_RELEASE_VERSION := 1debian$(DEBIAN_EDITION)
DEB_PKG             := hall-lab-vt-$(VT_VERSION)_$(VT_VERSION)-$(DEB_RELEASE_VERSION).deb
DEB_PKG_PATH        := $(RELEASE_DIR)/$(DEB_PKG)
DEB_BASE_INSTALL    := /opt/hall-lab/vt-$(VT_VERSION)

all: $(DEB_PKG_PATH)

# DEBIAN CONTROL FILE ##########################################################
define debian_control
Package: hall-lab-vt-$(VT_VERSION)
Architecture: amd64
Section: science
Maintainer: Indraniel Das <idas@wustl.edu>
Priority: optional
Depends: libc6, libstdc++6, bzip2, libbz2-1.0, liblzma5, libcurl3, libssl1.0.2
Description: vt for Hall Lab ( $(VT_VERSION) )
Version: $(VT_VERSION)-$(DEB_RELEASE_VERSION)
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

$(DEB_PKG_PATH): $(VT_BIN)
	# setup the directory
	$(TEST) -d $(DEB_BUILD_DIR) || $(MKDIR) $(DEB_BUILD_DIR)
	
	# setup the debian package meta information
	$(ECHO) "$$debian_postrm" > $(DEB_BUILD_DIR)/postrm
	$(ECHO) "$$debian_control" > $(DEB_BUILD_DIR)/control
	$(ECHO) 2.0 > $(DEB_BUILD_DIR)/debian-binary
	
	# create the "installed" file directory structure
	$(MKDIR) -p $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# install the compiled perl build directory
	$(CP) -rv $(VT_INSTALL_DIR)/* $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# create the underlying tars of the debian package
	$(TAR) cvzf $(DEB_BUILD_DIR)/data.tar.gz --owner=0 --group=0 -C $(DEB_BUILD_DIR) opt
	$(TAR) cvzf $(DEB_BUILD_DIR)/control.tar.gz -C $(DEB_BUILD_DIR) control postrm
	
	# assemble the formal "deb" package
	cd $(DEB_BUILD_DIR) && \
		$(AR) rc $(DEB_PKG) debian-binary control.tar.gz data.tar.gz && \
		$(MV) $(DEB_PKG) $(RELEASE_DIR)

$(VT_BIN): | $(BUILD_DEPENDENCIES)
	$(GIT) clone $(VT_GIT_URL)
	cd $(VT_BUILD_DIR) && \
		git checkout -b $(VT_GIT_COMMIT) $(VT_GIT_COMMIT) && \
		make && \
		mkdir -p $(VT_BIN_DIR) && \
		cp -v vt $(VT_BIN_DIR)

$(BUILD_DEPENDENCIES):
	$(APT_GET) update
	$(APT_GET) install -y build-essential
	$(APT_GET) install -y \
		git \
		bzip2 \
		libbz2-dev \
		liblzma-dev \
		libssl1.0-dev \
		libcurl4-openssl-dev \
		zlib1g-dev \
		libstdc++6 \
		curl
	$(TOUCH) $(BUILD_DEPENDENCIES)

# apt-get install gfortran libjpeg8 zip unzip libtiff5 libx11-6 libxt6 libcairo2 libpango1.0-0 libpangocairo-1.0-0 libcurl4-openssl-dev libxmu6
