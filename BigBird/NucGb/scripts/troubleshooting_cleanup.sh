#!/bin/sh

echo "CLEANINGUP";
dir="/ufrc/burleigh/nhans/summer2017/bird/NucGb/fastadatabase/flag_";
fdir="/ufrc/burleigh/nhans/summer2017/bird/NucGb/0-Data";

for f in "${fdir}/"*.gz
do
 fedit=$(echo $f| cut -f 9 -d '/');
 # echo $fedit;
 fname=$(echo $fedit | cut -f 1 -d '.');
 echo $fname;
# echo $dir$fname;
 echo "are you sure you want to delete this?";
 rm $dir$fname/heretrim*.sh
 rm $dir$fname/*trimmed.fasta
 #rm $dir$fname/flagblast*.sh
done



