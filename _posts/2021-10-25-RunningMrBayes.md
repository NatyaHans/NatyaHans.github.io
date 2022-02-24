---
title: ‘Bayesian inference using MrBayes on HiPerGator'
date: 2021-10-25
permalink: /posts/2021/10/RunningMrBayes/
tags:
  - hipergator
  - gene tree
  - mrbayes
  - phylogenetics 
  - linux
--- 

Update on hipergator and allocating resources on dev
--------
Hipergator moved it's storage from ufrc to blue  so the path should be changed to /blue/GROUPNAME/NAME/.
I personally do not enjoy using it for longer runs, but simple applications which do not take too much time can 
be run on dev version by allocating resources and time as follows:

      module load ufrc
      srundev --time=01:00:00

srundev is the command to use to run your analysis on the dev version interactively. 
--time is the flag for adding time in 24 hr time format, in this case we are alloting 1 hr. 

The smaller the time, quicker the allocation. After running these commands successfully, you should get a message 

      srun: job 65551444 queued and waiting for resources
      srun: job 65551444 has been allocated resources

      
Really brief background on MrBayes
--------
MrBayes is a commonly used program for Bayesian inference and model selection in evolutionary biology and phylogenetics. For a range of function please refer to it's official  website [here](http://nbisweden.github.io/MrBayes/). MrBayes as the name suggests uses MCMC (Markov chain Monte Carlo) method to estimate posterior distribution of model parameters   

Inputs and for MrBayes outputs
--------
The input for MrBayes is a nexus format file. The dataset is usually gene alignments or the concatenated gene alignments in case of a supermatrix. If you are not familiar with nexus format [click here](https://en.wikipedia.org/wiki/Nexus_file) for the wikipedia article. 
The first few lines of the nexus file contains information about the dataset including the taxa number, taxa labels and character length (or length of the alignment).

The output for MrBayes are several files, including a consensus tree. These are broken down here 
*.vstat
*.stat
*.trprobs
*.parts
*.pstat
*.lstat
*.con.tre - has the consensus gene tree 




Using MrBayes on Hipergator, interactively
---------
If you want to use a small dataset, which only takes few mins and want to see the output immediately, then running MrBayes interactively makes sense. It is a good idea for beginners to get the lay of the land (command line) instead of using a submission script, as it makes it easier to catch errors early on.

To run an application interactively, first you have to allocate resources and specify time (as mentioned in the update part of this tutorial). There are several modules that are needed to run MrBayes.

    module load intel/2020.0.166
    module load openmpi/4.1.1
    module load mrbayes/3.2.6

Now let's make sure we have a separate directory on the cluster for running MrBayes with all the necessary files. We need sequence information in nexus format. For this tutorial I am using the sample Nexus data in ape [package](https://cran.r-project.org/web/packages/ape/ape.pdf) called cynipids, by [Rokas et al 2002](https://www.sciencedirect.com/science/article/pii/S1055790301910322)
The sample input dataset used to run for this tutorial can be downloaded here : [cynipids.nex](). It has 8 taxa and 159 char.


Make sure this nexus file is present in the directory where you are running MrBayes. Now enter the following command to read in your nexus file as input:

    srun --mpi=pmix mb -i cynipids.nex


