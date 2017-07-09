# Unpack

unpackTar ${src:?} gmp
cd gmp


# Configure

./configure \
    --prefix="${out:?}" \
    --host=${host:?} \
    --target=${target:?}


# Build

make


# Install

make install
