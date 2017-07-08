# Unpack

unpackTar "${src:?}" libtool
cd libtool


# Patch

for p in ${patches}
do
    patch --verbose -p1 < "${p:?}"
done


# Configure

./configure \
    --prefix="${out:?}" \
    --host="${host:?}" \
    --build="${build:?}"


# Build

make


# Install

make install
