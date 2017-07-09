# Unpack

unpackTar ${src:?} mpc
cd mpc


# Configure

./configure \
    --prefix="${out:?}" \
    --host=${host:?} \
    --target=${target:?}


# Build

make


# Install

make install
