#!/bin/sh
#SBATCH --job-name=flagblast_coreNH_ORDERNH  #Job name
#SBATCH --mail-type=FAIL # Mail events (NONE, BEGIN, END, FAIL, FAIL)
#SBATCH --mail-user=nhans@ufl.edu # Where to send mail
#SBATCH --cpus-per-task=4 # Number of cores: Can also use -c=4
#SBATCH --mem-per-cpu=4gb # Per processor memory
#SBATCH -t 48:00:00     # Walltime
#SBATCH -o flagblast_coreNH_ORDERNH.%j.out # Name output file
#SBATCH
#SBATCH --account=burleigh
#SBATCH --qos=burleigh-b

pwd; hostname; date


echo Running PERL

echo There are $SLURM_CPUS_ON_NODE cores available.

cd /ufrc/burleigh/nhans/summer2017/bird/NucGb/fastadatabase/flag_ORDERNH/

module load ncbi_blast/2.6.0
module load perl

dir="/ufrc/burleigh/nhans/summer2017/bird/NucGb/fastadatabase/flag_ORDERNH";
gene="/ufrc/burleigh/nhans/summer2017/bird/NucGb/hyphenalignments/coreNH.prune.fasta";

dab=$(echo $gene| cut -f 9 -d '/');
name=$(echo $dab | cut -f 1 -d '.');

#echo $name;
for f in "${dir}/"*.fasta
 do
  #echo $f;
  fedit=$(echo $f| cut -f 10 -d '/');
  #fediti=$(echo $fedit|cut -f 1 -d '.');
   
   echo $fedit;
  perl 2_runblast_pipeline.pl --name=$name --genes=$gene --inputdb=$fedit ;

done
