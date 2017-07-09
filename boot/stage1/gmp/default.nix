{ nixpkgs, srcs, stage0, stage1, ... }:

let
  inherit (stage1) Derivation musl;
  build_gcc = nixpkgs.gcc;
  gcc = musl.wrapCC stage0.gcc;
in

Derivation {
  inherit (srcs.gmp) name src;
  buildInputs = [ build_gcc gcc ];
  hostInputs = [ musl ];
  builder = ./builder.sh;
}
