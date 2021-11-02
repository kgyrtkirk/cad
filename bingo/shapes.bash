#!/bin/bash

set -e

a=116

mkdir -p out/s/

for i in `seq 0 5`;do
for c  in white gray yellow red blue lightgreen;do
	x=$[ ($i % 3) * a ]
	y=$[ ($i / 3) * a ]

	convert dice2.jpg -colors 3 -crop ${a}x${a}+$x+$y -trim +repage \
		-fill $c -draw 'color 10,10 floodfill' -colors 256  \
		 out/s/$i.$c.jpg

done
done
#fi

s=30

for k in `seq 1 6`;do
	montage `find out/s -type f |sort -R | head -n 16` -geometry +$s+$s out/a.$k.jpg
done

s=60

montage out/s/*.jpg -geometry ${a}x${a}+$s+$s out/grid.pdf
montage out/a.*.jpg -geometry +$s+$s out/oo.jpg
convert out/oo.jpg out/oo.pdf


#  convert -size 100x60 xc:skyblue -fill white -stroke black \
 #         -draw "circle 50,30 40,10"          draw_circle.gif
