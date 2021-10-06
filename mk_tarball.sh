#!/bin/bash

set -ex

arch=armv7-3.2
if [ $# -ge 1 ]
then
  arch=$1
fi
pkg_dir=bin/targets/$arch/generic-glibc/packages/
tarball=release-lomod_$arch.tar.gz
cd $pkg_dir; tar -zcf $tarball fftw*.ipk libde265*.ipk libheif*.ipk libimagequant*.ipk orc*.ipk vips*.ipk libwebp*.ipk lomo-backend*.ipk; cd -; mv ${pkg_dir}/$tarball .
