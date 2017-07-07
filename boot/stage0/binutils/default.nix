{ srcs, nixpkgs, stage0, ... }:

let
  inherit (nixpkgs) bison;
  inherit (stage0) Derivation;
in

Derivation {
  inherit (srcs.binutils) name src;
  env = { inherit (srcs.binutils) patches; };
  buildInputs = [ bison ];
  builder = ./builder.sh;
}
