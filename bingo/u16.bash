#!/bin/bash

set -e

a=116

mkdir -p out/s/

function gen() {
	idx=$1
	label=$2
	color=white
	num=1

	stroke=10
	a=200
	b=400
	c=600
	r=80
	w=800
	ps=600
	m=$[ $w * 1 / 20 ]
	n=$[ $w * 19 / 20 ]

	args="convert -size ${w}x${w} xc:white "
	args+=" -fill $color -stroke black -strokewidth $stroke "
	args+=" -draw 'roundrectangle $m,$m $n,$n $r,$r' "
	args+=" -fill black -stroke black -strokewidth 0"
	args+=" -font 'Symbola' -pointsize ${ps} -gravity center -draw 'text 0,0 \"${label}\"'"
	args+=" -scale 20% out/s/${idx}.png"
	eval $args

	# convert -background pink -font 'Symbola' -pointsize 60 -stroke black label:"\
# 🚀🍒🍕🌙🌟🌂🌣🏠🏀🏁🎥🎤🐌🐝👓👻💰💡📖📎📐🖂🖶🗼🌡🍰🍭🚁🚂🚜🛀🚴🛒🛪🛢🛸🛥🚽🛷🥕🥄🤘🌲🌧🌎🍉🎡🎜🎖🎸🎺🎱💊💔📞" trademark.png

}

labels=( 🚀 🍒 🍕 🌙 🌟 🌂 🌣 🏠 🏀 🏁 🎥 🎤 🐌 🐝 👓 👻 💰 💡 📖 📎 📐 🖂 
🖶 🗼 🌡 🍰 🍭 🚁 🚂 🚜 🛀 🚴 🛒 🛪 🛢 🛸 🛥 🚽 🛷 🥕 🥄 🤘 🌲 🌧 🌎 🍉 🎡 🎜 🎖 🎸 🎺 🎱 
💊 💔 📞)

#convert -background pink -font 'Symbola' -pointsize 60 -stroke black "label:`echo "${labels[@]}"|tr -d ' '`" out/preview.png
#convert -background pink -font 'Monospace' -pointsize 60 -stroke black "label:`echo "${labels[@]}"|tr -d ' '`" out/preview.png
#exit

for((i=0;i<${#labels[@]};i++));do
	gen $i "${labels[i]}"
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


