{ nixpkgs, srcs, stage0, stage1, ... }:

let
  inherit (stage0) binutils gcc;
  inherit (stage1) Derivation;
  build_gcc = nixpkgs.gcc;
in

Derivation {
  inherit (srcs.musl) name src;
  buildInputs = [ binutils build_gcc gcc ];
  builder = ./builder.sh;
}
