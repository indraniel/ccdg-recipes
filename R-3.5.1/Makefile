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
CHMOD   := /bin/chmod
AR      := /usr/bin/ar
TEST    := /usr/bin/test
HEAD    := /usr/bin/head
TAIL    := /usr/bin/tail

# basic workspace directories
WORK_DIR         := /build
BASE_INSTALL_DIR := $(WORK_DIR)
RELEASE_DIR      := /release

R_VERSION      := 3.5.1
R_INSTALL_DIR  := /opt/hall-lab/R-$(R_VERSION)
R_BIN          := $(R_INSTALL_DIR)/bin/R
R_SRC_TAR      := R-$(R_VERSION).tar.gz
R_URL          := http://cran.wustl.edu/src/base/R-3/$(R_SRC_TAR)
R_BUILD_TAR    := /build/$(R_SRC_TAR)
R_BUILD_DIR    := /build/R-$(R_VERSION)

INTEL_MKL_VERSION       := 2019.0-117
INTEL_MKL_DIR           := /opt/intel/compilers_and_libraries_2019.0.117/linux/mkl
INTEL_MKL_LIBS_DIR      := $(INTEL_MKL_DIR)/lib/intel64
INTEL_MKL_BLAS_LD_FLAGS := -L $(INTEL_MKL_LIBS_DIR) -Wl,--no-as-needed -lmkl_gf_lp64 -lmkl_gnu_thread -lmkl_core -lgomp -lpthread -lm -ldl


BUILD_DEPENDENCIES := /build/dependencies

DEB_BUILD_DIR       := $(WORK_DIR)/deb-build
DEBIAN_EDITION      := $(shell cat /etc/debian_version)
DEB_RELEASE_VERSION := 1debian$(DEBIAN_EDITION)
DEB_PKG             := hall-lab-r-$(R_VERSION)-mkl-$(INTEL_MKL_VERSION)_$(R_VERSION)-$(DEB_RELEASE_VERSION).deb
DEB_PKG_PATH        := $(RELEASE_DIR)/$(DEB_PKG)
DEB_BASE_INSTALL    := /opt/hall-lab/R-$(R_VERSION)

all: $(DEB_PKG_PATH)

# DEBIAN CONTROL FILE ##########################################################
define debian_control
Package: hall-lab-r-$(R_VERSION)-mkl-$(INTEL_MKL_VERSION)
Architecture: amd64
Section: science
Maintainer: Indraniel Das <idas@wustl.edu>
Priority: optional
Depends: intel-mkl-core-rt-2019.0-117, intel-mkl-gnu-rt-2019.0-117, intel-mkl-gnu-f-rt-2019.0-117, intel-mkl-common-2019.0-117, intel-mkl-common-c-2019.0-117, intel-mkl-common-f-2019.0-117, build-essential, g++, gfortran, libncurses5, libreadline7, libjpeg62-turbo, libpcre3, libpng16-16, zlib1g, zip, unzip, libbz2-1.0, libc6, libgomp1, liblzma5, libtiff5, libx11-6, libxt6, libxmu6, libcairo2, libpango1.0-0, libpangocairo-1.0-0, libcurl3, libcurl4-openssl-dev, curl
Description: R for Hall Lab ( $(R_VERSION) ) linked to Intel MKL ( $(INTEL_MKL_VERSION) )
Version: $(R_VERSION)-$(DEB_RELEASE_VERSION)
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

# RSCRIPT EXECUTABLE WRAPPER ###########################################################
define rscript_wrapper
#!/bin/bash

BASE=$(DEB_BASE_INSTALL)
export LD_LIBRARY_PATH==$(INTEL_MKL_LIBS_DIR):$$LD_LIBRARY_PATH

exec $${BASE}/bin/Rscript-mkl "$$@"
endef
export rscript_wrapper

all: $(DEB_PKG_PATH)

