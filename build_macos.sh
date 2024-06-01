#!/usr/bin/env bash
set -ex

brew install libvpx webp
mkdir -p build

export ZMUSIC_PACKAGE=zmusic-1.1.9-macos.tar.xz

if [[ -n "${ZMUSIC_PACKAGE}" ]]; then
  pushd build
    curl -LO "https://github.com/coelckers/gzdoom/releases/download/ci_deps/${ZMUSIC_PACKAGE}"
    tar -xf "${ZMUSIC_PACKAGE}"
  popd
fi

# Need to turn off OSX_COCOA_BACKEND for Selaco, it changes some stuff in the
# opengl renderer.
cmake -B build -DCMAKE_BUILD_TYPE=Release "-DCMAKE_PREFIX_PATH=$PWD/build/zmusic" -DPK3_QUIET_ZIPDIR=ON -DOSX_COCOA_BACKEND=OFF .
export MAKEFLAGS=--keep-going
cmake --build build --config Release --parallel 3
