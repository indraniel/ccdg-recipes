#!/usr/bin/env Rscript

# from https://gist.github.com/viking/1503736
install.package.version <- function(
  package,
  version = NULL,
  repos = getOption('repos'),
  type = getOption("pkgType"))
{
  contriburl <- contrib.url(repos, type)
  available <- available.packages(contriburl)
  if (package %in% row.names(available)) {
    current.version <- available[package, 'Version']
    if (is.null(version) || version == current.version) {
      install.packages(package, repos = repos, contriburl = contriburl, type = type)
      return()
    }
  }

  con <- gzcon(url(sprintf("%s/src/contrib/Meta/archive.rds", repos), "rb"))
  archive <- readRDS(con)
  close(con)

  if (!(package %in% names(archive))) {
    stop(sprintf("couldn't find package '%s'", package))
  }
  info <- archive[[package]]
  available.package.versions <- rownames(info)

  if (is.null(version)) {
    # Just grab the latest one. This will only happen if the package
    # has been pulled from CRAN.
    package.path <- info[length(info)]
  } else {
    package.path <- paste(package, "/", package, "_", version, ".tar.gz", sep="")
    if (!(package.path %in% available.package.versions)) {
      stop(sprintf("version '%s' is invalid for package '%s'", version, package))
    }
  }
  package.url <- sprintf("%s/src/contrib/Archive/%s", repos, package.path)
  install.packages(package.url, repos = NULL)
}

# Standard install
std.install <- function() {
  install.packages("knitr", repos="http://cran.wustl.edu")
  install.packages("rjson", repos="http://cran.wustl.edu")
  install.packages("ggplot2", repos="http://cran.wustl.edu")
  install.package("gridExtra", repos="http://cran.wustl.edu")
  install.packages("optparse", repos="http://cran.wustl.edu")
}

# Pinned install
pinned.install <- function() {
  install.package.version("mime", version="0.3", repos="http://cran.wustl.edu")
  install.package.version("stringi", version="0.5-5", repos="http://cran.wustl.edu")
  install.package.version("magrittr", version="1.5", repos="http://cran.wustl.edu")
  install.package.version("evaluate", version="0.7.2", repos="http://cran.wustl.edu")
  install.package.version("digest", version="0.6.8", repos="http://cran.wustl.edu")
  install.package.version("formatR", version="1.2", repos="http://cran.wustl.edu")
  install.package.version("highr", version="0.5", repos="http://cran.wustl.edu")
  install.package.version("markdown", version="0.7.7", repos="http://cran.wustl.edu")
  install.package.version("stringr", version="1.0.0", repos="http://cran.wustl.edu")
  install.package.version("yaml", version="2.1.13", repos="http://cran.wustl.edu")
  install.package.version("knitr", version="1.11", repos="http://cran.wustl.edu")
  install.package.version("rjson", version="0.2.15", repos="http://cran.wustl.edu")
  install.package.version("colorspace", version="1.2-6", repos="http://cran.wustl.edu")
  install.package.version("Rcpp", version="0.12.0", repos="http://cran.wustl.edu")
  install.package.version("RColorBrewer", version="1.1-2", repos="http://cran.wustl.edu")
  install.package.version("dichromat", version="2.0-0", repos="http://cran.wustl.edu")
  install.package.version("munsell", version="0.4.2", repos="http://cran.wustl.edu")
  install.package.version("labeling", version="0.3", repos="http://cran.wustl.edu")
  install.package.version("plyr", version="1.8.3", repos="http://cran.wustl.edu")
  install.package.version("gtable", version="0.1.2", repos="http://cran.wustl.edu")
  install.package.version("reshape2", version="1.4.1", repos="http://cran.wustl.edu")
  install.package.version("scales", version="0.2.5", repos="http://cran.wustl.edu")
  install.package.version("proto", version="0.3-10", repos="http://cran.wustl.edu")
  install.package.version("ggplot2", version="1.0.1", repos="http://cran.wustl.edu")
  install.package.version("gridExtra", version="2.0.0", repos="http://cran.wustl.edu")
  install.package.version("getopt", version="1.20.0", repos="http://cran.wustl.edu")
  install.package.version("optparse", version="1.3.0", repos="http://cran.wustl.edu")
}

# latest development editions -- may not cleanly install
dev.install <- function() {
  install.packages('devtools', repos="http://cran.wustl.edu")
  library(devtools)
  devtools::install_github("hadley/devtools")
  install.package.version("gsalib", version="2.1", repos="http://cran.wustl.edu")
  install.package.version("optparse", version="1.3.2", repos="http://cran.wustl.edu")
  install.package.version("getopt", version="1.20.0", repos="http://cran.wustl.edu")
  install_github("hadley/ggplot2", ref="2b41ba40cc9ed642cd29c304008af5e75f741c4d")
  install_github("baptiste/gridextra", ref="b013411f9bc8040ab2e463cada9580d914554467")
  install_github("yihui/knitr", ref="05bd9e601b07c0d27677980f24e8ae841c6445fd")
  install_github("hadley/reshape", ref="48f2be4c8eac1d47cfd3d4b0a3fa3596976dffb8")
  install_github("hadley/dplyr", ref="b205d1f08f496fccf22f1d50d71d771e67e353ec")
}

# informative display
display.installs <- function() {
  dir <- Sys.getenv(c("R_LIBS"))
  pkgs <- installed.packages(lib.loc=dir)
  print(pkgs[,c("Package", "Version", "Depends")])
}

args <- commandArgs(trailingOnly=TRUE)

if (args == "dev") {
  print("--> Performing a 'dev' install")
  dev.install()
} else if (args == "pinned") {
  print("--> Performing a 'pinned' install")
  pinned.install()
} else {
  print("Don't know how to install!")
  quit(save="no", status=1)
}

cat(paste(""))
display.installs()
