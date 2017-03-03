.PHONY: clean debian deblean

# external commands used
CURL  := /usr/bin/curl
TAR   := /bin/tar
CP    := /bin/cp
RM    := /bin/rm
MV    := /bin/mv
MKDIR := /bin/mkdir
ECHO  := /bin/echo
GIT   := /usr/bin/git

# basic workspace directories
WORK_DIR         := /build
BASE_INSTALL_DIR := $(WORK_DIR)
RESOURCES_DIR    := $(WORK_DIR)/resources
RELEASE_DIR      := /release

# source information. XSVR is short for EXTRACT_SV_READS
XSVR_MAIN_VERSION	:= 1.1
XSVR_VERSION    	:= 1.1.0
XSVR_URL			:= https://github.com/hall-lab/extract_sv_reads/
XSVR_SRC			:= $(RESOURCES_DIR)/extract_sv_reads
XSVR_BUILD_DIR		:= $(WORK_DIR)/xsvr_build
XSVR				:= $(XSVR_BUILD_DIR)/bin/extract-sv-reads$(XSVR_MAIN_VERSION)
XSVR_DEB			:= $(XSVR_BUILD_DIR)/extract-sv-reads$(XSVR_MAIN_VERSION)-$(XSVR_VERSION)-Linux-x86_64.deb

all: debian

debian: | $(XSVR)
	cd $(XSVR_BUILD_DIR) \
		&& cpack -G DEB \
		&& $(MV) $(XSVR_DEB) $(RELEASE_DIR)

$(XSVR): $(XSVR_SRC)
		$(MKDIR) -p $(XSVR_BUILD_DIR) \
		&& cd $(XSVR_BUILD_DIR) \
    	&& cmake -DHTSLIB_USE_LIBCURL=1 -DCMAKE_BUILD_TYPE=Package $(XSVR_SRC) \
		&& make

$(XSVR_SRC):
	mkdir -p $(RESOURCES_DIR) \
		&& cd $(RESOURCES_DIR) \
		&& git clone $(XSVR_URL) \
		&& cd $(XSVR_SRC) \
		&& git checkout v$(XSVR_VERSION)

clean:
	if [ -e $(XSVR_BUILD_DIR) ]; then $(RM) -rf $(XSVR_BUILD_DIR); fi
