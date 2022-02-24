#!/bin/sh
#SBATCH --account=burleigh # group name
#SBATCH --qos=burleigh # group quota name
#SBATCH --job-name=ASTRAL   #Job name   
#SBATCH --mail-type=ALL   # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=user@ufl.edu   # Where to send mail 
#SBATCH --cpus-per-task=1   # Number of cores: Can also use -c=4 
#SBATCH --mem-per-cpu=4gb   # Per processor memory
#SBATCH -t 12:00:00   # Walltime
#SBATCH -o ASTRAL.%j.out   # Name output file 
#
pwd; hostname; date

echo Working directory is $SLURM_SUBMIT_DIR
cd $SLURM_SUBMIT_DIR

echo There are $SLURM_CPUS_ON_NODE cores available.

# To allocate memory for ASTRAL: 
export _JAVA_OPTIONS="-Xmx300M"


module load astral

astral -i INPUTGENETREES.tre -o OUTPUTTREE.tre 2>out.log


# Input trees must be in Newick format, can have missing taxa and/or polytomies




