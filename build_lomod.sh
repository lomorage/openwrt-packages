#!/bin/sh

arch=armv7-3.2
if [ $# -ge 1 ]
then
  arch=$1
fi

config="configs/$arch.config"
if [ -f "$config" ]; then
  echo "use config: $config"
  cp $config .config

  make -j `nproc` tools/install V=s
  make -j `nproc` toolchain/install V=s

  # Build package
  ./scripts/feeds update -a
  ./scripts/feeds install -a -f -p lomorage

  ./scripts/feeds uninstall vips
  ./scripts/feeds install -p lomorage -f vips
  
  ./scripts/feeds uninstall libwebp
  ./scripts/feeds install -p lomorage -f libwebp

  make CONFIG_PACKAGE_libwebp=m package/libwebp/{clean,compile} -j `nproc` V=s
  make CONFIG_PACKAGE_fftw=m package/fftw/{clean,compile} -j `nproc` V=s
  make CONFIG_PACKAGE_libde265=m package/libde265/{clean,compile} -j `nproc` V=s
  make CONFIG_PACKAGE_libheif=m package/libheif/{clean,compile} -j `nproc` V=s
  make CONFIG_PACKAGE_libimagequant=m package/libimagequant/{clean,compile} -j `nproc` V=s
  make CONFIG_PACKAGE_orc=m package/orc/{clean,compile} -j `nproc` V=s
  make CONFIG_PACKAGE_vips=m package/vips/{clean,compile} -j `nproc` V=s
  make CONFIG_PACKAGE_lomo-backend=m package/lomo-backend/{clean,compile} -j `nproc` V=s

  # Free space (optional)
  #rm -rf build_dir/target-*
  #rm -rf build_dir/toolchain-*
else
  for configfile in configs/*; do
    echo "available config: $configfile"
  done
fi
