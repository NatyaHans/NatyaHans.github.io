#!/bin/sh
#SBATCH --job-name=trimmingeneNH  #Job name
#SBATCH --mail-type=FAIL # Mail events (NONE, BEGIN, END, FAIL, FAIL)
#SBATCH --mail-user=nhans@ufl.edu # Where to send mail
#SBATCH --cpus-per-task=4 # Number of cores: Can also use -c=4
#SBATCH --mem-per-cpu=1gb # Per processor memory
#SBATCH -t 96:00:00     # Walltime
#SBATCH -o trimminggeneNH.%j.out # Name output file
#SBATCH
#SBATCH --account=burleigh
#SBATCH --qos=burleigh-b

pwd; hostname; date


echo Running PERL

echo There are $SLURM_CPUS_ON_NODE cores available.

cd /ufrc/burleigh/nhans/summer2017/bird/MitoGb/GIPHASED/

# Loading the required modules for running the perl script
module load perl
perl 3_trimblastp_pipeline.pl  --table=MitoBirds.cds.table --inputdb=MitoBirds.aa.fasta --name=geneNH

