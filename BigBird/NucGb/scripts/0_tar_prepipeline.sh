#!/bin/sh
#SBATCH --job-name=untar  #Job name
#SBATCH --mail-type=FAIL # Mail events (NONE, BEGIN, END, FAIL, FAIL)
#SBATCH --mail-user=nhans@ufl.edu # Where to send mail
#SBATCH --cpus-per-task=4 # Number of cores: Can also use -c=4
#SBATCH --mem-per-cpu=2gb # Per processor memory
#SBATCH -t 24:00:00     # Walltime
#SBATCH -o untar.%j.out # Name output file
#SBATCH
#SBATCH --account=burleigh
#SBATCH --qos=burleigh-b

pwd; hostname; date


echo Running PERL

echo There are $SLURM_CPUS_ON_NODE cores available.


dir="/ufrc/burleigh/nhans/summer2017/bird/NucGb/0-Data";
cdir="/ufrc/burleigh/nhans/summer2017/bird/NucGb";

cd $dir 

for f in "${dir}/"*.gb;
 do
 #echo $f;
 na=$(echo $f| cut -f 9 -d '/');
 #echo $na;
 name=$(echo $na | cut -f 1 -d '.');
 #echo $name;
 tar -czvf $name.tar.gz $na ;
done

cd $cdir
