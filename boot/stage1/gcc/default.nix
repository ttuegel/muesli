{
  Derivation, platforms, srcs,
  buildBinutils, gmp, libstdcxx, linux-headers, mpc, mpfr, musl, zlib,
}:

Derivation {
  inherit (srcs.gcc) name src;
  env = {
    inherit (musl) nativeHeaders;
    arch = platforms.target.machine;
    hardeningDisable = [ "format" ];
    inherit (srcs.gcc) patches;
  };
  buildInputs = [ buildBinutils ];
  hostInputs = [ gmp libstdcxx linux-headers mpc mpfr musl zlib ];
  builder = ./builder.sh;
}
