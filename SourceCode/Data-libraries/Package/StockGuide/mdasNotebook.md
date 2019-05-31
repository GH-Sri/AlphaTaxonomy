---
title: "mdasNotebook"
author: "Harold Walbert"
date: "May 20, 2019"
output:
  html_document:
    toc: TRUE
    toc_float: TRUE
    toc_depth: 2
    code_folding: show
---



## Setup

This document goes through the analytics process to collect and collate data, prepare and analyze the data, and finally to visualize the data. The goal is to understand the sectors and industries that companies can be grouped into. This analysis uses open source data combined with machine learning and natural language processing algorithms to perform this task. 

We start with a list taken from the NASDAQ website that has a listing of of Ticker symbols for the entities traded on the NASDAQ exchange. This list serves as the basis for pulling open source data on companies. This list of hosted on the NASDAQ website and changes over time. In order to get the latest list we use the following function created specifically for this: `GetCompanyList(Exchange = "NASDAQ")`.


```r
#?GetCompanyList
#GetCompanyList(Exchange = "NASDAQ")
```


This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:



## Including Plots

You can also embed plots, for example:

![plot of chunk pressure](figure/pressure-1.png)

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
