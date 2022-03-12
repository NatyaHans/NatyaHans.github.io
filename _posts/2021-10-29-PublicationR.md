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
