let

  nixpkgs = import ../nixpkgs {};

  srcs = import ../srcs { inherit (nixpkgs) fetchurl; };

  stage0 = import ../stage0;

  config = import ./config.nix { inherit Platform; };

  scope = stage1 // {
    inherit srcs;
    inherit (config) platforms;
    inherit (nixpkgs)
      lib bison bzip2 coreutils dash diffutils gzip lzma patch xz;
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

  Derivation = extra: Import ./Derivation extra;

  musl = Import ./musl { Derivation = Derivation {}; };

  stage1 = {
    inherit config musl;
    Derivation = Derivation { libc = musl; };
    binutils = Import ./binutils {};
    gmp = Import ./gmp {};
    libstdcxx = Import ./libstdcxx {};
    mpc = Import ./mpc {};
    mpfr = Import ./mpfr {};
  };

in
stage1
