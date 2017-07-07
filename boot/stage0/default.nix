let
  nixpkgs = import ../nixpkgs {};
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
  };
in
stage0
