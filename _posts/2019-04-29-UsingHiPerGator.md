---
title: 'Using the cluster (HiPerGator)'
date: 2019-04-29
permalink: /posts/2019/04/UsingHiPerGator
tags:
  - hipergator
  - bash
  - linux
  - windows
---

If this is your first time using the cluster, I would advice to learn some basic bash scripting. Navigating your way through different directories and cluster would be a lot easier with basic bash commands such as
pwd,cd, mkdir, ls ( **Note to self**: Make a post about it) 


Creating Account on Hipergator
------
To use the HiPerGator, you first need to have an account with UF research computing. To request an account, [submit the request here](https://www.rc.ufl.edu/access/account-request/)


Login to the HiPerGator
------
Depending on the operating system, logging in into the cluster can be easy or a bit tedious. 

For windows, download an SSH client such as [PuTTy](https://www.putty.org/) or [FireZilla](https://filezilla-project.org/).
Set up the SSH client. 
For PuTTy,
     
1. Download PuTTY to your local machine and start the program .
2. Next, connect to hpg.rc.ufl.edu.
3. When asked for the login prompt, type your username (which should be your GatorLink username)
4. Enter your password when prompted. You should be connected to the HiPerGator. 

If on Mac, open Terminal window, type

```console
ssh USERNAME@hpg.rc.ufl.edu
```

Replace USERNAME with your username. Enter the password when prompted. You should be connected to the HiPerGator.

Logging off from the HiPerGator
------
To log off from the HiPerGator, type in the terminal,
   
```console
exit
```
