{ nixpkgs, srcs, stage0, stage1, ... }:

let
  inherit (nixpkgs) autoconf automake;
  build_gcc = nixpkgs.gcc;
  inherit (stage0) binutils gcc libtool;
  inherit (stage1) Derivation musl;
  inherit (stage1.config) platforms;
  inherit (builtins.parseDrvName gcc.name) version;
in

Derivation {
  name = "libstdcxx-${version}";
  inherit (srcs.gcc) src;
  env = {
    arch = platforms.target.machine;
    inherit version;
  };
  buildInputs = [ autoconf automake binutils build_gcc gcc libtool ];
  hostInputs = [ musl ];
  builder = ./builder.sh;
}
