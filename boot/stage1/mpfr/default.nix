{ Derivation, srcs, gmp, musl, }:

Derivation {
  inherit (srcs.mpfr) name src;
  hostInputs = [ gmp musl ];
  builder = ./builder.sh;
}
