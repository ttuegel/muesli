{ nixpkgs, srcs, stage0, stage1, ... }:

let
  inherit (stage1) Derivation gmp musl;
  build_gcc = nixpkgs.gcc;
  gcc = musl.wrapCC stage0.gcc;
in

Derivation {
  inherit (srcs.mpfr) name src;
  buildInputs = [ build_gcc gcc ];
  hostInputs = [ gmp musl ];
  builder = ./builder.sh;
}
