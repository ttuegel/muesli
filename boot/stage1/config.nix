{ Platform }:

{
  platforms = rec {
    build = Platform {
      machine = "x86_64";
      vendor = "pc";
      os = "linux";
      flavor = "gnu";
    };
    host = target;
    target = Platform {
      machine = "x86_64";
      vendor = "boot";
      os = "linux";
      flavor = "musl";
    };
  };
}
