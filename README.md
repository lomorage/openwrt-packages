# Lomorage opkg packages

Lomorage setup using opkg packages with Entware repository (need dependencies in Entware, like ffmpeg exif-tools).

## Quick Start

This is for users who want to setup Lomorage using opkg packets.

### 1. Install Entware

Follow the instruction at https://github.com/Entware/Entware/wiki/Alternative-install-vs-standard to install Entware on target machine.

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

And use `uname -a ` to check Linux version:

```
root@OpenWrt:/mnt/sda1# uname -a
Linux OpenWrt 4.14.221 #0 Mon Feb 15 15:22:37 2021 mips GNU/Linux
```

Most likely you need mount USB drive and use that for packages installation, refer to:

1. https://openwrt.org/docs/guide-user/storage/usb-drives-quickstart#procedure
2. https://www.jianshu.com/p/4061eeaccd13

**Make sure you change "/etc/profile" and add `/opt/bin/go/bin:/opt/bin` in `PATH` and `/opt/lib/` in `LD_LIBRARY_PATH`**

Once you have Entware setup ready, install dependencies and tools from Entware repo:

```
root@OpenWrt:~# opkg install coreutils-stat perl-image-exiftool ffmpeg ffprobe lsblk
```

### 2. Install Lomorage

Architectures supported are:

```
aarch64-3.10    # arm64, linux kernel ver >= 3.10
armv7-3.2       # armv7, linux kernel ver >=3.2
mips-3.4        # mips big-endian, linux kernel ver >=3.2
mipsel-3.4      # mips little-endian, linux kernel ver >=3.2
```

Add `src/gz lomorage https://lomostaging.lomorage.com/opkg/[architecture]` in `/opt/etc/opkg.conf`, replace `[architecture]` with those listed above, for example if it's mips big-endian, linux kernel ver >=3.2, use `src/gz lomorage https://lomostaging.lomorage.com/opkg/mips-3.4`. This should **below "entware" entry** because some packages in entware are not compiled with needed flags, and need to be overridden.

```
root@OpenWrt:~# cat /opt/etc/opkg.conf
src/gz entware http://bin.entware.net/mipssf-k3.4
src/gz lomorage https://lomostaging.lomorage.com/opkg/mips-3.4
dest root /
lists_dir ext /opt/var/opkg-lists
arch all 100
arch mips-3x 150
arch mips-3.4 160
```

And then you can install "lomo-backend", all the dependencies should be able to be installed automatically:

```
root@OpenWrt:/mnt/sda1/# opkg update --no-check-certificate
root@OpenWrt:/mnt/sda1/# opkg install lomo-backend --no-check-certificate
```

"lomod" will start automatically after installation, the mount directory is default to "/mnt" and port default to "8000", you can also run:

```
root@OpenWrt:/mnt/sda1# /opt/etc/init.d/lomod
Usage: /opt/etc/init.d/lomod {start|stop|restart}
```

Should be notice that for "arm" architecture, it will has two versions: "hf" and "nohf", "hf" means hard float, you can check whether the CPU supports hard float by `grep "fpu" /proc/cpuinfo` and if it shows `fpu     : yes` then it supports hard float. **And if it doesn't support hard float, you should install the following packages instead:**

```
root@OpenWrt:/mnt/sda1/# opkg install lomo-backend_nohf --no-check-certificate
```

Then you can add cron job to update lomo-backend at 4:00 am everyday:

```
root@OpenWrt:~# crontab -e
```

and add the following item:

```
0 4 * * * opkg update --no-check-certificate && opkg install lomo-backend --no-check-certificate
```

## Development

This is for developers to compile opkg packages.

### 1.  Prepare Entware on host

Entware uses the same infrastructure as OpenWRT to build.

Install dependencies: https://openwrt.org/docs/guide-developer/build-system/install-buildsystem#debianubuntu

Follow the instruction https://github.com/Entware/Entware/wiki/Compile-packages-from-sources till "Activate a supported platform configuration",  once you have the config, no need to `make menuconfig` in this step, you can then build the host tools and cross compile toolchain.

