{
  Derivation, srcs,
  gmp, mpfr, musl,
}:

Derivation {
  inherit (srcs.mpc) name src;
  hostInputs = [ gmp mpfr musl ];
  builder = ./builder.sh;
}
