---
title: ‘Modules on HiPerGator'
date: 2019-05-01
permalink: /posts/2019/05/ModulesHiPerGator/
tags:
  - hipergator
  - bash
  - running jobs
  - modules
---


Modules on HiPerGator
------ 
The tutorial available on UFRC website does a pretty good job explaining how to load a software for running jobs on the cluster.  
[Click here for Module Tutorial by UFRC](https://help.rc.ufl.edu/doc/Modules_Basic_Usage) 
After you have loaded the list of modules you want to load, you can save the modules to a default list by,

    module save
    
This will show the following message: 
`Saved current collection of modules to: "default"` 

If you quit and login to the HiPerGator again, typing the following should restore your modules loaded from last session:

    module restore 
    

Personal Modules
------
If you want to create a personalized list of modules you can follow this [tutorial here](https://help.rc.ufl.edu/doc/Modules).  Don't forget to add the module list name to .bashrc file for this to work. The .bashrc file is located in your home directory. Be careful with this file, it is a super useful file and can make your life easier as we can create multiple aliases. (**Note to self**: Make a post about ALIASES)
