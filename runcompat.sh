#!/bin/bash

test $# == 5 || echo USAGE: directory filename gene versus support

dir=$1
f=$2
x=$3
all=$4
supp=$5

if [ "$supp" == "" ]; then 
  temp=$dir/$x/$f
else
  temp=`mktemp /tmp/temp.XXXXXX`
  python $BINNING_HOME/remove_edges_from_tree.py $dir/$x/$f $supp $temp -strip-both
fi

$BINNING_HOME/compareTrees.compatibility $temp $all |paste -d " " $all.order - | sed -e "s/"$dir."/"$x" /g" -e "s/\/[^ ]* / /g"
