#!/bin/bash

set -e

echo "Install build dependencies..."
brew install autoconf automake libtool pkg-config curl git doxygen nasm bison wget gettext gh
echo "Dependencies ok!"
echo "1 done!"