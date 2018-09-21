.PHONY: clean debian debclean

# external commands used
CURL  := /usr/bin/curl
TAR   := /bin/tar
CP    := /bin/cp
RM    := /bin/rm
MV    := /bin/mv
MKDIR := /bin/mkdir
ECHO  := /bin/echo
AR    := /usr/bin/ar
TEST  := /usr/bin/test

# basic workspace directories
WORK_DIR         := /build
BASE_INSTALL_DIR := $(WORK_DIR)
RESOURCES_DIR    := $(WORK_DIR)/resources
RELEASE_DIR      := /release

# source code information
SAMTOOLS_VERSION    := 1.9
SAMTOOLS_URL        := https://github.com/samtools/samtools/releases/download/$(SAMTOOLS_VERSION)/samtools-$(SAMTOOLS_VERSION).tar.bz2
SAMTOOLS_ZIP        := $(RESOURCES_DIR)/samtools-$(SAMTOOLS_VERSION).tar.bz2
SAMTOOLS_OUTPUT_DIR := $(WORK_DIR)/samtools-$(SAMTOOLS_VERSION)
SAMTOOLS            := $(WORK_DIR)/bin/samtools

# debian packaging related variables
DEB_BUILD_DIR       := $(WORK_DIR)/deb-build
DEBIAN_EDITION      := $(shell cat /etc/debian_version)
DEB_RELEASE_VERSION := 1debian$(DEBIAN_EDITION)
DEB_PKG             := hall-lab-samtools-$(SAMTOOLS_VERSION)_$(SAMTOOLS_VERSION)-$(DEB_RELEASE_VERSION).deb
DEB_PKG_PATH        := $(RELEASE_DIR)/$(DEB_PKG)
DEB_BASE_INSTALL    := /opt/hall-lab/samtools-$(SAMTOOLS_VERSION)
DEBIAN_PROFILE_DIR  := /etc/profile.d
SAMTOOLS_PROFILE    := $(DEBIAN_PROFILE_DIR)/hall-lab-samtools.sh

# DEBIAN CONTROL FILE ##########################################################
define debian_control
Package: hall-lab-samtools-$(SAMTOOLS_VERSION)
Architecture: amd64
Section: science
Maintainer: Dave Larson <delarson@wustl.edu>
Priority: optional
Depends: libc6, libcurl3, zlib1g, ca-certificates, libncurses5, libbz2-1.0, liblzma5, libssl1.0.2, hall-lab-htslib-1.9
Description: samtools-$(SAMTOOLS_VERSION) for the Hall Lab
Version: $(SAMTOOLS_VERSION)-$(DEB_RELEASE_VERSION)
endef
export debian_control

# DEBIAN POSTRM FILE ###########################################################
define debian_postrm
#!/bin/bash

BASE=$(DEB_BASE_INSTALL)
PROFILE_SCRIPT=$(SAMTOOLS_PROFILE)

if [ -e $${BASE} ]; then
    $(RM) -rfv $${BASE}
fi

if [ -e $${PROFILE_SCRIPT} ]; then
	$(RM) -fv $${PROFILE_SCRIPT}
fi

endef
export debian_postrm

# SAMTOOLS PATH CONFIGURATION ###########################################################
define samtools_path_set
#!/bin/bash

PATH=${DEB_BASE_INSTALL}/bin:$$PATH
endef
export samtools_path_set

all: debian

debian: | $(SAMTOOLS)
	# setup the directory
	$(TEST) -d $(DEB_BUILD_DIR) || $(MKDIR) $(DEB_BUILD_DIR)
	
	# setup the debian package meta information
	$(ECHO) "$$debian_postrm" > $(DEB_BUILD_DIR)/postrm
	$(ECHO) "$$debian_control" > $(DEB_BUILD_DIR)/control
	$(ECHO) 2.0 > $(DEB_BUILD_DIR)/debian-binary
	
	# create the "installed" file directory structure
	$(MKDIR) -p $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	$(MKDIR) -p $(DEB_BUILD_DIR)/$(DEBIAN_PROFILE_DIR)

	$(CP) -rv $(BASE_INSTALL_DIR)/bin $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	$(CP) -rv $(BASE_INSTALL_DIR)/share $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)

	# add hall-lab samtools path for all users in login shells
	echo "$$samtools_path_set" > ${DEB_BUILD_DIR}/$(SAMTOOLS_PROFILE)
	
	# create the underlying tars of the debian package
	$(TAR) cvzf $(DEB_BUILD_DIR)/data.tar.gz --owner=0 --group=0 -C $(DEB_BUILD_DIR) opt etc
	$(TAR) cvzf $(DEB_BUILD_DIR)/control.tar.gz -C $(DEB_BUILD_DIR) control postrm
	
	# assemble the formal "deb" package
	cd $(DEB_BUILD_DIR) && \
		$(AR) rc $(DEB_PKG) debian-binary control.tar.gz data.tar.gz && \
		$(MV) $(DEB_PKG) $(RELEASE_DIR)

$(SAMTOOLS): $(SAMTOOLS_ZIP)
	$(TAR) -jxvf $(SAMTOOLS_ZIP) \
		&& cd $(SAMTOOLS_OUTPUT_DIR) \
		&& ./configure --with-htslib=/opt/hall-lab/htslib-${SAMTOOLS_VERSION} --prefix="$(BASE_INSTALL_DIR)" \
		&& make all \
		&& make install


$(SAMTOOLS_ZIP):
	mkdir -p $(RESOURCES_DIR)
	cd $(RESOURCES_DIR) && \
		$(CURL) -L -O $(SAMTOOLS_URL)

debclean:
	if [ -e $(DEB_BUILD_DIR) ]; then $(RM) -rf $(DEB_BUILD_DIR); fi
	if [ -e $(DEB_PKG_PATH) ]; then $(RM) -rf $(DEB_PKG_PATH); fi

clean:
	if [ -e $(SAMTOOLS_OUTPUT_DIR) ]; then $(RM) -rf $(SAMTOOLS_OUTPUT_DIR); fi
	if [ -e $(HTSLIB_OUTPUT_DIR) ]; then $(RM) -rf $(HTSLIB_OUTPUT_DIR); fi
	if [ -e $(DEB_BUILD_DIR) ]; then $(RM) -rf $(DEB_BUILD_DIR); fi
	if [ -e $(DEB_PKG_PATH) ]; then $(RM) -rf $(DEB_PKG_PATH); fi
