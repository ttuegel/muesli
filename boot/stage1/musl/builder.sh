# Unpack

unpackTar "${src:?}" musl
cd musl


# Patch

## Don't assume sh is in PATH
sed -i Makefile -e 's|\tsh |\tdash |'


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
make "${out:?}/lib/musl-gcc.specs"