$(DEB_PKG_PATH): $(R_BIN)
	# setup the directory
	$(TEST) -d $(DEB_BUILD_DIR) || $(MKDIR) $(DEB_BUILD_DIR)
	
	# setup the debian package meta information
	$(ECHO) "$$debian_postrm" > $(DEB_BUILD_DIR)/postrm
	$(ECHO) "$$debian_control" > $(DEB_BUILD_DIR)/control
	$(ECHO) 2.0 > $(DEB_BUILD_DIR)/debian-binary
	
	# create the "installed" file directory structure
	$(MKDIR) -p $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# install the compiled R build directory
	$(CP) -rv $(R_INSTALL_DIR)/* $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# create the underlying tars of the debian package
	$(TAR) cvzf $(DEB_BUILD_DIR)/data.tar.gz --owner=0 --group=0 -C $(DEB_BUILD_DIR) opt
	$(TAR) cvzf $(DEB_BUILD_DIR)/control.tar.gz -C $(DEB_BUILD_DIR) control postrm
	
	# assemble the formal "deb" package
	cd $(DEB_BUILD_DIR) && \
		$(AR) rc $(DEB_PKG) debian-binary control.tar.gz data.tar.gz && \
		$(MV) $(DEB_PKG) $(RELEASE_DIR)

$(R_BIN): export R_SHELL=/bin/bash
$(R_BIN): export LDFLAGS := -L $(INTEL_MKL_DIR)/lib/intel64 -L /usr/lib/x86_64-linux-gnu
$(R_BIN): export CFLAGS := -I $(INTEL_MKL_DIR)/include
$(R_BIN): export BLAS := $(INTEL_MKL_BLAS_LD_FLAGS)
$(R_BIN): export LD_LIBRARY_PATH=$(INTEL_MKL_LIBS_DIR)
$(R_BIN): | $(BUILD_DEPENDENCIES) $(R_BUILD_DIR) 
	cd $(R_BUILD_DIR) && \
		./configure --prefix=$(R_INSTALL_DIR) \
					--enable-R-shlib \
					--enable-R-static-lib \
					--disable-java \
					--enable-openmp \
					--enable-largefile \
					--with-blas="$(INTEL_MKL_BLAS_LD_FLAGS)" \
					--with-lapack \
					--without-tcltk \
					--with-cairo \
					--with-libpng \
					--with-libtiff \
					--with-recommended-packages \
					--with-gnu-ld \
					--with-x
	cd $(R_BUILD_DIR) && make
	cd $(R_BUILD_DIR) && make check
	cd $(R_BUILD_DIR) && make install

	# adjust the final R executable (include the location of the Intel MKL libraries)
	$(MV) $(R_INSTALL_DIR)/bin/R $(R_INSTALL_DIR)/bin/R.orig
	$(HEAD) -n 2 $(R_INSTALL_DIR)/bin/R.orig > $(R_INSTALL_DIR)/bin/R
	$(ECHO) -e "\nexport LD_LIBRARY_PATH=$(INTEL_MKL_LIBS_DIR):\$$LD_LIBRARY_PATH" >>$(R_INSTALL_DIR)/bin/R
	$(TAIL) -n +3 $(R_INSTALL_DIR)/bin/R.org >> $(R_INSTALL_DIR)/bin/R
	$(RM) $(R_INSTALL_DIR)/bin/R.orig

	# adjust the final Rscript executable -- make a wrapper to it
	$(MV) $(R_INSTALL_DIR)/bin/Rscript $(R_INSTALL_DIR)/bin/Rscript-mkl
	$(ECHO) "$$rscript_wrapper" > $(R_INSTALL_DIR)/Rscript
	$(CHMOD) 0755 $(R_INSTALL_DIR)/Rscript

$(R_BUILD_DIR): $(R_BUILD_TAR)
	cd /build && $(TAR) zxvf $(R_SRC_TAR)

$(R_BUILD_TAR):
	cd /build && $(CURL) -O $(R_URL)

$(BUILD_DEPENDENCIES):
	$(APT_GET) update
	$(APT_GET) install -y build-essential
	$(APT_GET) install -y gcc
	$(APT_GET) install -y g++
	$(APT_GET) install -y gfortran
	$(APT_GET) install -y libncurses5-dev
	$(APT_GET) install -y libncurses5
	$(APT_GET) install -y libreadline-dev
	$(APT_GET) install -y libreadline7
	$(APT_GET) install -y libjpeg62-turbo-dev
	$(APT_GET) install -y libpcre3-dev
	$(APT_GET) install -y libpcre3
	$(APT_GET) install -y libpng-dev
	$(APT_GET) install -y libpng16-16
	$(APT_GET) install -y zlib1g-dev
	$(APT_GET) install -y zlib1g
	$(APT_GET) install -y zip
	$(APT_GET) install -y unzip
	$(APT_GET) install -y libbz2-1.0
	$(APT_GET) install -y libbz2-dev
	$(APT_GET) install -y libc6
	$(APT_GET) install -y libgfortran3
	$(APT_GET) install -y libgomp1
	$(APT_GET) install -y liblzma-dev
	$(APT_GET) install -y liblzma5
	$(APT_GET) install -y libtiff5-dev
	$(APT_GET) install -y libx11-6
	$(APT_GET) install -y libx11-dev
	$(APT_GET) install -y libxt6
	$(APT_GET) install -y libcairo2
	$(APT_GET) install -y libcairo2-dev
	$(APT_GET) install -y libpango1.0-dev
	DEBIAN_FRONTEND=noninteractive $(APT_GET) install -y xorg-dev
	$(APT_GET) install -y libcurl3
	$(APT_GET) install -y libcurl4-openssl-dev
	$(APT_GET) install -y curl
	$(APT_GET) install -y ca-certificates
	$(TOUCH) $(BUILD_DEPENDENCIES)

# apt-get install gfortran libjpeg8 zip unzip libtiff5 libx11-6 libxt6 libcairo2 libpango1.0-0 libpangocairo-1.0-0 libcurl4-openssl-dev libxmu6
