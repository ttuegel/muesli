# Unpack

unpackTar "${src:?}" gcc
cd gcc


# Configure

mkdir -v build
cd build

gxx_include_dir="${out:?}/${target:?}/include/c++/${version:?}"

../libstdc++-v3/configure \
    --prefix="${out:?}" \
    --target=${target:?} \
    --host=${host:?} \
    --build=${build:?} \
    --disable-multilib \
    --disable-nls \
    --disable-libstdcxx-threads \
    --disable-libstdcxx-pch \
    --with-gxx-include-dir="$gxx_include_dir"


# Build

make


# Install

make install


# Fixup

mkdir -p "${out:?}/config/host"

echo "-isystem $gxx_include_dir" \
     "-isystem $gxx_include_dir/${target:?}" \
     "-isystem $gxx_include_dir/backward" \
     >> "${out:?}/config/host/CPPFLAGS"
