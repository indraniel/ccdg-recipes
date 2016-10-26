.PHONY: clean debian debclean

# external commands used
CURL  := /usr/bin/curl
UNZIP := /usr/bin/unzip
TAR   := /bin/tar
CP    := /bin/cp
RM    := /bin/rm
MV    := /bin/mv
MKDIR := /bin/mkdir
ECHO  := /bin/echo
CHMOD := /bin/chmod
AR    := /usr/bin/ar
TEST  := /usr/bin/test

# basic workspace directories
WORK_DIR         := /build
BASE_INSTALL_DIR := $(WORK_DIR)
RESOURCES_DIR    := $(WORK_DIR)/resources
RELEASE_DIR      := /release

# source code information
PICARD_VERSION    := 2.4.1
PICARD_URL        := https://github.com/broadinstitute/picard/releases/download/$(PICARD_VERSION)/picard-tools-2.4.1.zip
PICARD_ZIP        := $(RESOURCES_DIR)/picard-tools-2.4.1.zip
PICARD_OUTPUT_DIR := $(WORK_DIR)/picard-tools-2.4.1
PICARD            := $(PICARD_OUTPUT_DIR)/picard.jar

# debian packaging related variables
DEB_BUILD_DIR       := $(WORK_DIR)/deb-build
UBUNTU_EDITION      := $(shell . /etc/lsb-release; $(ECHO) $$DISTRIB_RELEASE)
DEB_RELEASE_VERSION := 1ubuntu$(UBUNTU_EDITION)
DEB_PKG             := ccdg-picard-$(PICARD_VERSION)_$(PICARD_VERSION)-$(DEB_RELEASE_VERSION).deb
DEB_PKG_PATH        := $(RELEASE_DIR)/$(DEB_PKG)
DEB_BASE_INSTALL    := /opt/ccdg/picard-$(PICARD_VERSION)

# DEBIAN CONTROL FILE ##########################################################
define debian_control
Package: ccdg-picard-$(PICARD_VERSION)
Architecture: amd64
Section: science
Maintainer: Indraniel Das <idas@wustl.edu>
Priority: optional
Depends: ccdg-oracle-jdk-8u111, ccdg-r-3.3.1
Description: Broad's picard for the CCDG pipeline ( $(PICARD_VERSION) )
Version: $(PICARD_VERSION)-$(DEB_RELEASE_VERSION)
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

all: debian

debian: | $(PICARD)
	# setup the directory
	$(TEST) -d $(DEB_BUILD_DIR) || $(MKDIR) $(DEB_BUILD_DIR)
	
	# setup the debian package meta information
	$(ECHO) "$$debian_postrm" > $(DEB_BUILD_DIR)/postrm
	$(ECHO) "$$debian_control" > $(DEB_BUILD_DIR)/control
	$(ECHO) 2.0 > $(DEB_BUILD_DIR)/debian-binary
	
	# create the "installed" file directory structure
	$(MKDIR) -p $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# install the untarred file for jdk
	$(CP) -rv $(PICARD_OUTPUT_DIR)/* $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# create the underlying tars of the debian package
	$(TAR) cvzf $(DEB_BUILD_DIR)/data.tar.gz --owner=0 --group=0 -C $(DEB_BUILD_DIR) opt
	$(TAR) cvzf $(DEB_BUILD_DIR)/control.tar.gz -C $(DEB_BUILD_DIR) control postrm
	
	# assemble the formal "deb" package
	cd $(DEB_BUILD_DIR) && \
		$(AR) rc $(DEB_PKG) debian-binary control.tar.gz data.tar.gz && \
		$(MV) $(DEB_PKG) $(RELEASE_DIR)

$(PICARD): $(PICARD_ZIP)
	$(UNZIP) $(PICARD_ZIP)

$(PICARD_ZIP):
	mkdir -p $(RESOURCES_DIR)
	cd $(RESOURCES_DIR) && \
		$(CURL) -L -O $(PICARD_URL)

debclean:
	if [ -e $(DEB_BUILD_DIR) ]; then $(RM) -rf $(DEB_BUILD_DIR); fi
	if [ -e $(DEB_PKG_PATH) ]; then $(RM) -rf $(DEB_PKG_PATH); fi

clean:
	if [ -e $(PICARD_OUTPUT_DIR) ]; then $(RM) -rf $(PICARD_OUTPUT_DIR); fi
	if [ -e $(DEB_BUILD_DIR) ]; then $(RM) -rf $(DEB_BUILD_DIR); fi
	if [ -e $(DEB_PKG_PATH) ]; then $(RM) -rf $(DEB_PKG_PATH); fi
