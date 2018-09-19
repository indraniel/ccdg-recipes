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

# source code information
HTSLIB_VERSION    := 1.9
HTSLIB_URL        := https://github.com/samtools/htslib/releases/download/$(HTSLIB_VERSION)/htslib-$(HTSLIB_VERSION).tar.bz2
HTSLIB_ZIP        := $(RESOURCES_DIR)/htslib-$(HTSLIB_VERSION).tar.bz2
HTSLIB_OUTPUT_DIR := $(WORK_DIR)/htslib-$(HTSLIB_VERSION)
TABIX             := $(WORK_DIR)/bin/tabix
BGZIP             := $(WORK_DIR)/bin/bgzip

# debian packaging related variables
DEB_BUILD_DIR       := $(WORK_DIR)/deb-build
DEBIAN_EDITION      := $(shell cat /etc/debian_version)
DEB_RELEASE_VERSION := 1debian$(DEBIAN_EDITION)
DEB_PKG             := hall-lab-bcftools-$(BCFTOOLS_VERSION)_$(BCFTOOLS_VERSION)-$(DEB_RELEASE_VERSION).deb
DEB_PKG_PATH        := $(RELEASE_DIR)/$(DEB_PKG)
DEB_BASE_INSTALL    := /opt/hall-lab/bcftools-$(BCFTOOLS_VERSION)

# DEBIAN CONTROL FILE ##########################################################
define debian_control
Package: hall-lab-bcftools-$(BCFTOOLS_VERSION)
Architecture: amd64
Section: science
Maintainer: Indraniel Das <idas@wustl.edu>
Priority: optional
Depends: libc6, libcurl3, zlib1g, ca-certificates, libbz2-1.0, liblzma5, libssl1.1
Description: bcftools-$(BCFTOOLS_VERSION) plus htslib-$(HTSLIB_VERSION) for the Hall Lab 
Version: $(BCFTOOLS_VERSION)-$(DEB_RELEASE_VERSION)
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

	$(CP) -rv $(BASE_INSTALL_DIR)/bin $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	$(CP) -rv $(BASE_INSTALL_DIR)/include $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	$(CP) -rv $(BASE_INSTALL_DIR)/lib $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	$(CP) -rv $(BASE_INSTALL_DIR)/share $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	$(CP) -rv $(BASE_INSTALL_DIR)/libexec $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)

	# wrapper script to set bcftools plugin environment variable
	echo "$$bcftools_wrapper" > $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)/bin/bcftools
	chmod a+x $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)/bin/bcftools
	
	# create the underlying tars of the debian package
	$(TAR) cvzf $(DEB_BUILD_DIR)/data.tar.gz --owner=0 --group=0 -C $(DEB_BUILD_DIR) opt
	$(TAR) cvzf $(DEB_BUILD_DIR)/control.tar.gz -C $(DEB_BUILD_DIR) control postrm
	
	# assemble the formal "deb" package
	cd $(DEB_BUILD_DIR) && \
		$(AR) rc $(DEB_PKG) debian-binary control.tar.gz data.tar.gz && \
		$(MV) $(DEB_PKG) $(RELEASE_DIR)

$(BCFTOOLS): $(BCFTOOLS_ZIP) $(TABIX) $(BGZIP)
	$(TAR) -jxvf $(BCFTOOLS_ZIP) \
		&& cd $(BCFTOOLS_OUTPUT_DIR) \
		&& make all HTSDIR=$(HTSLIB_OUTPUT_DIR) prefix="$(BASE_INSTALL_DIR)" LIBS="-lcurl -lcrypto -lssl" \
		&& make install HTSDIR=$(HTSLIB_OUTPUT_DIR) prefix="$(BASE_INSTALL_DIR)" LIBS="-lcurl -lcrypto -lssl" \
		&& $(MV) $(BCFTOOLS) $(BCFTOOLS)-$(BCFTOOLS_VERSION)

$(BCFTOOLS_ZIP):
	mkdir -p $(RESOURCES_DIR)
	cd $(RESOURCES_DIR) && \
		$(CURL) -L -O $(BCFTOOLS_URL)

$(TABIX) $(BGZIP): $(HTSLIB_ZIP)
	$(TAR) -jxvf $(HTSLIB_ZIP) \
		&& cd $(HTSLIB_OUTPUT_DIR) \
		&& ./configure --enable-libcurl --prefix=$(BASE_INSTALL_DIR) \
		&& make lib-static \
		&& make install

$(HTSLIB_ZIP):
	mkdir -p $(RESOURCES_DIR)
	cd $(RESOURCES_DIR) && \
		$(CURL) -L -O $(HTSLIB_URL)

debclean:
	if [ -e $(DEB_BUILD_DIR) ]; then $(RM) -rf $(DEB_BUILD_DIR); fi
	if [ -e $(DEB_PKG_PATH) ]; then $(RM) -rf $(DEB_PKG_PATH); fi

clean:
	if [ -e $(BCFTOOLS_OUTPUT_DIR) ]; then $(RM) -rf $(BCFTOOLS_OUTPUT_DIR); fi
	if [ -e $(HTSLIB_OUTPUT_DIR) ]; then $(RM) -rf $(HTSLIB_OUTPUT_DIR); fi
	if [ -e $(DEB_BUILD_DIR) ]; then $(RM) -rf $(DEB_BUILD_DIR); fi
	if [ -e $(DEB_PKG_PATH) ]; then $(RM) -rf $(DEB_PKG_PATH); fi
