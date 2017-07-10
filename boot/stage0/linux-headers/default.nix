{ srcs, stage0, ... }:

let
  inherit (stage0) Derivation;
  name = "linux-headers-${(builtins.parseDrvName srcs.linux.name).version}";
in

Derivation {
  inherit name;
  inherit (srcs.linux) src;
  builder = ./builder.sh;
}
