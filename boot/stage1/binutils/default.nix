{ srcs, nixpkgs, stage0, stage1, ... }:

let
  inherit (nixpkgs) bison diffutils patch;
  inherit (stage1) Derivation libstdcxx musl;
  build_gcc = nixpkgs.gcc;
  gcc = musl.wrapCC stage0.gcc;
in

Derivation {
  inherit (srcs.binutils) name src;
  env = { inherit (srcs.binutils) patches; };
  buildInputs = [ bison build_gcc diffutils gcc patch ];
  hostInputs = [ libstdcxx musl ];
  builder = ./builder.sh;
}
