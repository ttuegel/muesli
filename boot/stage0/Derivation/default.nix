{ config, nixpkgs }:

let
  inherit (nixpkgs) stdenv lib;
  inherit (config) platforms;
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

stdenv.mkDerivation (env // srcs_ // {
  name = "stage0-${name}";
  system = "${platforms.build.machine}-${platforms.build.os}";
  target = platforms.target.string;
  host = platforms.host.string;
  build = platforms.build.string;
  nativeBuildInputs = buildInputs;
  inherit hostInputs;
  builder = stdenv.shell;
  args = [ ./builder.sh builder ];
})
