{ Derivation, srcs, musl, }:

Derivation {
  inherit (srcs.zlib) name src;
  hostInputs = [ musl ];
  builder = ./builder.sh;
}
