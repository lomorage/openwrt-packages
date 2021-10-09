#!/bin/bash

set -e

lomo_dir=lomorage
rm -rf $lomo_dir
mkdir -p $lomo_dir

for ipkfile in bin/targets/*/generic-glibc/packages/*{fftw,de265,heif,imagequant,webp,vips,lomo}*.ipk; do
    echo "Found $ipkfile"
    cp $ipkfile $lomo_dir/
done

pushd $lomo_dir
opkg-make-index . > Packages
gzip Packages
popd

echo "opkg repository generated in $lomo_dir directory"
ls -lrt $lomo_dir
