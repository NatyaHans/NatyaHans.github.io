---
title: 'Using HiPerGator without Dual Factor Authentication every time'
date: 2021-12-01
permalink: /posts/2021/01/UsingHiPerGatorNoMFA
tags:
  - hipergator
  - DualAuthentication
  - bash
  - linux
---

Hipergator recently updated to a dual factor authentication for logging in, which means for people who use it on a daily basis and multiple sessions, it can get annoying pretty fast.
The workaround is to use ssh multiplexing which can allow you to use an existing TCP connection for multiple sessions. More on [multiplexing here](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Multiplexing)
In other words, given that you log in and authenticate once, and that initial terminal remains open, you can log into multiple sessions without authentication.
Although I would advice against it, but you can increase the time from 8hrs.

Generating SSH Keys for passwordless login
------
Open Terminal. Generate SSH key for login into hipergator without password. You can specify the names here if you already have rsa key pair.

```console
ssh-keygen
```

It will ask for passphrase, just press enter if you don’t want any passphrase. A randomart will be generated for the key fingerprint.
You will then have to copy your id  using ssh copy

```console
ssh-copy-id USERNAME@hpg.rc.ufl.edu
```
It will ask for password for your gatorlink. After you have entered the password, your ssh keys are set up in ~/.ssh folder.
You can cd into the path to check if the public and private key pair exists. Now you can login without needing to enter password using

```console
ssh YOURNAME@hpg.rc.ufl.edu
```
This is great but you will still need to autheticate using dual factor authentication.


Adding Multiplexing to ssh config file
------
Now you can create a config file in the ~/.ssh folder. To do so, either use vim or nano or an editor of your choosing to create a file ~/.ssh/config 
Now add the following information into this config file.

```console
Host hpg

    User USERNAME
    HostName hpg.rc.ufl.edu
    Port 2222
    IdentityFile ~/.ssh/id_rsa
    ControlPath ~/.ssh/cm-%r@%l-%h:%p
    ControlMaster auto
    ControlPersist 8h
```

You will need to change the USERNAME to your gatorlink, and the name of identity file ( if different name was chosen for generating ssh keys)
You can also change the number of hours in ControlPersist if you want to keep it longer, although i wouldn’t recommend it. Save and close the file.
Now you can login using:

```console
ssh hpg
```
At this point if you want you can create an alias for it as well. See my [blog post here](https://natyahans.github.io/posts/2019/05/SetAliases/)


For transfering files using scp
------
From Computer to hipergator

```console
scp FileONcomputerToTransfer hpg:/path/on/cluster
```

From Hipergator to computer
```console
scp hpg:/path/on/cluster path/on/computer
```

