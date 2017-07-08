let
  nixpkgs =
    let _pkgs = import ../nixpkgs {}; in {
      inherit (_pkgs) bison fetchurl help2man lib stdenv;
      m4 = _pkgs.gnum4;
    };
  srcs = import ../srcs { inherit (nixpkgs) fetchurl; };
  config = import ./config.nix {
    Platform = import ../../lib/Platform.nix;
  };
  Derivation = import ./Derivation { inherit config nixpkgs; };
  Package = file: import file { inherit nixpkgs srcs stage0; };
  stage0 = {
    inherit Derivation config;
    binutils = Package ./binutils;
    gcc = Package ./gcc;
    libtool = Package ./libtool;
  };
in
stage0
