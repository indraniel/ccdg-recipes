.PHONY: clean debian debclean

# external commands used
CURL  := /usr/bin/curl
UNZIP := /usr/bin/unzip
BZIP  := /bin/bzip2
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
SAMBAMBA_VERSION    := 0.6.5
SAMBAMBA_BIN_NAME   := sambamba_v$(SAMBAMBA_VERSION)
SAMBAMBA_FILE       := $(SAMBAMBA_BIN_NAME)_linux.tar.bz2
SAMBAMBA_URL        := https://github.com/lomereiter/sambamba/releases/download/v$(SAMBAMBA_VERSION)/$(SAMBAMBA_FILE)
SAMBAMBA_ZIP        := $(RESOURCES_DIR)/$(SAMBAMBA_FILE)
SAMBAMBA            := $(RESOURCES_DIR)/$(SAMBAMBA_BIN_NAME)

# debian packaging related variables
DEB_BUILD_DIR       := $(WORK_DIR)/deb-build
UBUNTU_EDITION      := $(shell . /etc/lsb-release; $(ECHO) $$DISTRIB_RELEASE)
DEB_RELEASE_VERSION := 1ubuntu$(UBUNTU_EDITION)
DEB_PKG             := ccdg-sambamba-$(SAMBAMBA_VERSION)_$(SAMBAMBA_VERSION)-$(DEB_RELEASE_VERSION).deb
DEB_PKG_PATH        := $(RELEASE_DIR)/$(DEB_PKG)
DEB_BASE_INSTALL    := /opt/ccdg/sambamba-$(SAMBAMBA_VERSION)

# DEBIAN CONTROL FILE ##########################################################
define debian_control
Package: ccdg-sambamba-$(SAMBAMBA_VERSION)
Architecture: amd64
Section: science
Maintainer: Indraniel Das <idas@wustl.edu>
Priority: optional
Description: Sambamba for CCDG pipeline ( $(SAMBAMBA_VERSION) )
Version: $(SAMBAMBA_VERSION)-$(DEB_RELEASE_VERSION)
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

debian: | $(SAMBAMBA)
	# setup the directory
	$(TEST) -d $(DEB_BUILD_DIR) || $(MKDIR) $(DEB_BUILD_DIR)
	
	# setup the debian package meta information
	$(ECHO) "$$debian_postrm" > $(DEB_BUILD_DIR)/postrm
	$(ECHO) "$$debian_control" > $(DEB_BUILD_DIR)/control
	$(ECHO) 2.0 > $(DEB_BUILD_DIR)/debian-binary
	
	# create the "installed" file directory structure
	$(MKDIR) -p $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# install the untarred file for jdk
	$(CP) -rv $(SAMBAMBA) $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# create the underlying tars of the debian package
	$(TAR) cvzf $(DEB_BUILD_DIR)/data.tar.gz --owner=0 --group=0 -C $(DEB_BUILD_DIR) opt
	$(TAR) cvzf $(DEB_BUILD_DIR)/control.tar.gz -C $(DEB_BUILD_DIR) control postrm
	
	# assemble the formal "deb" package
	cd $(DEB_BUILD_DIR) && \
		$(AR) rc $(DEB_PKG) debian-binary control.tar.gz data.tar.gz && \
		$(MV) $(DEB_PKG) $(RELEASE_DIR)

$(SAMBAMBA): $(SAMBAMBA_ZIP)
	cd $(RESOURCES_DIR) && \
		$(TAR) -jxvf $(SAMBAMBA_ZIP)

$(SAMBAMBA_ZIP):
	mkdir -p $(RESOURCES_DIR)
	cd $(RESOURCES_DIR) && \
		$(CURL) -L -O $(SAMBAMBA_URL)

debclean:
	if [ -e $(DEB_BUILD_DIR) ]; then $(RM) -rf $(DEB_BUILD_DIR); fi
	if [ -e $(DEB_PKG_PATH) ]; then $(RM) -rf $(DEB_PKG_PATH); fi

clean:
	if [ -e $(DEB_BUILD_DIR) ]; then $(RM) -rf $(DEB_BUILD_DIR); fi
	if [ -e $(DEB_PKG_PATH) ]; then $(RM) -rf $(DEB_PKG_PATH); fi
