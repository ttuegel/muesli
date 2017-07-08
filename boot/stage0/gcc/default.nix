{ srcs, stage0, ... }:

let
  inherit (stage0) Derivation config binutils;
  inherit (config) platforms;
in

Derivation {
  inherit (srcs.gcc) name;
  srcs = {
    gcc = srcs.gcc.src;
    gmp = srcs.gmp.src;
    mpc = srcs.mpc.src;
    mpfr = srcs.mpfr.src;
  };
  env = {
    arch = platforms.target.machine;
    hardeningDisable = [ "format" ];
  };
  buildInputs = [ binutils ];
  builder = ./builder.sh;
}
