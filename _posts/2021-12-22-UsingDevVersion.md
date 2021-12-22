---
title: 'Using dev version on hipergator'
date: 2021-12-22
permalink: /posts/2021/12/DevVersionHiperGator/
tags:
  - hipergator
  - dev version
  - slurm 
  - linux
  - allocation
--- 

Allocating resources on dev
--------
Hipergator allows the users to allocate resources for running simple applications on the cluster. Please see the criteria for short testing jobs
allowed on Hipergator [here](https://help.rc.ufl.edu/doc/Development_and_Testing). Remember that the developmental version is only for testing purposes, so do not submit any job that takes a long time to run.
I personally do not enjoy using it for longer runs, but simple applications which do not take too much time can be run on dev version by allocating resources and time as follows:

      module load ufrc
      srundev --time=01:00:00

srundev is the command to use to run your analysis on the dev version interactively. It is a wrapper that specifies "srun --partition=hpg-dev --pty bash -i" so the users have an easier command to access the hpg dev partition
--time is the flag for adding time in 24 hr time format, in this case we are alloting 1 hr. The default time if no time is specified is 10 mins.
We can specify upto 12 hrs as the maximum time. The smaller the time, quicker the allocation. After running these commands successfully, you should get a message

      srun: job 65551444 queued and waiting for resources
      srun: job 65551444 has been allocated resources
      
It is also possible to specify other parameters such as memory allocation, number of tasks and cpus per task
      
      srundev --mem=4gb --ntasks=1 --cpus-per-task=8 --time=01:00:00 

srun command
-------
Used for running parallel jobs on the cluster. There are several options that can be specified by the user, please see [here](https://slurm.schedmd.com/srun.html)

salloc command
-------
Used for pre-allocation of slurm resources, and can be used to run commands and scripts without a delay because those resources are already allocated.

       salloc -n 1 --cpus-per-task=2 --mem=8gb --time=01:00:00

You should receive the following message: 
      salloc: Pending job allocation 65551756
      salloc: job 65551756 queued and waiting for resources
      salloc: job 65551756 has been allocated resources
      salloc: Granted job allocation 65551756

Running the software application
-------
Now you can run any software installed on the hipergator. Load the software of interest
      
      module load SOFTWARE/VERSION
      
And run scripts normally or using srun.

Running Scripts on dev version 
-------
Use the following commands to load the intel and openmpi modules.

      module load intel
      module load openmpi
      srun --mpi=list
      
This should tell you what type of mpi is available. 
      
      srun: MPI types are...  
      srun: pmix_v3
      srun: pmi2
      srun: none
      srun: pmix_v1
      srun: pmix
      srun: pmix_v2
      srun: cray_shasta

Now you can choose accordingly, i choose pmix, to know why you can read about mpi [here](https://slurm.schedmd.com/mpi_guide.html)
You can prefix this with your custom command.

      srun --mpi=pmix CUSTOM_COMMAND_TO_RUN

For example if you want to run an R script,

      srun --mpi=pmix Rscript sample.R
      
If you want to run a software such as revbayes or mr bayes respectively.
      srun --mpi=pmix rb
      srun --mpi=pmix mb



