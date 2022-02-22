#!/bin/bash
set -e
[ ! -e $1 ] && echo "use: $0 file MAIN " && exit 1


declare -A parts


function add() {
	old=${parts[$1]}
	parts[$1]="$old $2"
}

function x() {
	name="$1"
	shift
	spec="$*"
	add	"$spec"	"$name"
}

cat "$1" |grep "$2"|tr '*;"' '  '|awk '{print $4,$5,$6,$7,$8,$9,$10}'|tr ' ' '\t'|sort > _tmp

while read line;do
	x $line
done <_tmp

for k in "${!parts[@]}";do
	names="${parts[$k]}"
	p="`echo $names| tr ' ' '\n' |sort| uniq -c|tr '\n' ','`"
	firstName="`echo $names|tr ' ' '\n'|head -n1`"
	n="`echo $names| tr ' ' '\n' |wc -l`"
	echo "$n $k $firstName $p"
done

