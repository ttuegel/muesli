{ srcs, Derivation }:

let
  specs = "${musl}/lib/musl-gcc.specs";
  wrapCC = cc:
    Derivation {
      name = "musl-wrapCC-${cc.name}";
      env = { inherit cc specs; };
      builder = ./wrapCC.sh;
    };
  musl =
    Derivation {
      inherit (srcs.musl) name src;
      builder = ./builder.sh;
      passthru = { inherit wrapCC; };
    };
in
musl
