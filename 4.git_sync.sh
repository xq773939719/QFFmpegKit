#!/bin/bash
set -e

source "$(pwd)/config.sh"

echo "Committing Changes..."
git add -u
git commit -m "Creating release for $FFMPEG_KIT_TAG"

echo "Creating Tag..."
git tag $FFMPEG_KIT_TAG
git push -f
git push origin --tags -f