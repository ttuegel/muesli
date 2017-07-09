{ nixpkgs, srcs, stage0, stage1, ... }:

let
  inherit (nixpkgs) lib;
  inherit (stage0) binutils gcc;
  inherit (stage1) Derivation;
  build_gcc = nixpkgs.gcc;
  specs = "${musl}/lib/musl-gcc.specs";
  musl =
    Derivation {
      inherit (srcs.musl) name src;
      env = { inherit gcc; };
      buildInputs = [ binutils build_gcc gcc ];
      builder = ./builder.sh;
      passthru = {
        wrapCC = cc:
          Derivation {
            name = "musl-wrapCC-${cc.name}";
            env = { inherit cc specs; };
            builder = ./wrapCC.sh;
          };
      };
    };
in
musl
