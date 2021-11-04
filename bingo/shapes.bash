#!/bin/bash

set -e

a=116

mkdir -p out/s/

function gen() {
	color=$1
	num=$2

	stroke=10
	a=200
	b=400
	c=600
	r=80
	w=800
	m=$[ $w * 1 / 20 ]
	n=$[ $w * 19 / 20 ]
	case $num in
		1)	pp="$b,$b";		;;
		2)	pp="$a,$a $c,$c";	;;
		3)	pp="$a,$a $b,$b $c,$c";	;;
		4)	pp="$a,$a $a,$c $c,$a $c,$c";	;;
		5)	pp="$a,$a $a,$c $c,$a $c,$c $b,$b";	;;
		6)	pp="$a,$a $a,$c $c,$a $c,$c $a,$b $c,$b";	;;
	esac

	args="convert -size ${w}x${w} xc:white "
	args+=" -fill $color -stroke black -strokewidth $stroke "
	args+=" -draw 'roundrectangle $m,$m $n,$n $r,$r' "
	args+=" -fill black -stroke black -strokewidth 0"
	for p in $pp;do
		q="$[ ${p//,*} + $r ],${p//*,}"
		args+=" -draw 'circle $p $q'"
	done

	args+=" -scale 20% out/s/${num}.${color}.png"
	eval $args
}

for i in `seq 1 6`;do
for c  in white gray yellow red blue lightgreen;do
	gen $c $i
done
done

s=30

for x in `seq 1 6`;do
	echo "o$x"
	for k in `seq 1 6`;do
		montage `find out/s -type f |sort -R | head -n 16` -geometry +$s+$s out/a.$k.jpg
	done
	montage out/a.* -frame $s -geometry +$s+$s out/o$x.pdf
done

s=60

montage out/s/* -geometry ${a}x${a}+$s+$s out/grid.pdf


#  convert -size 100x60 xc:skyblue -fill white -stroke black \
#         -draw "circle 50,30 40,10"          draw_circle.gif
