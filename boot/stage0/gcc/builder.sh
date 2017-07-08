# Unpack

unpackTar "${src_gcc:?}" gcc
unpackTar "${src_gmp:?}" gcc/gmp
unpackTar "${src_mpc:?}" gcc/mpc
unpackTar "${src_mpfr:?}" gcc/mpfr
cd gcc


# Patch

## Unset standard start file prefix
for f in \
    $(grep '#define STANDARD_STARTFILE_PREFIX_[[:digit:]]' -R -l)
do
    sed -i "$f" \
        -e '/#define STANDARD_STARTFILE_PREFIX_[[:digit:]]/ s|".*"|""|'
done

## Set the default directory for 64-bit libraries to be 'lib' not 'lib64'
case ${arch:?} in
    x86_64)
        sed -i.orig gcc/config/i386/t-linux64 \
            -e '/m64=/ s|lib64|lib|'
        ;;
esac

## Unset the default dynamic linkers
for f in \
    $(grep '#define \(UCLIBC\|GLIBC\|MUSL\)_DYNAMIC_LINKER\(32\|64\|N32\|X32\)\?' -R -l)
do
    sed -i "$f" \
        -e '/#define \(UCLIBC\|GLIBC\|MUSL\)_DYNAMIC_LINKER\(32\|64\|N32\|X32\)\?/ s|".*"|""|'
done


# Configure

mkdir -v build
cd build

../configure \
    --target="${target:?}" \
    --host="${host:?}" \
    --build="${build:?}" \
    --prefix="${out:?}" \
    --with-sysroot="${out:?}" \
    --with-newlib \
    --without-headers \
    --with-local-prefix="${out:?}" \
    --with-native-system-header-dir="${out:?}/include" \
    --disable-nls \
    --disable-shared \
    --disable-multilib \
    --disable-decimal-float \
    --disable-threads \
    --disable-libatomic \
    --disable-libgomp \
    --disable-libmpx \
    --disable-libquadmath \
    --disable-libssp \
    --disable-libvtv \
    --disable-libstdcxx \
    --disable-libsanitizer \
    --enable-languages=c,c++


# Build

make


# Install

make install
