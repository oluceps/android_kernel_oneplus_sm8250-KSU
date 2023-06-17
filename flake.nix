{
  description = "build";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in
    {

      devShells.x86_64-linux.default = (pkgs.buildFHSUserEnv {
        name = "kernel-build-env";
        targetPkgs = pkgs: (with pkgs;
          [
            ncurses
            lld_14
            pkgsCross.aarch64-multiplatform.gcc.cc
            llvmPackages_14.bintools
            clang_14
          ]
          ++ pkgs.linux.nativeBuildInputs);
        runScript = pkgs.writeScript "init.sh" ''
          export ARCH=arm64
          export SUBARCH=arm64
          export hardeningDisable=all
          export PATH=${pkgs.pkgsCross.aarch64-multiplatform.buildPackages.binutils}/bin/:$PATH
          export PKG_CONFIG_PATH="${pkgs.ncurses.dev}/lib/pkgconfig:${pkgs.qt5.qtbase.dev}/lib/pkgconfig"
          export CROSS_COMPILE=aarch64-unknown-linux-gnu-
          export CROSS_COMPILE_ARM32=arm-unknown-linux-gnueabi-
          export LLVM=1
          export LLVM_IAS=1 
          export O=out
          export CC=clang
          export KERNEL_CMDLINE="ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- LLVM=1 LLVM_IAS=1 O=out"
          curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -
          make $KERNEL_CMDLINE oldconfig
          make $KERNEL_CMDLINE -j$(nproc)

        '';
      }).env;
      # make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE CROSS_COMPILE_ARM32=CROSS_COMPILE_ARM32  LLVM=1 LLVM_IAS=1 O=$O CC=$CC -j23
    };
}

