#!/bin/bash

echo "USAGE: bindir align_home[full_path]"
test $# -gt 1 || exit 1

BINDIR=$1
GENEDIR="$2"
OUTDIR="$3"
OUTFILE="supergene"

EXT=fasta

mkdir -p $OUTDIR
OUTDIR=$(cd $(dirname $OUTDIR); pwd)/$(basename $OUTDIR)

for y in `wc -l $BINDIR/bin*txt|grep -v total|awk '{if ($1==1)print $2}'`; do 
  x=`echo $y|sed -e "s/.*bin/bin/g"`
  g=`cat $y`
  mkdir $OUTDIR/$x
  echo $g > $OUTDIR/$x/$OUTFILE.part
  ln -fs $GENEDIR/$g/$g.$EXT $OUTDIR/$x/$OUTFILE.fasta
  echo WARNING: bin of size 1: $x. You might want to use your existing gene tree 
  # ln -fs $GENEDIR/$g/raxmlboot.gtrgamma.unpart $OUTDIR/$x 
  # echo "Done" > $OUTDIR/$x/.done.raxml.gtrgamma.unpart.1
  # echo "Done" > $OUTDIR/$x/.done.raxml.gtrgamma.100.unpart.2
done

for y in `wc -l $BINDIR/bin*txt|grep -v total|awk '{if ($1>1)print $2}'`; do 
  cat $y|xargs -I@ echo $GENEDIR/@/@.$EXT >.t;  
  x=`echo $y|sed -e "s/.*bin/bin/g"`
  mkdir $OUTDIR/$x
  $BINNING_HOME/perl/concatenate_alignments.pl -i `pwd`/.t -o $OUTDIR/$x/$OUTFILE.fasta -p $OUTDIR/$x/$OUTFILE.part;
  tail -n1 $OUTDIR/$x/$OUTFILE.part 
  # convert_to_phylip.sh `pwd`/913supergenes/$x/sate.noout.fasta 913supergenes/$x/sate.noout.phylip; 
  echo $x done; 
done
