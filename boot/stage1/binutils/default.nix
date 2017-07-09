{
  Derivation, srcs,
  bison, libstdcxx, musl,
}:

Derivation {
  inherit (srcs.binutils) name src;
  env = { inherit (srcs.binutils) patches; };
  buildInputs = [ bison ];
  hostInputs = [ libstdcxx musl ];
  builder = ./builder.sh;
}
