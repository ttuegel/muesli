let

  nixpkgs = import ../nixpkgs {};

  srcs = import ../srcs { inherit (nixpkgs) fetchurl; };

  stage0 = import ../stage0;

  config = import ./config.nix { inherit Platform; };

  scope = stage1 // {
    inherit srcs;
    inherit (config) platforms;
    inherit (nixpkgs)
      lib bison bzip2 coreutils dash diffutils findutils gzip lzma patch xz;
    awk = nixpkgs.gawk;
    grep = nixpkgs.gnugrep;
    m4 = nixpkgs.gnum4;
    make = nixpkgs.gnumake;
    sed = nixpkgs.gnused;
    tar = nixpkgs.gnutar;
    inherit (stage0) binutils;
    buildCC = nixpkgs.gcc7;
    targetCC = stage0.gcc;
  };

  Import = import ../../lib/Import.nix scope;
  Platform = import ../../lib/Platform.nix;

  stage1 = rec {
    inherit config;
    Derivation = Import ./Derivation {};
    binutils = Import ./binutils {};
    targetCC = musl.wrapCC stage0.targetCC;
    gmp = Import ./gmp {};
    libstdcxx = Import ./libstdcxx {};
    mpc = Import ./mpc {};
    mpfr = Import ./mpfr {};
    musl = Import ./musl {
      Derivation = Derivation.Import.override {
        # The build environment for musl should contain no libc,
        # because we haven't built one yet. Consequently, the targetCC
        # should be bare.
        libc = null;
        inherit (stage0) targetCC;
      };
    };
    zlib = Import ./zlib {};
  };

in
stage1
