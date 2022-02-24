#!/bin/sh
#SBATCH --job-name=hertrim_coreNH_ORDERNH  #Job name
#SBATCH --mail-type=FAIL # Mail events (NONE, BEGIN, END, FAIL, FAIL)
#SBATCH --mail-user=nhans@ufl.edu # Where to send mail
#SBATCH --cpus-per-task=4 # Number of cores: Can also use -c=4
#SBATCH --mem-per-cpu=3gb # Per processor memory
#SBATCH -t 12:00:00     # Walltime
#SBATCH -o heretrim_coreNH_ORDERNH.%j.out # Name output file
#SBATCH
#SBATCH --account=burleigh
#SBATCH --qos=burleigh-b

pwd; hostname; date


echo Running PERL

echo There are $SLURM_CPUS_ON_NODE cores available.


module load ncbi_blast/2.6.0
module load perl

fdir="/ufrc/burleigh/nhans/summer2017/bird/NucGb/fastadatabase/flag_ORDERNH";

cd $fdir;
database="ORDERNH.fasta";
table="ORDERNH.table";

gene="coreNH.ORDERNH.blastn";
justname=$(echo $gene | cut -f 1 -d '.'); # saves just the names
echo $justname;

ordername=$(echo $gene | cut -f 2 -d '.'); # saves just the names
echo $ordername;

perl 3_trimblast_pipeline.pl --name=$justname --table=$table --inputdb=$database
 

