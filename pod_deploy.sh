#!/bin/bash
read -e -p "What version are you deploying? " ver
git add -A && git commit -m "Release $ver."
git tag "$ver"
git push --tags
pod trunk push ZamzamKit.podspec