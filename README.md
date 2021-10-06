# openwrt-packages
Lomorage openwrt dependencies.

Assume you already have openwrt installed on router.

## 1. Install Entware on router

Follow the instruction at https://github.com/Entware/Entware/wiki/Alternative-install-vs-standard to install Entware on router.

You can use `cat /proc/cpuinfo` to check the architecture:

```
root@OpenWrt:/mnt/sda1# cat /proc/cpuinfo 
system type		: Atheros AR9344 rev 2
machine			: Western Digital My Net N750
processor		: 0
cpu model		: MIPS 74Kc V4.12
BogoMIPS		: 278.93
wait instruction	: yes
microsecond timers	: yes
tlb_entries		: 32
extra interrupt vector	: yes
hardware watchpoint	: yes, count: 4, address/irw mask: [0x0ffc, 0x0ffc, 0x0ffb, 0x0ffb]
isa			: mips1 mips2 mips32r1 mips32r2
ASEs implemented	: mips16 dsp dsp2
Options implemented	: tlb 4kex 4k_cache prefetch mcheck ejtag llsc dc_aliases perf_cntr_intr_bit nan_legacy nan_2008 perf
shadow register sets	: 1
kscratch registers	: 0
package			: 0
core			: 0
VCED exceptions		: not available
VCEI exceptions		: not available
```

 If it's MIPS, you can use `lscpu` to check the byte order, mips is a big-endian mips architecture,. mipsel is a little-endian mips architecture.

```
root@OpenWrt:/mnt/sda1# lscpu | grep "Byte Order"
Byte Order:          Big Endian
```

Most likely you need mount USB drive and use that for packages installation, refer to:

1. https://openwrt.org/docs/guide-user/storage/usb-drives-quickstart#procedure
2. https://www.jianshu.com/p/4061eeaccd13

## 2.  Prepare Entware on host

Entware uses the same infrastructure as OpenWRT to build.

Install dependencies: https://openwrt.org/docs/guide-developer/build-system/install-buildsystem#debianubuntu

Follow the instruction https://github.com/Entware/Entware/wiki/Compile-packages-from-sources till "Activate a supported platform configuration",  once you have the config, no need to `make menuconfig` in this step, you can then build the cross compile toolchain.

```
make toolchain/install
```

## 3. Build Lomorage dependencies on host

Add the source to "feeds.conf" to the **beginning**,  OpenWRT/Entware are building from source directly. 

```
src-git lomorage https://github.com/lomorage/openwrt-packages.git
```

And then run following command to pull the source and link to package directory.

```
./scripts/feeds update -a
./scripts/feeds install -a -f -p lomorage
```

Make sure vips and libwebp is overriding the default in Entware:

```
./scripts/feeds uninstall vips
./scripts/feeds install -p lomorage -f vips

./scripts/feeds uninstall libwebp
./scripts/feeds install -p lomorage -f libwebp
```

Then you need **use `make menuconfig` and choose the packages**, and run following command to compile ufraw, you can use similar command to compile others:

```
make -j5 package/ufraw/compile package/index V=s
```

The "ipk" package is generated in `bin/targets/mips-3.4/generic-glibc/packages/` if arch is mips.

And then you can copy the packages to openwrt router and install with:

```
ipkg install ./ufraw_0.22-0_mips-3.4.ipk
```

Should notice that vips is already in openwrt/entware package (`feeds/packages/libs/vips`), but that need some patches to make it work, so you can change the vips there.

## 4. Build lomod on host

Just run `make -j5 package/lomo-backend/compile package/index V=s` . For "arm" architecture, it will generate "hf" and "nohf" versions, and "hf" means hard float, you can check whether the CPU supports hard float by `grep "fpu" /proc/cpuinfo` and if it shows `fpu     : yes` then it supports hard float.

## 5. Installation on router

On router, install dependencies and tools from Entware repo:

```
opkg install coreutils-stat perl-image-exiftool ffmpeg ffprobe lsblk
```

copy those ipk files build in above steps from host to router to one directory, say "/mnt/sda1/lomorage".

```
root@OpenWrt:/mnt/sda1/lomorage# ls
Packages.gz                           libheif_1.12.0-0_mips-3.4.ipk         lomo-backend_7f56dc2c-1_mips-3.4.ipk  vips_8.10.6-1_mips-3.4.ipk
Packages.stamps                       libimagequant_2.16.0-0_mips-3.4.ipk   orc_0.4.29-0_mips-3.4.ipk             vips_8.11.4-1_mips-3.4.ipk
libde265_1.0.8-0_mips-3.4.ipk         libwebp_1.2.0-3_mips-3.4.ipk 
```

Then we need opkg-utils to create repo:

```
root@OpenWrt:/mnt/sda1/# git clone git://git.yoctoproject.org/opkg-utils
# you can update /etc/profile as well
root@OpenWrt:/mnt/sda1/# export PATH="/mnt/sda1/opkg-utils:$PATH"
root@OpenWrt:/mnt/sda1/# cd /mnt/sda1/lomorage
root@OpenWrt:/mnt/sda1/lomorage# opkg install python3
root@OpenWrt:/mnt/sda1/lomorage# opkg-make-index . > Packages
```

Then add `src/gz local file:///mnt/sda1/lomorage` in "/opt/etc/opkg.conf",  right after the "entware" entry as below:

```
src/gz entware http://bin.entware.net/mipssf-k3.4
src/gz local file:///mnt/sda1/lomorage
dest root /
lists_dir ext /opt/var/opkg-lists
arch all 100
arch mips-3x 150
arch mips-3.4 160
```

and then you can install "lomo-backend", all the dependencies should be installed automatically:

```
root@OpenWrt:/mnt/sda1/# opkg update
root@OpenWrt:/mnt/sda1/# opkg install lomo-backend
```

Then you can run lomod:

```
GOGC=50 lomod --mount-dir /mnt
```

