#!/bin/sh
#SBATCH --job-name=musclecoreNH  #Job name
#SBATCH --mail-type=FAIL # Mail events (NONE, BEGIN, END, FAIL, FAIL)
#SBATCH --mail-user=nhans@ufl.edu # Where to send mail
#SBATCH --cpus-per-task=4 # Number of cores: Can also use -c=4
#SBATCH --mem-per-cpu=1gb # Per processor memory
#SBATCH -t 24:00:00     # Walltime
#SBATCH -o musclecoreNH.%j.out # Name output file
#SBATCH
#SBATCH --account=burleigh
#SBATCH --qos=burleigh-b

pwd; hostname; date

module load perl
module load muscle
perl 4_runmuscle_pipeline.pl --name=coreNH.trimmed.fasta
