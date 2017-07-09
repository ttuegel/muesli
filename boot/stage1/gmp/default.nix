{ Derivation, srcs, musl, }:

Derivation {
  inherit (srcs.gmp) name src;
  hostInputs = [ musl ];
  builder = ./builder.sh;
}
