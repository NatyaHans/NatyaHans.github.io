#!/bin/sh

fdir="/ufrc/burleigh/nhans/summer2017/bird/NucGb/finalalignments"; # directory with old sequences
dirt="/ufrc/burleigh/nhans/summer2017/bird/NucGb/fastadatabase/"; # directory with new sequences

cd $dirt;

for f in "${fdir}/"*.prune.fasta;
 do
  dab=$(echo $f| cut -f 9 -d '/'); #cut by / and saves the entire names of blastn
  justname=$(echo $dab | cut -f 1 -d '.'); # saves just the names
  echo $justname;
  old=$(grep '>' $f | wc -w); # count number of old sequences for each gene
  #printf '\t';
  new=$(grep '>' $justname".FASTA" |wc -w); # count number of new sequences for each gene
  
  dif=$(echo "$(($old-$new))");

  printf 'OLD\tNEW\tOLD-NEW\n';
  printf $old'\t'$new'\t'$dif'\n'; # old - new difference / sequences lost/gained
  echo -e "\t";

 done
