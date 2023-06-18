{
  description = "build kernel";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in
    {

      devShells.x86_64-linux.default =
        let aarch64 = pkgs.pkgsCross.aarch64-multiplatform;
        in
        aarch64.linux_4_19.overrideAttrs (old: {
          nativeBuildInputs =
            old.nativeBuildInputs ++
            (with pkgs;[
              llvmPackages_14.bintools-unwrapped
              buildPackages.binutils
              clang_14
              lld_14
            ]);
        })
      ;
      # make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE CROSS_COMPILE_ARM32=CROSS_COMPILE_ARM32  LLVM=1 LLVM_IAS=1 O=$O CC=$CC -j23
    };
}

