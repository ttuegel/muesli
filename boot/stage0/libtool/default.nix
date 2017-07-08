{ nixpkgs, srcs, stage0, ... }:

let
  inherit (nixpkgs) help2man m4;
  inherit (stage0) Derivation;
in

Derivation {
  inherit (srcs.libtool) name src;
  env = { inherit (srcs.libtool) patches; };
  buildInputs = [ help2man m4 ];
  builder = ./builder.sh;
}
