#!/bin/sh
#SBATCH --job-name=raxmltania  #Job name
#SBATCH --mail-type=ALL # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pinedae@ufl.edu # Where to send mail
#SBATCH --cpus-per-task=4 # Number of cores: Can also use -c=4
#SBATCH --mem-per-cpu=1gb # Per processor memory can be increase 8gb
#SBATCH -t 18:00:00     # Walltime
#SBATCH -o raxml_output.%j.out # Name output file
#SBATCH
#SBATCH --account=paulay

pwd; hostname; date
echo Working directory is $SLURM_SUBMIT_DIR
cd $SLURM_SUBMIT_DIR

echo There are $SLURM_CPUS_ON_NODE cores available.

module load raxml

# do 1000 bootstraps + likelihood search for the single best tree
raxmlHPC-PTHREADS-SSE3 -f a -m GTRGAMMA -s YOURALIGNMENTSINPHYLIP.phy -p $RANDOM -x $RANDOM -N 1000 -n RAxML_raxmloutput_tania -T $SLURM_TASKS_PER_NODE

