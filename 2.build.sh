#!/bin/bash
set -e

source "$(pwd)/config.sh"

if [[ ! -d $WORK_DIR ]]; then
  echo "Cloning ffmpeg-kit repository..."
  mkdir src/ || true
  cd src/
  git clone $FFMPEG_KIT_REPO
  cd ../
fi

echo "Checking out $FFMPEG_KIT_CHECKOUT..."
cd $WORK_DIR
git fetch
git fetch --tags
git checkout $FFMPEG_KIT_CHECKOUT

echo "Building for iOS..."
sudo ./ios.sh -x -s \
    --enable-ios-audiotoolbox --enable-ios-avfoundation --enable-ios-videotoolbox --enable-ios-zlib --enable-ios-bzip2 --enable-dav1d --enable-fontconfig --enable-freetype --enable-fribidi --enable-openh264 --enable-openssl --enable-sdl \
    --disable-armv7 --disable-armv7s --disable-i386 --disable-x86-64-mac-catalyst --disable-arm64-mac-catalyst \
    --enable-gpl --enable-x264 --enable-x265 --enable-libvidstab
# echo "Building for tvOS..."
# ./tvos.sh --enable-tvos-audiotoolbox --enable-tvos-videotoolbox --enable-tvos-zlib --enable-tvos-bzip2 -x
# echo "Building for macOS..."
# ./macos.sh --enable-macos-audiotoolbox --enable-macos-avfoundation --enable-macos-bzip2 --enable-macos-videotoolbox --enable-macos-zlib --enable-macos-coreimage --enable-macos-opencl --enable-macos-opengl -x
# echo "Building for watchOS..."
#./watchos.sh --enable-watchos-zlib --enable-watchos-bzip2 -x

echo "Bundling final XCFramework"
sudo ./apple.sh --disable-appletvos --disable-appletvsimulator --disable-macosx --disable-mac-catalyst

cd ../../

echo "2 done"