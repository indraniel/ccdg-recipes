.PHONY: clean debian debian-build debclean

# external commands used
CURL       := /usr/bin/curl
GIT        := /usr/bin/git
TAR        := /bin/tar
CP         := /bin/cp
RM         := /bin/rm
MV         := /bin/mv
MKDIR      := /bin/mkdir
ECHO       := /bin/echo
AR         := /usr/bin/ar
TEST       := /usr/bin/test

# basic workspace directories
WORK_DIR         := /build
BASE_INSTALL_DIR := $(WORK_DIR)
RELEASE_DIR      := /release

# source code information
EAGLE_VERSION    := 2.4.1
EAGLE_URL        := https://github.com/indraniel/eagle
EAGLE_GIT_COMMIT := 93cfc2f        # from: git rev-parse --short hall-lab (git branch)
EAGLE_GIT_BRANCH := hall-lab
EAGLE_BUILD_DIR  := $(WORK_DIR)/eagle
EAGLE_OUTPUT_DIR := $(WORK_DIR)/eagle/src
EAGLE            := $(EAGLE_OUTPUT_DIR)/eagle-$(EAGLE_VERSION)

# debian packaging related variables
DEB_BUILD_DIR       := $(WORK_DIR)/deb-build
DEBIAN_EDITION      := $(shell cat /etc/debian_version)
DEB_RELEASE_VERSION := 1debian$(DEBIAN_EDITION)
DEB_PKG             := hall-lab-eagle-$(EAGLE_VERSION)_$(EAGLE_VERSION)-$(DEB_RELEASE_VERSION).deb
DEB_PKG_PATH        := $(RELEASE_DIR)/$(DEB_PKG)
DEB_BASE_INSTALL    := /opt/hall-lab/eagle-$(EAGLE_VERSION)

# DEBIAN CONTROL FILE ##########################################################
define debian_control
Package: hall-lab-eagle-$(EAGLE_VERSION)
Architecture: amd64
Section: science
Maintainer: Indraniel Das <idas@wustl.edu>
Priority: optional
Depends: libc6, libstdc++6, libopenblas-base, libgomp1, libcurl3, libboost-iostreams1.62.0, libboost-program-options1.62.0, libboost-random1.62.0, hall-lab-htslib-1.9
Description: eagle-$(EAGLE_VERSION) for the Hall Lab
Version: $(EAGLE_VERSION)-$(DEB_RELEASE_VERSION)
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

# EAGLE EXECUTABLE DEBIAN WRAPPER ##############################################
define eagle_wrapper
#!/bin/bash

BASE=$(DEB_BASE_INSTALL)
export LD_LIBRARY_PATH=/opt/hall-lab/htslib-1.9/lib:$${LD_LIBRARY_PATH}

exec $${BASE}/bin/$(EAGLE) "$$@"
endef
export eagle_wrapper

all: debian

debian: debian-build
	# create the underlying tars of the debian package
	$(TAR) cvzf $(DEB_BUILD_DIR)/data.tar.gz --owner=0 --group=0 -C $(DEB_BUILD_DIR) opt
	$(TAR) cvzf $(DEB_BUILD_DIR)/control.tar.gz -C $(DEB_BUILD_DIR) control postrm
	
	# assemble the formal "deb" package
	cd $(DEB_BUILD_DIR) && \
		$(AR) rc $(DEB_PKG) debian-binary control.tar.gz data.tar.gz && \
		$(MV) $(DEB_PKG) $(RELEASE_DIR)

debian-build: | $(EAGLE)
	# setup the directory
	$(TEST) -d $(DEB_BUILD_DIR) || $(MKDIR) $(DEB_BUILD_DIR)
	
	# setup the debian package meta information
	$(ECHO) "$$debian_postrm" > $(DEB_BUILD_DIR)/postrm
	$(ECHO) "$$debian_control" > $(DEB_BUILD_DIR)/control
	$(ECHO) 2.0 > $(DEB_BUILD_DIR)/debian-binary
	
	# create the "installed" file directory structure
	$(MKDIR) -p $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)/bin
	
	# install the formal binary
	$(CP) -rv $(EAGLE) $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)/bin
	
	# wrapper script for eagle (setup library paths)
	echo "$$eagle_wrapper" > $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)/bin/eagle
	chmod a+x $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)/bin/eagle

$(EAGLE):
	$(GIT) clone $(EAGLE_URL) \
		&& cd $(EAGLE_BUILD_DIR) \
		&& $(GIT) checkout -b $(EAGLE_VERSION) $(EAGLE_GIT_COMMIT) \
		&& cd src \
		&& make clean \
		&& make

debclean:
	if [ -e $(DEB_BUILD_DIR) ]; then $(RM) -rf $(DEB_BUILD_DIR); fi
	if [ -e $(DEB_PKG_PATH) ]; then $(RM) -rf $(DEB_PKG_PATH); fi

clean:
	if [ -e $(EAGLE_BUILD_DIR) ]; then $(RM) -rf $(EAGLE_BUILD_DIR); fi
	if [ -e $(DEB_BUILD_DIR) ]; then $(RM) -rf $(DEB_BUILD_DIR); fi
	if [ -e $(DEB_PKG_PATH) ]; then $(RM) -rf $(DEB_PKG_PATH); fi
