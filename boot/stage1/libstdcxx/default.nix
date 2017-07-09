{ nixpkgs, srcs, stage0, stage1, ... }:

let
  build_gcc = nixpkgs.gcc;
  inherit (stage1) Derivation musl;
  inherit (stage1.config) platforms;
  inherit (builtins.parseDrvName gcc.name) version;
  gcc = musl.wrapCC stage0.gcc;
in

Derivation {
  name = "libstdcxx-${version}";
  inherit (srcs.gcc) src;
  env = {
    arch = platforms.target.machine;
    inherit version;
  };
  buildInputs = [ build_gcc gcc ];
  hostInputs = [ musl ];
  builder = ./builder.sh;
}
