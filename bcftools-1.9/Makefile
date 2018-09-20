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
BCFTOOLS_VERSION    := 1.9
BCFTOOLS_URL        := https://github.com/samtools/bcftools/releases/download/$(BCFTOOLS_VERSION)/bcftools-$(BCFTOOLS_VERSION).tar.bz2
BCFTOOLS_ZIP        := $(RESOURCES_DIR)/bcftools-$(BCFTOOLS_VERSION).tar.bz2
BCFTOOLS_OUTPUT_DIR := $(WORK_DIR)/bcftools-$(BCFTOOLS_VERSION)
BCFTOOLS            := $(WORK_DIR)/bin/bcftools

# debian packaging related variables
DEB_BUILD_DIR       := $(WORK_DIR)/deb-build
DEBIAN_EDITION      := $(shell cat /etc/debian_version)
DEB_RELEASE_VERSION := 1debian$(DEBIAN_EDITION)
DEB_PKG             := hall-lab-bcftools-$(BCFTOOLS_VERSION)_$(BCFTOOLS_VERSION)-$(DEB_RELEASE_VERSION).deb
DEB_PKG_PATH        := $(RELEASE_DIR)/$(DEB_PKG)
DEB_BASE_INSTALL    := /opt/hall-lab/bcftools-$(BCFTOOLS_VERSION)
DEBIAN_PROFILE_DIR  := /etc/profile.d
BCFTOOLS_PROFILE    := $(DEBIAN_PROFILE_DIR)/hall-lab-bcftools.sh

# DEBIAN CONTROL FILE ##########################################################
define debian_control
Package: hall-lab-bcftools-$(BCFTOOLS_VERSION)
Architecture: amd64
Section: science
Maintainer: Indraniel Das <idas@wustl.edu>
Priority: optional
Depends: libc6, libcurl3, zlib1g, ca-certificates, libbz2-1.0, liblzma5, libssl1.0.2
Description: bcftools-$(BCFTOOLS_VERSION) for the Hall Lab 
Version: $(BCFTOOLS_VERSION)-$(DEB_RELEASE_VERSION)
endef
export debian_control

# DEBIAN POSTRM FILE ###########################################################
define debian_postrm
#!/bin/bash

BASE=$(DEB_BASE_INSTALL)
PROFILE_SCRIPT=$(BCFTOOLS_PROFILE)

if [ -e $${BASE} ]; then
    $(RM) -rfv $${BASE}
fi

if [ -e $${PROFILE_SCRIPT} ]; then
	$(RM) -fv $${PROFILE_SCRIPT}
fi

endef
export debian_postrm

# BCFTOOLS PATH CONFIGURATION ###########################################################
define bcftools_path_set
#!/bin/bash

PATH=${DEB_BASE_INSTALL}/bin:$$PATH
endef
export bcftools_path_set

# BCFTOOLS EXECUTABLE DEBIAN WRAPPER ###########################################################
define bcftools_wrapper
#!/bin/bash

BASE=$(DEB_BASE_INSTALL)
BCFTOOLS_PLUGINS=$${BCFTOOLS_PLUGINS:-$(DEB_BASE_INSTALL)/libexec/bcftools}
export BCFTOOLS_PLUGINS

exec $${BASE}/bin/bcftools-$(BCFTOOLS_VERSION) "$$@"
endef
export bcftools_wrapper

all: debian

debian: | $(BCFTOOLS)
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
	$(CP) -rv $(BASE_INSTALL_DIR)/libexec $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)

	# wrapper script to set bcftools plugin environment variable
	echo "$$bcftools_wrapper" > $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)/bin/bcftools
	chmod a+x $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)/bin/bcftools

	# add hall-lab bcftools path for all users in login shells
	echo "$$bcftools_path_set" > ${DEB_BUILD_DIR}/$(BCFTOOLS_PROFILE)
	
	# create the underlying tars of the debian package
	$(TAR) cvzf $(DEB_BUILD_DIR)/data.tar.gz --owner=0 --group=0 -C $(DEB_BUILD_DIR) opt etc
	$(TAR) cvzf $(DEB_BUILD_DIR)/control.tar.gz -C $(DEB_BUILD_DIR) control postrm
	
	# assemble the formal "deb" package
	cd $(DEB_BUILD_DIR) && \
		$(AR) rc $(DEB_PKG) debian-binary control.tar.gz data.tar.gz && \
		$(MV) $(DEB_PKG) $(RELEASE_DIR)

$(BCFTOOLS): $(BCFTOOLS_ZIP)
	$(TAR) -jxvf $(BCFTOOLS_ZIP) \
		&& cd $(BCFTOOLS_OUTPUT_DIR) \
		&& ./configure --with-htslib=/opt/hall-lab/htslib-${BCFTOOLS_VERSION} --prefix="$(BASE_INSTALL_DIR)" \
		&& make install \
		&& $(MV) $(BCFTOOLS) $(BCFTOOLS)-$(BCFTOOLS_VERSION)

$(BCFTOOLS_ZIP):
	mkdir -p $(RESOURCES_DIR)
	cd $(RESOURCES_DIR) && \
		$(CURL) -L -O $(BCFTOOLS_URL)

debclean:
	if [ -e $(DEB_BUILD_DIR) ]; then $(RM) -rf $(DEB_BUILD_DIR); fi
	if [ -e $(DEB_PKG_PATH) ]; then $(RM) -rf $(DEB_PKG_PATH); fi

clean:
	if [ -e $(BCFTOOLS_OUTPUT_DIR) ]; then $(RM) -rf $(BCFTOOLS_OUTPUT_DIR); fi
	if [ -e $(HTSLIB_OUTPUT_DIR) ]; then $(RM) -rf $(HTSLIB_OUTPUT_DIR); fi
	if [ -e $(DEB_BUILD_DIR) ]; then $(RM) -rf $(DEB_BUILD_DIR); fi
	if [ -e $(DEB_PKG_PATH) ]; then $(RM) -rf $(DEB_PKG_PATH); fi
