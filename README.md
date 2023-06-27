> KNOWN ISSUE: MAY BROKEN QUICK CHARGE
# Get the patched kernel image:

> NOTE: prebuilt kernel image artifacts compiled with config from NamelessOS TQ2A.230505.002, follow steps below to build if using other OS.

Download zip from artifact or:



at the root of repo:
```console
curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -
```

Then enter nix devShell (pretend Nix has already installed)

```console
nix develop
```

## Generate config

- using `adb shell` enter shell in device and run `zcat /proc/config.gz > /sdcard/config` to export kernel config.
- run `adb pull /sdcard/config .config` on your computer, with the device adb connected.
- put `.config` under <repo>/out directory. then:

```bash
make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE CROSS_COMPILE_ARM32=CROSS_COMPILE_ARM32  LLVM=1 LLVM_IAS=1 O=$O CC=$CC oldconfig
```

## Compile kernel

```console
make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE CROSS_COMPILE_ARM32=CROSS_COMPILE_ARM32  LLVM=1 LLVM_IAS=1 O=$O CC=$CC -j$(nproc)
```

Found file `Image` under `out/arch/arm64/boot/`.


# repack boot.img


1. get your current origin boot.img, put it on a clean dir

2. get `magiskboot` binary from whatever place, run `magiskboot unpack ./boot.img`,

3. remove the file `kernel` unpacked, place `Image` in place and rename into `kernel`,

4. run `./magiskboot repack ./boot.img`


# Flash
Just simply flash or boot the new-boot.img using fastboot.

