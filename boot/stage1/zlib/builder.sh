# Unpack

unpackTar "${src:?}" zlib
cd zlib


# Configure

./configure --prefix="${out:?}"


# Build

make


# Install

make install
