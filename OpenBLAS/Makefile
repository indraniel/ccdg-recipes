.PHONY: clean debian

# external commands used
APT_GET := /usr/bin/apt-get
TOUCH   := /usr/bin/touch
GIT     := /usr/bin/git
TAR     := /bin/tar
CP      := /bin/cp
RM      := /bin/rm
MV      := /bin/mv
MKDIR   := /bin/mkdir
ECHO    := /bin/echo
CHMOD   := /bin/chmod
AR      := /usr/bin/ar
TEST    := /usr/bin/test

# basic workspace directories
WORK_DIR         := /build
BASE_INSTALL_DIR := $(WORK_DIR)
RELEASE_DIR      := /release

OPENBLAS_REPO        := https://github.com/xianyi/OpenBLAS
OPENBLAS_TAG         := v0.2.19
OPENBLAS_VERSION     := 0.2.19
OPENBLAS_BUILD_DIR   := /build/OpenBLAS
OPENBLAS_INSTALL_DIR := /build/stage/OpenBLAS-$(OPENBLAS_TAG)
OPENBLAS             := $(OPENBLAS_INSTALL_DIR)/lib/libopenblas.a

BUILD_DEPENDENCIES := /build/dependencies

DEB_BUILD_DIR       := $(BASE_DIR)/deb-build
UBUNTU_EDITION      := $(shell . /etc/lsb-release; echo $$DISTRIB_RELEASE)
DEB_RELEASE_VERSION := 1ubuntu$(UBUNTU_EDITION)
DEB_PKG             := ccdg-openblas-$(OPENBLAS_VERSION)_$(OPENBLAS_VERSION)-$(DEB_RELEASE_VERSION).deb
DEB_PKG_PATH        := $(RELEASE_DIR)/$(DEB_PKG)
DEB_BASE_INSTALL    := /opt/ccdg/OpenBLAS-$(OPENBLAS_VERSION)

# DEBIAN CONTROL FILE ##########################################################
define debian_control
Package: ccdg-openblas-$(OPENBLAS_VERSION)
Architecture: amd64
Section: science
Maintainer: Indraniel Das <idas@wustl.edu>
Priority: optional
Description: OpenBLAS for MGI's CCDG pipeline ( $(OPENBLAS_TAG) )
Version: $(OPENBLAS_VERSION)-$(DEB_RELEASE_VERSION)
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

$(DEB_PKG_PATH): $(OPENBLAS)
	# setup the directory
	$(TEST) -d $(DEB_BUILD_DIR) || $(MKDIR) $(DEB_BUILD_DIR)
	
	# setup the debian package meta information
	$(ECHO) "$$debian_postrm" > $(DEB_BUILD_DIR)/postrm
	$(ECHO) "$$debian_control" > $(DEB_BUILD_DIR)/control
	$(ECHO) 2.0 > $(DEB_BUILD_DIR)/debian-binary
	
	# create the "installed" file directory structure
	$(MKDIR) -p $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# install the compiled OpenBLAS libraries and include
	$(CP) -rv $(OPENBLAS_INSTALL_DIR)/include $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	$(CP) -rv $(OPENBLAS_INSTALL_DIR)/lib $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# create the underlying tars of the debian package
	$(TAR) cvzf $(DEB_BUILD_DIR)/data.tar.gz --owner=0 --group=0 -C $(DEB_BUILD_DIR) opt
	$(TAR) cvzf $(DEB_BUILD_DIR)/control.tar.gz -C $(DEB_BUILD_DIR) control postrm
	
	# assemble the formal "deb" package
	cd $(DEB_BUILD_DIR) && \
		$(AR) rc $(DEB_PKG) debian-binary control.tar.gz data.tar.gz && \
		$(MV) $(DEB_PKG) $(RELEASE_DIR)

$(OPENBLAS): | $(BUILD_DEPENDENCIES) $(OPENBLAS_BUILD_DIR)
	cd $(OPENBLAS_BUILD_DIR) && make && make PREFIX=$(OPENBLAS_INSTALL_DIR) install

$(OPENBLAS_BUILD_DIR):
	cd /build && $(GIT) clone $(OPENBLAS_REPO) && \
		cd OpenBLAS && $(GIT) checkout -b $(OPENBLAS_TAG) $(OPENBLAS_TAG)

$(BUILD_DEPENDENCIES):
	$(APT_GET) update
	$(APT_GET) install -y build-essential
	$(APT_GET) install -y gcc
	$(APT_GET) install -y gfortran
	$(APT_GET) install -y ca-certificates
	$(TOUCH) $(BUILD_DEPENDENCIES)
