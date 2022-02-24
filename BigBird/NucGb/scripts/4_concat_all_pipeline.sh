#!/bin/sh

cd /ufrc/burleigh/nhans/summer2017/bird/NucGb/fastadatabase

module load ncbi_blast/2.6.0
module load perl

fdir="/ufrc/burleigh/nhans/summer2017/bird/NucGb/finalalignments";
dirt="/ufrc/burleigh/nhans/summer2017/bird/NucGb/fastadatabase/flag_";


for f in "${fdir}/"*.prune.fasta;
 do
 dab=$(echo $f| cut -f 9 -d '/'); #cut by / and saves the entire names of blastn
 justname=$(echo $dab | cut -f 1 -d '.'); # saves just the names
# echo $justname 
# echo ${dirt}*/$justname*.trimmed.fasta; 
 #echo -e "\n";
 cat ${dirt}*/$justname*.trimmed.fa >$justname.FASTA
done
 
