let
  nixpkgs =
    let _pkgs = import ../nixpkgs {}; in rec {
      inherit (_pkgs)
        bison bzip2 coreutils dash diffutils fetchurl gcc gzip help2man lib lzma
        patch xz;
      awk = _pkgs.gawk;
      grep = _pkgs.gnugrep;
      m4 = _pkgs.gnum4;
      make = _pkgs.gnumake;
      sed = _pkgs.gnused;
      tar = _pkgs.gnutar;
    };
  srcs = import ../srcs { inherit (nixpkgs) fetchurl; };
  config = import ./config.nix {
    Platform = import ../../lib/Platform.nix;
  };
  stage0 = import ../stage0;
  Derivation = import ./Derivation { inherit config nixpkgs stage0; };
  Package = file: import file { inherit nixpkgs srcs stage0 stage1; };
  stage1 = {
    inherit Derivation config;
    binutils = Package ./binutils;
    gmp = Package ./gmp;
    libstdcxx = Package ./libstdcxx;
    musl = Package ./musl;
  };
in
stage1
