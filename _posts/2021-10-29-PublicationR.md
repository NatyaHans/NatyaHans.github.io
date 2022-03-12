---
title: 'Publication Quality Figures in R'
date: 2021-10-29
permalink: /posts/2021/10/PublicationR/
tags:
  - RMarkdown
  - RNotebook
  - R
  - RStudio
  - tidyverse
---

This tutorial is written to guide relatively new R students on how to make a publication ready figures in R. It can be daunting to figure this out on your own and look at several websites to figure out which R packages are needed,along with how to fulfill each journal's requirement for fiures, so I am going to try to keep this short and simple. Here are a list of packages that are needed and can be easily installed from CRAN.


```{r echo=FALSE}
all.lib<-c("reshape2","ggplot2","gridExtra","ggpubr","ggthemes","scales","RColorBrewer") #add libraries here
#install.packages(all.lib)
lapply(all.lib,require,character.only=TRUE)
```

I like creating a vector of all packages and loading them together using lapply function. Of course if the packages are not already installed, you will have to install them and then this line can be commented out. 

Next, I prefer using a colorblind friendly palette for all of my figures for easy of accessibility. I like the blues and purples so i created my own palette here:
```{r}
my.blues<-c("#9EBCDA","#9ECAE1","#6BAED6","#4292C6","#2171B5","#08519C","#08306B","#9E9AC8","#807DBA","#6A51A3","#54278F","#3F007D","#8C6BB1","#88419D","#810F7C","#4D004B")
pie(rep(1,length(my.blues)),col=my.blues)
```
This is what the palette looks like:

![image](https://user-images.githubusercontent.com/49882391/157997772-4432c46d-b07e-41e3-9fa9-a202ceb21344.png)<!-- .element height="50%" width="50%" -->

Or you can also use the colorblind friendly palettes in RColorBrewer package as follows:

```{r}
par(mar=c(3,4,2,2))
display.brewer.all(colorblindFriendly = TRUE) 
#getPalette = colorRampPalette(colorblind_pal())
```
![image](https://user-images.githubusercontent.com/49882391/157997917-9f8d5b76-c077-451c-9f2b-5c3b20e388fb.png){
  width: 70%;
  border: none;
  background: none;
}


Now the fun begins. Let's create some fun figures. 

- add the code here (find the markdown)

