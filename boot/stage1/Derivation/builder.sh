# Environment

## Show each command
set -x

## Standardize locale
LC_ALL=POSIX
export LC_ALL

## Set PATH
PATH=
for inp in $buildInputs
do
    for dir in bin sbin
    do
        if [ -d "$inp/$dir" ]; then
            PATH="${PATH}${PATH:+:}$inp/$dir";
        fi
    done
done
export PATH

## Set CPPFLAGS
CPPFLAGS=

for inp in $buildInputs
do
    if [ -e "$inp/config/build/CPPFLAGS" ]; then
        CPPFLAGS="${CPPFLAGS}${CPPFLAGS:+ }$(cat $inp/config/build/CPPFLAGS)"
    fi
done

for inp in $hostInputs
do
    if [ -e "$inp/config/host/CPPFLAGS" ]; then
        CPPFLAGS="${CPPFLAGS}${CPPFLAGS:+ }$(cat $inp/config/host/CPPFLAGS)"
    elif [ -d "$inp/include" ]; then
        CPPFLAGS="${CPPFLAGS}${CPPFLAGS:+ }-I$inp/include"
    fi
done

export CPPFLAGS

## Set LDFLAGS
LDFLAGS=

for inp in $buildInputs
do
    if [ -e "$inp/config/build/LDFLAGS" ]; then
        LDFLAGS="${LDFLAGS}${LDFLAGS:+ }$(cat $inp/config/build/LDFLAGS)"
    fi
done

for inp in $hostInputs
do
    if [ -e "$inp/config/host/LDFLAGS" ]; then
        LDFLAGS="${LDFLAGS}${LDFLAGS:+ }$(cat $inp/config/host/LDFLAGS)"
    elif [ -d "$inp/lib" ]; then
        LDFLAGS="${LDFLAGS}${LDFLAGS:+ }-L$inp/lib"
    fi
done

export LDFLAGS

## Set CFLAGS
CFLAGS=

for inp in $buildInputs
do
    if [ -e "$inp/config/build/CFLAGS" ]; then
        CFLAGS="${CFLAGS}${CFLAGS:+ }$(cat $inp/config/build/CFLAGS)"
    fi
done

for inp in $hostInputs
do
    if [ -e "$inp/config/host/CFLAGS" ]; then
        CFLAGS="${CFLAGS}${CFLAGS:+ }$(cat $inp/config/host/CFLAGS)"
    fi
done

CFLAGS="${CPPFLAGS}${CPPFLAGS:+ }${CFLAGS}${CFLAGS:+ }${LDFLAGS}"
export CFLAGS

## Set CXXFLAGS
CXXFLAGS=

for inp in $buildInputs
do
    if [ -e "$inp/config/build/CXXFLAGS" ]; then
        CXXFLAGS="${CXXFLAGS}${CXXFLAGS:+ }$(cat $inp/config/build/CXXFLAGS)"
    fi
done

for inp in $hostInputs
do
    if [ -e "$inp/config/host/CXXFLAGS" ]; then
        CXXFLAGS="${CXXFLAGS}${CXXFLAGS:+ }$(cat $inp/config/host/CXXFLAGS)"
    fi
done

CXXFLAGS="${CPPFLAGS}${CPPFLAGS:+ }${CXXFLAGS}${CXXFLAGS:+ }${LDFLAGS}"
export CXXFLAGS

## Target build tools
AR=${target:?}-ar; export AR
AS=${target:?}-as; export AS
LD=${target:?}-ld; export LD
NM=${target:?}-nm; export NM
OBJCOPY=${target:?}-objcopy; export OBJCOPY
OBJDUMP=${target:?}-objdump; export OBJDUMP
RANLIB=${target:?}-ranlib; export RANLIB


# Definitions

unpackTar() {
    if [ -n "$2" ]
    then
        mkdir -pv "$2"
        tar xaf "$1" -C "$2" --strip-components=1
    else
        tar xaf "$1"
    fi
}


# Build

## Load each builder in sequence
while [ "$#" -gt 0 ]
do
    . "$1"
    shift
done
