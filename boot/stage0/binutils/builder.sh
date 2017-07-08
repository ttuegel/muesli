# Unpack

unpackTar "${src:?}" binutils
cd binutils


# Patch

for p in ${patches}
do
    patch --verbose -p1 < "${p:?}"
done

## Unset the default library path
echo 'NATIVE_LIB_DIRS=' >> ld/configure.tgt

## Use symbolic links (instead of hard links) to save space
for d in binutils gas ld gold
do
    sed -i "${d:?}/Makefile.in" -e 's|ln |ln -s |'
done


# Configure

mkdir -v build
cd build

../configure \
    --prefix="${out:?}" \
    --target="${target:?}" \
    --host="${host:?}" \
    --build="${build:?}" \
    --enable-deterministic-archives \
    --disable-shared \
    --disable-nls \
    --disable-werror


# Build

make


# Install

make install
