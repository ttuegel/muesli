{ fetchurl }:

{
  binutils = rec {
    name = "binutils-2.28";
    src = fetchurl {
      url = "https://ftp.gnu.org/gnu/binutils/${name}.tar.gz";
      sha256 = "1krgfxnlgjzwfddxfwr0kna94nqy9va5ig8x8l6q87bnzik7jwfd";
    };
    # Patches are shamelessly stolen from Nixpkgs
    patches = [
      # Turn on --enable-new-dtags by default to make the linker set
      # RUNPATH instead of RPATH on binaries.  This is important because
      # RUNPATH can be overriden using LD_LIBRARY_PATH at runtime.
      ./binutils/new-dtags.patch

      # Since binutils 2.22, DT_NEEDED flags aren't copied for dynamic outputs.
      # That requires upstream changes for things to work. So we can patch it to
      # get the old behaviour by now.
      ./binutils/dtneeded.patch

      # Make binutils output deterministic by default.
      ./binutils/deterministic.patch

      # Always add PaX flags section to ELF files.
      # This is needed, for instance, so that running "ldd" on a binary that is
      # PaX-marked to disable mprotect doesn't fail with permission denied.
      ./binutils/pt-pax-flags.patch

      # Bfd looks in BINDIR/../lib for some plugins that don't
      # exist. This is pointless (since users can't install plugins
      # there) and causes a cycle between the lib and bin outputs, so
      # get rid of it.
      ./binutils/no-plugins.patch
    ];
  };
  gcc = rec {
    name = "gcc-7.1.0";
    src = fetchurl {
      url = "https://ftp.gnu.org/gnu/gcc/gcc-7.1.0/${name}.tar.bz2";
      sha256 = "05xwps0ci7wgxh50askpa2r9p8518qxdgh6ad7pnyk7n6p13d0ca";
    };
  };
  gmp = rec {
    name = "gmp-6.1.2";
    src = fetchurl {
      url = "https://gmplib.org/download/gmp/${name}.tar.xz";
      sha256 = "04hrwahdxyqdik559604r7wrj9ffklwvipgfxgj4ys4skbl6bdc7";
    };
  };
  libtool = rec {
    name = "libtool-2.4.6";
    src = fetchurl {
      url = "http://ftpmirror.gnu.org/libtool/${name}.tar.xz";
      sha256 = "0vxj52zm709125gwv9qqlw02silj8bnjnh4y07arrz60r31ai1vw";
    };
    patches = [
      ./libtool/libtool-passthru-flags.patch
    ];
  };
  mpc = rec {
    name = "mpc-1.0.3";
    src = fetchurl {
      url = "ftp://ftp.gnu.org/gnu/mpc/${name}.tar.gz";
      sha256 = "1hzci2zrrd7v3g1jk35qindq05hbl0bhjcyyisq9z209xb3fqzb1";
    };
  };
  mpfr = rec {
    name = "mpfr-3.1.5";
    src = fetchurl {
      url = "http://www.mpfr.org/mpfr-current/${name}.tar.xz";
      sha256 = "1g32l2fg8f62lcyzzh88y3fsh6rk539qc6ahhdgvx7wpnf1dwpq1";
    };
  };
}
