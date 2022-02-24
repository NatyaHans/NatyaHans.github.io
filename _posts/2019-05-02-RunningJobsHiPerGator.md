---
title: ‘Running jobs on HiPerGator'
date: 2019-05-02
permalink: /posts/2019/05/RunningJobsHiPerGator/
tags:
  - hipergator
  - bash
  - running jobs
---

Breakdown of Slurm Script
------
HiPerGator moved from a PBS to Slurm(Simple Linux Utility for Resource Management), in 2015? or 2016?, not sure.  
But let's break down the sample bash script line by line , which you can [download here](http://NatyaHans.github.io/files/slurm_4_tania_raxml.sh)

`#!/bin/sh`: Important first line that informs it is a shell script.  

`#SBATCH --job-name=JOBNAME`: Name of the job (can be changed by the user).  

`#SBATCH --mail-type=ALL` :  Mail events that the user chooses to receive. Options include: (NONE, BEGIN, END, FAIL, ALL).  

`#SBATCH --mail-user=USERNAME@ufl.edu` : Where to send email  

`#SBATCH --cpus-per-task=4` :  Number of cores to be used for this job  

`#SBATCH --mem-per-cpu=1gb` :  Per processor memory and can be increased to 8gb  

`#SBATCH -t 18:00:00 ` : Time required to run a job. The format is hours:minutes:seconds.  
If you want to add day, for example using `#SBATCH -t 1-4:20:50` will make the job scheduled to be run for 1 day 4 hrs 20mins and 50 seconds (unless it finishes first)  

`#SBATCH -o OUTPUTNAME.%j.out ` :  # Name of the output file (can be changed by the user).   

`#SBATCH --account=GROUPNAME`  : # Name of the group to be specified by the user).  

`pwd; hostname; date`  : Prints out the current working directory, hostname and date respectively   

`echo Working directory is $SLURM_SUBMIT_DIR`  : The working directory is printed in the output file, and it is the directory from which the slurm command was sent.   

`cd $SLURM_SUBMIT_DIR`  :  Changes directory from where the slurm command was sent.  

`echo There are $SLURM_CPUS_ON_NODE cores available.` : prints out the number of core available.   

The script then follows the list of modules you want to load and then software specific command requirements. The sample slurm script, shows how to run RAxML on HiPerGator. 

Running Jobs on HiPerGator
------
**To submit a job**,

    sbatch nameofthejob.sh
    
For example,

    sbatch slurm_4_tania_raxml.sh

This will print something like: `Submitted batch job 35808155`, if your job gets submitted to the cluster. The number is the *jobid*. 

**To check the status of the job**,
    
    squeue -u username

For example,
  
    squeue -u nhans


    JOBID PARTITION     NAME        USER ST       TIME  NODES NODELIST(REASON)
    35808155 hpg2-comp nameofthejob  nhans PD       0:00      1 (None)
    
PARTITION - Which partition on cluster  
NAME - the script you submitted  
USER - your username  
TIME - time it has been running  
ST- status, R means running PD means pending  
NODES- how many nodes assigned to the job  

**To cancel a job**,  

    scancel jobid
    
For example,

    scancel 35808155
    



