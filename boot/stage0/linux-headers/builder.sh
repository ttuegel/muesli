# Unpack

unpackTar "${src:?}" linux
cd linux


# Install

make INSTALL_HDR_PATH="${out:?}" headers_install
