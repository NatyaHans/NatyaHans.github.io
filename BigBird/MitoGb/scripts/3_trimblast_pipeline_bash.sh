#!/bin/sh
#cd /ufrc/burleigh/nhans/1kp/doingBlast/02-SPLITfiles

#dir=/ufrc/burleigh/nhans/1kp/doingBlast/03-MUSCLEresults/
module load perl

missing=0
found=0
for file in *.blastp; # change the name/extension here
    do
    if [ -f $file ]; then 
       found=$((found+1));
       name=$(echo $file| cut -f 1 -d '.'); 
       echo $name;
       cp 3_coretrimblast_pipeline.sh $name".trimblast.sh";
       sed -i -e "s/geneNH/$name/g" $name".trimblast.sh";
       ### Be careful with the following
       sbatch $name".trimblast.sh";
     else
       missing=$((missing+1));
    fi # ends the if statement
    done # ends the do statement

printf "Files found through counter : $found\n\n";
