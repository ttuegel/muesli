{ config, nixpkgs, stage0 }:

let
  inherit (nixpkgs) coreutils dash gzip lib make sed tar;
  inherit (stage0) binutils gcc;
  inherit (config) platforms;
in

let
  defaultBuildInputs = [ binutils coreutils dash gcc gzip make sed tar ];
in

{
  name,
  builder,
  src ? null,
  srcs ? {},
  env ? {},
  buildInputs ? [],
  hostInputs ? [],
}:

# Accept either src or srcs, but not both
assert (src != null) -> (srcs == {});
assert (srcs != {}) -> (src == null);

let
  srcs_ =
    let
      toEnv = name: value: { name = "src_${name}"; inherit value; };
    in
      if src == null
      then lib.mapAttrs' toEnv srcs
      else { inherit src; };
in

# Reject env if it would override arguments to mkDerivation
assert !(lib.hasAttr "name" env);
assert !(lib.hasAttr "builder" env);
assert !(lib.hasAttr "args" env);
assert !(lib.hasAttr "nativeBuildInputs" env);
assert !(lib.hasAttr "buildInputs" env);
assert !(lib.hasAttr "hostInputs" env);
assert !(lib.any (name: lib.hasAttr name env) (lib.attrNames srcs_));

derivation (env // srcs_ // {
  name = "stage1-${name}";
  system = "${platforms.build.machine}-${platforms.build.os}";
  target = platforms.target.string;
  host = platforms.host.string;
  build = platforms.build.string;
  buildInputs = defaultBuildInputs ++ buildInputs;
  inherit hostInputs;
  builder = "${dash}/bin/dash";
  args = [ ./builder.sh builder ];
})
