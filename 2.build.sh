#!/bin/bash
set -e

export BASEDIR="$(pwd)"
source "${BASEDIR}"/config.sh

if [[ ! -d $WORK_DIR ]]; then
  echo "Cloning ffmpeg-kit repository..."
  mkdir .tmp/ || true
  cd .tmp/
  git clone $FFMPEG_KIT_REPO
  cd ../
fi

echo "Checking out $FFMPEG_KIT_CHECKOUT..."
cd $WORK_DIR
git fetch
git fetch --tags
git checkout $FFMPEG_KIT_CHECKOUT

echo "Building for iOS..."
./ios.sh --enable-ios-audiotoolbox --enable-ios-avfoundation --enable-ios-videotoolbox --enable-ios-zlib --enable-ios-bzip2 -x
# echo "Building for tvOS..."
# ./tvos.sh --enable-tvos-audiotoolbox --enable-tvos-videotoolbox --enable-tvos-zlib --enable-tvos-bzip2 -x
# echo "Building for macOS..."
# ./macos.sh --enable-macos-audiotoolbox --enable-macos-avfoundation --enable-macos-bzip2 --enable-macos-videotoolbox --enable-macos-zlib --enable-macos-coreimage --enable-macos-opencl --enable-macos-opengl -x
# echo "Building for watchOS..."
#./watchos.sh --enable-watchos-zlib --enable-watchos-bzip2 -x

echo "Bundling final XCFramework"
./apple.sh --disable-watchos --disable-watchsimulator

echo "2 done!"
