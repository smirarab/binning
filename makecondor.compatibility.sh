#!/bin/bash

echo USAGE: directory support outdirectory filename
test $# == 4 || exit 1

dir=$1
support=$2
out=$3
f=$4 
cfile=condor.compat.$support.`echo $dir|sed -e "s:/:_:g"`

mkdir -p $out

pd=`pwd`
all=`mktemp temp.XXXXX`
ls $dir/*/$f>$all.order
cat $all.order|xargs cat > $all.full

python $BINNING_HOME/remove_edges_from_tree.py $all.full $support $all -strip-both

echo "+Group = \"GRAD\"
+Project = \"COMPUTATIONAL_BIOLOGY\"
+ProjectDescription = \"Binning\"

Universe = vanilla

Requirements = Arch == \"X86_64\" 

executable = $BINNING_HOME/runcompat.sh

Log = logs/$cfile-$support.log

getEnv=True 
">$cfile

for x in `ls $dir`; do
    echo "
 Arguments = $dir $f $x $all $support
 Error=/dev/null
 Output=$out/$x.$support
 Queue">>$cfile
done
