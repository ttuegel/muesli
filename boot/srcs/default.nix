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
}
