#!/bin/bash

set -ex

arch=armv7-3.2
if [ $# -ge 1 ]
then
  arch=$1
fi

pkg_dir=bin/targets/$arch/generic-glibc/packages
tmp_dirname=lomorage
lomo_dir=$pkg_dir/$tmp_dirname

rm -rf $lomo_dir
mkdir -p $lomo_dir

cp $pkg_dir/fftw*.ipk $lomo_dir/
cp $pkg_dir/libde265*.ipk $lomo_dir/
cp $pkg_dir/libheif*.ipk $lomo_dir/
cp $pkg_dir/libimagequant*.ipk $lomo_dir/
cp $pkg_dir/orc*.ipk $lomo_dir/
cp $pkg_dir/vips*.ipk $lomo_dir/
cp $pkg_dir/libwebp*.ipk $lomo_dir/
cp $pkg_dir/lomo-backend*.ipk $lomo_dir/

tarball=release-lomod_$arch.tar.gz

pushd $lomo_dir
opkg-make-index . > Packages
gzip Packages
cd ..
tar -zcf $tarball $tmp_dirname
#rm -r $tmp_dirname
popd

mv ${pkg_dir}/$tarball .