```
make -j `nproc` tools/install V=s
make -j `nproc` toolchain/install V=s
```

### 2. Build Lomorage dependencies on host

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

### 3. Build lomod on host

Create soft link for `mk_tarball.sh` and `buid_lomod.sh`

```
ln -s feeds/lomorage/mk_tarball.sh mk_tarball.sh
ln -s feeds/lomorage/build_lomod.sh build_lomod.sh
ln -s feeds/lomorage/release_lomod.sh release_lomod.sh
```
Build lomod, `mips-3.4` is the architecture for your router:

```
./build_lomod.sh mips-3.4
```

For "arm" architecture, it will generate "hf" and "nohf" versions, and "hf" means hard float, you can check whether the CPU supports hard float by `grep "fpu" /proc/cpuinfo` and if it shows `fpu     : yes` then it supports hard float.

Create tarball for all ipk files in above steps by running below command. `mips-3.4` is the architecture for your router. It is armv7-3.2 by default if not given

```
./mk_tarball.sh mips-3.4
```

A new tarball file `release-lomod_mips-3.4.tar.gz` is created. Copy this tarball from host to router to one directory, say "/mnt/sda1/lomorage", and untar it. 

You can also use "release_lomod.sh" to generate opkg package repository, it will gather ipkg files in all architectures, put them in "lomorage" directory  and generate manifest file. Then they are ready to served via http/https/locally.

```
./release_lomod.sh
Found bin/targets/aarch64-3.10/generic-glibc/packages/fftw_3.3.10-1_aarch64-3.10.ipk
Found bin/targets/mips-3.4/generic-glibc/packages/fftw_3.3.10-1_mips-3.4.ipk
Found bin/targets/mipsel-3.4/generic-glibc/packages/fftw_3.3.10-1_mipsel-3.4.ipk
...
Found bin/targets/aarch64-3.10/generic-glibc/packages/lomo-backend_7f56dc2c-6_aarch64-3.10.ipk
Found bin/targets/mips-3.4/generic-glibc/packages/lomo-backend_7f56dc2c-8_mips-3.4.ipk
Found bin/targets/mipsel-3.4/generic-glibc/packages/lomo-backend_7f56dc2c-8_mipsel-3.4.ipk
```

### 4. Installation on router

Now you should get these files

```
root@OpenWrt:/mnt/sda1/lomorage# ls
fftw_3.3.10-1_mips-3.4.ipk
libde265_1.0.8-0_mips-3.4.ipk
libheif_1.12.0-0_mips-3.4.ipk
libimagequant_2.16.0-0_mips-3.4.ipk
libwebp_1.2.0-3_mips-3.4.ipk
lomo-backend_7f56dc2c-1_mips-3.4.ipk
orc_0.4.29-0_mips-3.4.ipk
vips_8.11.4-1_mips-3.4.ipk
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

Lomod will start automatically after installation, you can also run:

```
root@OpenWrt:/mnt/sda1# /opt/etc/init.d/lomod
Usage: /opt/etc/init.d/lomod {start|stop|restart}
```

## References:

https://openwrt.org/docs/guide-developer/helloworld/start

https://forum.archive.openwrt.org/viewtopic.php?id=6809&p=1#p31794

https://openwrt.org/docs/guide-developer/build-system/use-buildsystem

https://openwrt.org/docs/guide-developer/build-system/use-patches-with-buildsystem

https://github.com/Entware/entware-go

https://github.com/mwarning/openwrt-examples

https://openwrt.org/docs/guide-user/additional-software/opkg

https://gist.github.com/bewest/3808646#packaging-a-service-for-openwrt

https://github.com/mwarning/openwrt-examples/blob/master/README.md

https://gist.github.com/chankruze/dee8c2ba31c338a60026e14e3383f981

https://stackoverflow.com/questions/10814919/how-to-choose-target-and-other-features-in-openwrt-buildroot
