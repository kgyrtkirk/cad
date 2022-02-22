#!/bin/bash
set -e
[ ! -e $1 ] && echo "use: $0 file MAIN " && exit 1

cat "$1" |grep "$2"|sort|uniq -c|tr '*;"' '  '|awk '{print "x",$5,$1,$6,$7,$8,$9,$10,$11}'|tr ' ' '\t'
