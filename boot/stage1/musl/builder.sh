# Unpack

unpackTar "${src:?}" musl
cd musl


# Configure

./configure \
    --prefix="${out:?}" \
    --syslibdir="${out:?}/lib" \
    --target=${target:?} \
    --host=${host:?} \
    --build=${build:?}


# Build

make


# Install

make install
