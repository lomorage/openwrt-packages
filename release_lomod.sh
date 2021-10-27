#!/bin/bash

set -e

lomo_dir=lomorage
rm -rf $lomo_dir
mkdir -p $lomo_dir

for arch in bin/targets/*; do
    archname=$(basename $arch | awk -F/ '{ print $1 }')
    target=$lomo_dir/$archname
    mkdir $target

    for ipkfile in $arch/generic-glibc/packages/*{fftw,orc,de265,heif,imagequant,webp,vips,lomo}*.ipk; do
        echo "Found $ipkfile"
        cp $ipkfile $target/
        cp configs/$archname.config .config
        make CONFIG_PACKAGE_lomo-backend=m package/lomo-backend/clean
        make CONFIG_PACKAGE_lomo-backend_nohf=m package/lomo-backend/clean
        make CONFIG_PACKAGE_lomo-web=m package/lomo-web/clean
    done

    pushd $target
    opkg-make-index . > Packages
    gzip Packages
    popd

    echo "opkg repository generated in $target directory"
    ls -lrt $target
done
