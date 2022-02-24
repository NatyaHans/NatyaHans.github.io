#!/bin/sh

module load perl

missing=0
found=0
for file in *.final.fasta; # change the name/extension here
    do
    if [ -f $file ]; then 
       found=$((found+1));
       name=$(echo $file| cut -f 1 -d '.'); 
       echo $name;
       cp 2_coreblastp_pipeline.sh $name".blast.sh";
       sed -i -e "s/geneNH/$name/g" $name".blast.sh";
       ### Be careful with the following
       sbatch $name".blast.sh";
     else
       missing=$((missing+1));
    fi # ends the if statement
    done # ends the do statement

printf "Files found through counter : $found\n\n";
