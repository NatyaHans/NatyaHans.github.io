---
title: ‘Phylogenetic Analysis using RAxML on HiPerGator'
date: 2019-05-04
permalink: /posts/2019/05/RunningRAxML/
tags:
  - hipergator
  - bash
<<<<<<< HEAD
  - aliases
  - linux
--- 
RAxML(or Randomized Axelerated Maximum Likelihood is a program used for building large maximum likelihood inferred phylogenetic trees. It can also be used for alignment analysis or certain analysis of phylogenetic trees themselves. It was developed by [Alexis Stamatakis](https://cme.h-its.org/exelixis/index.html) 
The paper on RAxML-HPC  https://academic.oup.com/bioinformatics/article/22/21/2688/251208 

For more information on RAxML and it's importance click [here for the manual](https://cme.h-its.org/exelixis/resource/download/NewManual.pdf)(https://cme.h-its.org/exelixis/software.html 
The wikipedia article on HiPerGator address and covers how to run mpi (parallel) version  of RAxML. I am just going to talk about how to put all that information in a single threaded.


=======
  - RAxML
  - linux
--- 
edit from NH: I wrote this post on RAxML back in 2019, forgot to push it to GitHub and modified it in Dec 2021 with updates.


Really brief background 
--------
RAxML(or Randomized Axelerated Maximum Likelihood is a program used for building large maximum likelihood inferred phylogenetic trees. It can also be used for alignment analysis or certain analysis of phylogenetic trees themselves. It was developed by [Alexis Stamatakis](https://cme.h-its.org/exelixis/index.html). You can check out the paper on [RAxML-HPC here](https://academic.oup.com/bioinformatics/article/22/21/2688/251208). 
It was originally derived from fastDNAml which was derived from Joe Felsentein’s dnaml included in the PHYLIP package.

For more information on RAxML and it's importance click [here for the manual](https://cme.h-its.org/exelixis/resource/download/NewManual.pdf) and  for software information [here](https://cme.h-its.org/exelixis/software.html). 
The wiki [article](https://help.rc.ufl.edu/doc/RAxML) on HiPerGator address and covers how to run mpi (parallel) version  of RAxML. I am just going to talk about how to put all that information in a single threaded. 

RAxML takes gene alignments as input in [phylip format](https://evolution.genetics.washington.edu/phylip/doc/sequence.html) and gives a ML tree  
Getting files and folders ready
--------
You can download a sample slurm script to be modified [here](http://NatyaHans.github.io/files/slurm_4_tania_raxml.sh) and a sample phylip format alignment [here](http://NatyaHans.github.io/files/sample.phy).
After you login to Hipergator, make a separate folder, I named the folder raxml_analysis here.
Then you should move the slurm script into the folder using mv command if the files are already on Hipergator or using scp (see the transferring  files blog) (or cyberduck or globus) if the files are on your computer. 
You should also move your alignment file which should be in phylip format into this folder.  

```console
mkdir raxml_analyis
mv slurm_raxml.sh raxml_analyis
mv sample.phy raxml_analyis
```
Now change directory and list the files that are present in the folder

```console
cd raxml_analysis
ls
```

Your output should look like this if all the files are correctly there, please make sure this is true before proceeding.

```console
slurm_raxml.sh
sample.phy
```

RAxML on HiperGator
--------
Before you load RAxML, you will need to load the following modules

```console
module load intel/2018.1.163  
module load openmpi/3.0.0
```
Let's check what version of  RAxML on hipergator using 

```console
module spider raxml
```

If you want to load a specific version for example 7.9.1 for raxml, use

```console
module load raxml/7.9.1
```
otherwise type

```console
module load raxml
```
which will default to the most recent version, which is 8.2.12 (as of UPDATE: Dec 2021)

If you need the documentation available on hipergator to see more options at any point,

```console
raxmlHPC -h 
```
The above commands takes you to the raxml page which allows you update and modify the following command according to your dataset.
Now we are ready to run RAxML, using

``` console
raxmlHPC-SSE3 -f a -m GTRGAMMA -s sample.phy -p $RANDOM -x $RANDOM -N 1000 -n RAxML_OUTPUTFILENAME -T $SLURM_TASKS_PER_NODE
```

Let's break down the this line further:
raxmlHPC-SSE3 is a single threaded(serial) application, so if you wish to use a multithread application use raxmlHPC-PTHREADS-SSE3 instead.

-f selects the algorithm, in this case a refers to the rapid bootstrap analysis for best scoring ML tree (check more options

-m specifies the substitution model, in this case GTRGAMMA, we can use other models for both nucleotides and amino acids, (check more options by scrolling down to the -m at manual.)
For example some of the available AA substitution models:
                DAYHOFF, DCMUT, JTT, MTREV, WAG, RTREV, CPREV, VT, 
                BLOSUM62, MTMAM, LG, MTART, MTZOA, PMB, HIVB, HIVW, 
                JTTDCMUT, FLU, STMTREV, DUMMY, DUMMY2, AUTO, LG4M, LG4X, 
                PROT_FILE, GTR_UNLINKED, GTR

-s for specifying SequenceFileName, sample.phy in this case

-p is for parsimony random seed, $RANDOM in this case

-x specifies random seed for rapid bootstrapping, $RANDOM in this case

-N specifies number of Runs , 1000 in this case

-n specifies the output file name which you can change, RAxML_OUTPUTFILENAME in this case

-T specifies the number of threads, which is 1 in our case specified in the line as #SBATCH --cpus-per-task=1


Here is a brief description of the slurm script for each line in the comments 
```console
#SBATCH --job-name=raxmlcoreNH  #Job name - can be changed here ( no spaces)
#SBATCH --mail-type=FAIL # Mail events (NONE, BEGIN, END, FAIL, FAIL) ( you only get notification when the job fails, customisable)
#SBATCH --mail-user=USERNAME@ufl.edu # Where to send mail
#SBATCH --cpus-per-task=1 # Number of cores: Can also use -c=4  for multithreading
#SBATCH --mem-per-cpu=1gb # Per processor memory
#SBATCH -t 05:00:00     # Walltime 5 hrs ( increase or decrease depending on dataset, max limit 96 hrs)
#SBATCH -o raxmlcoreNH.%j.out # Name output file - change it to however you like 
#SBATCH --account=YOURGROUPNAME # this should be your umbrella group name, so please change it
#SBATCH --qos=YOURGROUPNAME

pwd; hostname; date # prints current directory, your name and date
echo Working directory is $SLURM_SUBMIT_DIR # prints out the current working directory (from where you submit the slurm script)
cd $SLURM_SUBMIT_DIR # changes the directory to the current working directory

echo There are $SLURM_CPUS_ON_NODE cores available. # prints the number of nodes you specified
module load raxml # loading raxml default version

# do 1000 bootstraps + likelihood search for the single best tree
raxmlHPC-SSE3 -f a -m GTRGAMMA -s sample.phy -p $RANDOM -x $RANDOM -N 1000 -n RAxML_OUTPUTFILENAME -T $SLURM_TASKS_PER_NODE
```
>>>>>>> origin/master

