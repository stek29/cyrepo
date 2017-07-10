#!/usr/bin/env bash
dpkg-scanpackages -m pkgs >Packages
bzip2 -kzf Packages

sed -i '/^MD5Sum:$/q' Release
for f in Packages Packages.bz2; do
  printf '  %s %s %s\n'\
    "$(md5sum $f | cut -c -32)"\
    "$(stat --format=%s $f)"\
    "$f"\
    >>Release
done

