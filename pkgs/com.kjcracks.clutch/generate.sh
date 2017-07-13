#!/usr/bin/env bash
# Remove development team and disable code signing
# cd to dir with Clutch.xcproject and run this script

VERSION="$(git describe --long --tags)"
echo "Packaging Clutch $VERSION"

tmpdir="$(mktemp -d)"
xcodebuild build CONFIGURATION_BUILD_DIR="$tmpdir/build" >/dev/null 2>&1
cp Clutch/Clutch.entitlements "$tmpdir/Clutch.entitlements"

pushd "$tmpdir"

mkdir -p deb/DEBIAN

# Depends: zip is removed since minizip is statically linked
cat>deb/DEBIAN/control <<EOF1
Package: com.KJCracks.Clutch
Name: Clutch
Version: $VERSION
Architecture: iphoneos-arm
Description: Fast cracking utility for iPhone, iPod and iPad
Maintainer: Viktor Oreshkin (stek29) <cy@stek29.rocks>
Author: Kim Jong Cracks
Section: Utilities
EOF1

fakeroot /bin/bash <<EOF2
mkdir -p deb/usr/bin
cp build/Clutch.app/Clutch .
ldid -SClutch.entitlements Clutch
mv Clutch deb/usr/bin
dpkg-deb -Zlzma -b deb out.deb
EOF2

popd

mv "$tmpdir/out.deb" "com.kjcracks.clutch-$VERSION.deb"
