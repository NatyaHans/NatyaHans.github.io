#!/bin/sh
#SBATCH --job-name=genbank2fasta  #Job name
#SBATCH --mail-type=FAIL # Mail events (NONE, BEGIN, END, FAIL, FAIL)
#SBATCH --mail-user=nhans@ufl.edu # Where to send mail
#SBATCH --cpus-per-task=4 # Number of cores: Can also use -c=4
#SBATCH --mem-per-cpu=1gb # Per processor memory
#SBATCH -t 96:00:00     # Walltime
#SBATCH -o genbank2fasta.%j.out # Name output file
#SBATCH
#SBATCH --account=burleigh
#SBATCH --qos=burleigh-b

pwd; hostname; date


echo Running PERL

echo There are $SLURM_CPUS_ON_NODE cores available.

cd /ufrc/burleigh/nhans/summer2017/bird/MitoGb/GIPHASED/

# Loading the required modules for running bamm
module load perl
perl 1_gb2fa_pipeline.pl MitoBirds.gb MitoBirds
