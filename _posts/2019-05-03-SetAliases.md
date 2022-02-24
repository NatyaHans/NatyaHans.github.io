---
title: ‘Setting up Aliases'
date: 2019-05-03
permalink: /posts/2019/05/SetAliases/
tags:
  - hipergator
  - bash
  - aliases
  - linux
--- 

Setting up Aliases in linux and unix makes life a lot easier. You can choose your own commands and shortcuts to commands you commonly use a lot and save time.
Another way to make life easier is to set up SSH keys so you won't be asked for a password everytime you login to the server.
Felicia did an excellent blog on it already, which you can check out [here](https://fnew.github.io/posts/2019/04/blog_post_4/)

I am going to share some aliases that I use and have added in the .bashrc file (both at my local computer and the HiPerGator). 
I will update this blog if I think of more.

A Note on text editors
------
I have been using the vim editor for 8 years now, and while some people argue that it is a non intuitive way of editing files,
and to me it is muscle memory at this point. You can use any text editor that you are comfortable with (notepad, textedit, nano etc) to open and edit files.
If you do want to learn VI, there is an awesome cheat sheet for [beginner](http://NatyaHans.github.io/files/vi_cheat_sheet.pdf) and when you are more comfortable with it check out the [advanced commands here](https://stac47.github.io/vim/cheat/sheet/2014/02/22/vim-advanced-cheat-sheet.html).
Also some [pretty cool VI stuff here](http://vimsheet.com/advanced.html)


Accessing the .bashrc file
------
The .bashrc file is located in the home directory on your local machine. The location for home directory on my mac is:
`/Users/nhans`, 

On HiPerGator, the .bashrc file is located  in the home directory, which in my case is as follow: 
`/ufrc/burleigh/nhans`


After you open, edit and close the file make sure you source the .bashrc

    source .bashrc


# My favorite Aliases
Alias command in linux can be used to create shortcuts for commands you mostly use. Make sure that you start with alias command and then add a space between the word/combination you would like to use as command. Use a "=" sign and double quotes of the command you want to set up as alias.
Make sure there is no space between the your substitute word,= sign and quotes. 


This is a great way for finding out what is taking so much space on your drives!
------

    alias diskspace="du -S | sort -n -r |more"
    

Show me the size (sorted) of only the folders in this directory
------

    alias folders="find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn"


List by line in reverse time order
------

    alias lsr="ls -ltr";


Naming working directories
------

    alias gbird="cd /ufrc/burleigh/nhans/Cloning_Github/BigBird";
    

Git related alias added
------

    alias gs='git status';
    alias gc='git commit';
    alias ga='git add';
    alias gd='git diff';

    alias gNH='git@github.com:NatyaHans';
    

Don't forget to source the .bashrc after you have, copied and pasted the above Aliases


# Function to extract compressed files

Copy the following to the .bashrc file. This should extract any file  with the following extensions.

     # NH function to extract any file with following extensions
    extract () {
       if [ -f $1 ] ; then
           case $1 in
               *.tar.bz2)   tar xvjf $1    ;;
               *.tar.gz)    tar xvzf $1    ;;
               *.bz2)       bunzip2 $1     ;;
               *.rar)       unrar x $1     ;;
               *.gz)        gunzip $1      ;;
               *.tar)       tar xvf $1     ;;
               *.tbz2)      tar xvjf $1    ;;
               *.tgz)       tar xvzf $1    ;;
               *.zip)       unzip $1       ;;
               *.Z)         uncompress $1  ;;
               *.7z)        7z x $1        ;;
               *)           echo "don't know how to extract '$1'..." ;;
           esac
       else
           echo "'$1' is not a valid file!"
       fi
    }

**USAGE:** the file samplecompressedfolder.tar.gz given as first argument with the command should extract the folder

    extract samplecompressedfolder.tar.gz


# Function to compress a folder or files to tar.gz 

Copy the following to the .bashrc file. This should compress any file or folder to tar.gz format.


    # NH function to compress a file/directory to tar.gz
    compress() {
       if [ -f $1 ] ; then
           echo "$1 is a file";
           case $1 in
               *)   tar czvf $1".tar.gz" $1 ;;
           esac
       elif [ -d $1 ]; then
           echo "$1 is a directory";
           case $1 in
               *)   tar czvf $1".tar.gz" $1 ;;
           esac
       else
          echo "'$1' is not a valid file!"
       fi
    }


**USAGE:**

     compress samplefoldertobecompressed
     
should give you a compressed folder `samplefoldertobecompressed.tar.gz`


# Function to go up when you have multiple subdirectories


     # NH function to go up in a directory 
    up(){
        local d=""
        limit=$1
        for ((i=1 ; i <= limit ; i++))
           do
             d=$d/..
           done
        d=$(echo $d | sed 's/^\///')
        if [ -z "$d" ]; then
           d=..
        fi
        cd $d
        }
        
**USAGE:** to go up 4 directories 

     up 4 


# To find empty files 


    findzero() {
          echo " Files with zero size with extension ------ $1 ------ are : ";
          find . -type f -name "*.$1"  -size 0;
          echo " Total files: ";
          find . -type f -name "*.$1"  -size 0 |wc;
    }

**USAGE:**
     
     findzero txt
     
Here txt can be replaced by the file extension of your choice.     
 
     
# To make a new directory and change into the directory  


    # NH function to mkdir and cd into it
    function mc() {
        mkdir -p "$*" && cd "$*" && pwd
    }

**USAGE:**

    mc madeNewDirAndNowIamInIt
 
 So now if you check your current dir it should be `madeNewDirAndNowIamInIt`
    
    pwd

 
