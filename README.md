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

## 2.  Prepare Entware on host

Entware uses the same infrastructure as OpenWRT to build.

Install dependencies: https://openwrt.org/docs/guide-developer/build-system/install-buildsystem#debianubuntu

Follow the instruction https://github.com/Entware/Entware/wiki/Compile-packages-from-sources till "Activate a supported platform configuration",  once you have the config, no need to `make menuconfig` in this step, you can then build the cross compile toolchain.

```
make toolchain/install
```

## 3. Build Lomorage dependencies

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



Then you can use `make menuconfig` and choose the packages, and run following command to compile ufraw, you can use similar command to compile others:

```
make -j5 package/ufraw/compile package/index V=s
```

The "ipk" package is generated in `bin/targets/mips-3.4/generic-glibc/packages/` if arch is mips.

And then you can copy the packages to openwrt router and install with:

```
ipkg install ./ufraw_0.22-0_mips-3.4.ipk
```

Should notice that vips is already in openwrt/entware package (`feeds/packages/libs/vips`), but that need some patches to make it work, so you can change the vips there.
