{ Derivation, srcs, platforms, musl, }:

let
  inherit (builtins.parseDrvName srcs.gcc.name) version;
in

Derivation {
  name = "libstdcxx-${version}";
  inherit (srcs.gcc) src;
  env = {
    arch = platforms.target.machine;
    inherit version;
  };
  hostInputs = [ musl ];
  builder = ./builder.sh;
}
