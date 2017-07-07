# Environment

## Standardize locale
LC_ALL=POSIX
export LC_ALL

## Setup Nixpkgs standard environment
. "$stdenv/setup"


# Definitions

unpackTar() {
    if [ -n "$2" ]
    then
        mkdir -p "$2"
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
