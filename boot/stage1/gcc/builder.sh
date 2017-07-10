# Unpack

unpackTar "${src:?}" gcc
cd gcc


# Patch

for p in ${patches}
do
    patch --verbose -p1 < "${p:?}"
done

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

## Out-of-tree build
mkdir -v build
cd build

## Initialize target compiler flags
if [ "${host:?}" = "${target:?}" ]; then
    CFLAGS_FOR_TARGET="${CFLAGS}"; export CFLAGS_FOR_TARGET
    CXXFLAGS_FOR_TARGET="${CXXFLAGS}"; export CXXFLAGS_FOR_TARGET
    CPPFLAGS_FOR_TARGET="${CPPFLAGS}"; export CPPFLAGS_FOR_TARGET
    LDFLAGS_FOR_TARGET="${LDFLAGS}"; export LDFLAGS_FOR_TARGET
fi

../configure \
    --target="${target:?}" \
    --host="${host:?}" \
    --build="${build:?}" \
    --prefix="${out:?}" \
    --with-local-prefix="${out:?}" \
    --with-native-system-header-dir="${nativeHeaders:?}" \
    --with-system-zlib \
    --disable-nls \
    --disable-multilib \
    --disable-bootstrap \
    --disable-libstdcxx-pch \
    --disable-libgomp \
    --enable-languages=c,c++


# Build

make


# Install

make install
