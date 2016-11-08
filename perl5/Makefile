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
BPERL   := /usr/bin/perl

# basic workspace directories
WORK_DIR         := /build
BASE_INSTALL_DIR := $(WORK_DIR)
RELEASE_DIR      := /release

PERL_VERSION      := 5.24.0
PERL_BUILDER      := https://raw.githubusercontent.com/tokuhirom/Perl-Build/master/perl-build
PERL_INSTALL_DIR  := /opt/ccdg/perl-$(PERL_VERSION)
PERL_BIN          := $(PERL_INSTALL_DIR)/bin/perl

BUILD_DEPENDENCIES := /build/dependencies

DEB_BUILD_DIR       := $(WORK_DIR)/deb-build
UBUNTU_EDITION      := $(shell . /etc/lsb-release; echo $$DISTRIB_RELEASE)
DEB_RELEASE_VERSION := 1ubuntu$(UBUNTU_EDITION)
DEB_PKG             := ccdg-perl-$(PERL_VERSION)_$(PERL_VERSION)-$(DEB_RELEASE_VERSION).deb
DEB_PKG_PATH        := $(RELEASE_DIR)/$(DEB_PKG)
DEB_BASE_INSTALL    := /opt/ccdg/perl-$(PERL_VERSION)

all: $(DEB_PKG_PATH)

# DEBIAN CONTROL FILE ##########################################################
define debian_control
Package: ccdg-perl-$(PERL_VERSION)
Architecture: amd64
Section: science
Maintainer: Indraniel Das <idas@wustl.edu>
Priority: optional
Depends: make, libc6
Description: perl for MGI's CCDG pipeline ( $(PERL_VERSION) )
Version: $(PERL_VERSION)-$(DEB_RELEASE_VERSION)
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

$(DEB_PKG_PATH): $(PERL_BIN)
	# setup the directory
	$(TEST) -d $(DEB_BUILD_DIR) || $(MKDIR) $(DEB_BUILD_DIR)
	
	# setup the debian package meta information
	$(ECHO) "$$debian_postrm" > $(DEB_BUILD_DIR)/postrm
	$(ECHO) "$$debian_control" > $(DEB_BUILD_DIR)/control
	$(ECHO) 2.0 > $(DEB_BUILD_DIR)/debian-binary
	
	# create the "installed" file directory structure
	$(MKDIR) -p $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# install the compiled perl build directory
	$(CP) -rv $(PERL_INSTALL_DIR)/* $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# create the underlying tars of the debian package
	$(TAR) cvzf $(DEB_BUILD_DIR)/data.tar.gz --owner=0 --group=0 -C $(DEB_BUILD_DIR) opt
	$(TAR) cvzf $(DEB_BUILD_DIR)/control.tar.gz -C $(DEB_BUILD_DIR) control postrm
	
	# assemble the formal "deb" package
	cd $(DEB_BUILD_DIR) && \
		$(AR) rc $(DEB_PKG) debian-binary control.tar.gz data.tar.gz && \
		$(MV) $(DEB_PKG) $(RELEASE_DIR)

$(PERL_BIN): | $(BUILD_DEPENDENCIES)
	$(CURL) $(PERL_BUILDER) | \
		$(BPERL) - $(PERL_VERSION) $(PERL_INSTALL_DIR)

$(BUILD_DEPENDENCIES):
	$(APT_GET) update
	$(APT_GET) install -y build-essential
	$(APT_GET) install -y \
		libc6-dev
	$(TOUCH) $(BUILD_DEPENDENCIES)

# apt-get install gfortran libjpeg8 zip unzip libtiff5 libx11-6 libxt6 libcairo2 libpango1.0-0 libpangocairo-1.0-0 libcurl4-openssl-dev libxmu6
