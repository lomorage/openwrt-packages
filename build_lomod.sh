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

  for item in libwebp\
              fftw \
              libde265 \
              libheif \
              libimagequant \
              orc \
              vips \
              lomo-web \
              lomo-backend
    do
      make CONFIG_PACKAGE_$item=m package/$item/clean
      make CONFIG_PACKAGE_$item=m package/$item/compile -j `nproc` V=s
    done

  if [[ $config == *"arm"* ]];then
    make CONFIG_PACKAGE_lomo-backend_nohf=m package/lomo-backend/compile -j `nproc` V=s
  fi

  # Free space (optional)
  #rm -rf build_dir/target-*
  #rm -rf build_dir/toolchain-*
else
  for configfile in configs/*; do
    arch=$(basename $configfile | awk -F. '{ print $1"."$2 }')
    echo "available arch: $arch"
  done
fi
