#!/bin/bash

set -e

SET=${SET:-out/s}

a=400
s=30
ss=60

rm -rf out/doc out/page
mkdir -p out/page out/doc
for x in `seq 1 10`;do
	echo "o$x"
	for k in `seq 1 6`;do
		montage `find $SET -type f |sort -R | head -n 16` -geometry +$s+$s out/page/a.$k.jpg
	done
	montage out/page/a.* -frame $s -geometry +$ss+$ss out/doc/o$x.jpg
done

s=60

convert out/doc/* out/all.pdf

montage ${SET}/* -geometry ${a}x${a}+$s+$s out/grid.pdf
