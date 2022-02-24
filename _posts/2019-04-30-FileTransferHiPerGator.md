---
title: 'Transferring files to the cluster (HiPerGator)'
date: 2019-04-30
permalink: /posts/2019/04/FileTransferHiPerGator
tags:
  - hipergator
  - bash
  - linux
  - windows
  - transfer files
  
---


Navigating your way on the cluster
------
Now that you are on the cluster, let us learn some basic commands to navigate your way.First  you need to know your location on the cluster. Type:

    pwd

This should print out your "present working directory". If you are logging in for the very first time, HiPerGator should default to the home directory.

`/home/USERNAME`

To do any analysis, or run jobs, it is recommended that you work in the /ufrc directory. Since all the modules are loaded and compatible in the dev version. To change directory, use command:


    cd /ufrc/GROUPNAME/USERNAME


Note that here groupname is your group account created by hipergator. ( If you are a grad student. this should be your PI's account). Replace groupname and username with your own information. 

Creating new directory
------
Now to create a new directory, type:

    mkdir NAME_OF_DIR
    

Replace NAME_OF_DIR with whatever you want to name your directory. For example:

    mkdir 01_test
    
    
Now if you want to see the content of this directory, you need to go into the directory and use list command as follows:

    cd 01_test
    ls

Because you just created this directory, it should be empty.

Copying and moving files within cluster
-------
 To copy a file(already present on the cluster) into this directory, use the command cp(copy) as follows:

    cp PathWhereTheFileIs/filename.txt PathWhereYouWantTheFileToBe

For example, let's assume your file 'scripting.txt' is in directory path `/ufrc/burleigh/nhans/oldfiles` and you want to copy it to newly created directory with path `/ufrc/burleigh/nhans/01_test`

    cp /ufrc/burleigh/nhans/oldfiles/scripting.txt  /ufrc/burleigh/nhans/01_test
    
 
 Now you should have a copy of scripting.txt in 01_test directory. If you want to move the files, use the move command (mv): 
 
    mv /ufrc/burleigh/nhans/oldfiles/scripting.txt  /ufrc/burleigh/nhans/01_test
     

Now if you change directory by:

    cd /ufrc/burleigh/nhans/01_test 

And type:

    ls

You should have scripting.txt in your directory.

These are some basic maneuvering on the cluster. Note that moving and copying files work only when the files are already on the cluster. 


Moving Files from your local machine to HiPerGator
-----
**Big files:**
Try Globus, if your data files are large (hundreds of megabytes or gigabytes).

**Small files:**
For Windows, use SFTP by connecting to the 'sftp.rc.ufl.edu'. SFTP uses port 22 if you have to specify it.

For Mac, you can use either rsync or scp.  
Using scp to transfer files from local machine let's say file.txt to HiPerGator,  first cd  to the location. Let's assume /home/newfiles is the path where file.txt exists. 

    cd /home/newfiles 

You can type ls to check if the file exists there. Then type the following in terminal: 

    scp file.txt USERNAME@hpg.rc.ufl.edu:/ufrc/GROUPNAME/USERNAME
    
 Replace GROUPNAME and USERNAME with your account information. For transfering ALL files with extension .txt, use the wildcard *  as follows:
 
    scp *.txt USERNAME@hpg.rc.ufl.edu:/ufrc/GROUPNAME/USERNAME
    
I personally think that bash is very useful and you can learn some basic commands using this [Cheat Sheet](http://NatyaHans.github.io/files/bashcheatsheet.pdf).
