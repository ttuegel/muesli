# Unpack

unpackTar ${src:?} mpfr
cd mpfr


# Configure

./configure \
    --prefix="${out:?}" \
    --host=${host:?} \
    --target=${target:?}


# Build

make


# Install

make install
