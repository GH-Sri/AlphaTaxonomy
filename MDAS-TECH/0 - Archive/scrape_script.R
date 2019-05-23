list.files()
setwd("C:/Users/cmercado001/Documents/MDAS - TECH") 

library(readxl)
library(rvest)
library(htmltools)
library(searcher)

companies <- read_xlsx("companylist.xlsx")
the_searches <- do.call(paste0,args = list("nasdaq ",companies$Symbol," ",
                                           companies$Name," ","Company Website")) 

temp. <- paste0("https://www.google.com/search?q=",the_searches[2])
g <-  download.file(url = temp., destfile = "override.html")
site <- read_html("override.html")
txt <- html_text(site)
begin_substring <- gregexpr(pattern = "Company Website,",text = txt)[[1]]
substr(txt, start = begin_substring, stop = begin_substring + 50)
close.connection(g)

fillers <- NULL
for(i in the_searches[1:20]){ 
  
  temp. <- paste0("https://www.bing.com/search?q=",i)
  g <- url(temp.)
  site <- read_html(g)
  txt <- html_text(site)
  begin_substring <- gregexpr(pattern = "Company Website,",text = txt)[[1]]
 x <- substr(txt, start = begin_substring, stop = begin_substring + 50)
 if(grepl("^table,div",x)){ 
   x <- ""
   }
 fillers <- c(fillers,x) 
}


the_searches_bing <- do.call(paste0, args = list("https://www.bing.com/search?q=",companies$Name))

