{ nixpkgs, srcs, stage0, stage1, ... }:

let
  inherit (stage1) Derivation gmp mpfr musl;
  build_gcc = nixpkgs.gcc;
  gcc = musl.wrapCC stage0.gcc;
in

Derivation {
  inherit (srcs.mpc) name src;
  buildInputs = [ build_gcc gcc ];
  hostInputs = [ gmp mpfr musl ];
  builder = ./builder.sh;
}
