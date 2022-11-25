#!/bin/bash

set -e

while getopts "a:" opt; do
  case $opt in
    a)
      ARCH=$OPTARG ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [[ -z "${ARCH}" ]] ; then
  echo 'You need to input arch with -a ARCH.'
  echo 'Supported archs are:'
  echo -e '\tarm arm64 x86 x86_64'
  exit 1
fi

source ../../AVP/android-setup-light.sh

LOCAL_PATH=$($READLINK -f .)

case "${ARCH}" in
  'arm')
    ABI='armeabi-v7a' ;;
  'arm64')
    ABI='arm64-v8a' ;;
  'x86')
    ABI='x86' ;;
  'x86_64')
    ABI='x86_64' ;;
  *)
    echo "Arch ${ARCH} is not supported."
    exit 1 ;;
esac

if [ ! -d libtorrent ]; then
  git clone --recursive https://github.com/arvidn/libtorrent -b v2.0.8
fi

cd libtorrent

export BOOST_VERSION=1_80_0

export BOOST_ROOT=${REPO_TOP_DIR}/native/boost/boost_${BOOST_VERSION}
BOOST=boost_${BOOST_VERSION}

echo BOOST_ROOT $BOOST_ROOT

export BOOST_BUILD_PATH=$REPO_TOP_DIR/native/boost/boost_${BOOST_VERSION}-${ABI}

echo BOOST_BUILD_PATH $BOOST_BUILD_PATH

$BOOST_ROOT/b2 \
    --build-dir=../../boost/${BOOST}-${ABI} \
    --stagedir=../../boost/${BOOST}-${ABI}/stage \
    --user-config=../../boost/${BOOST}-${ABI}/user-config.jam \
    openssl-lib=${REPO_TOP_DIR}/native/openssl-android-builder/dist-${ABI}/lib \
    openssl-include=${REPO_TOP_DIR}/native/openssl-android-builder/dist-${ABI}/include \
    crypto=openssl \
    cxxstd=14 \
    binary-format=elf \
    variant=release \
    threading=multi \
    threadapi=pthread \
    toolset=clang-android \
    link=static \
    runtime-link=static \
    target-os=android \
    release \
    -j8

echo "Done!"
