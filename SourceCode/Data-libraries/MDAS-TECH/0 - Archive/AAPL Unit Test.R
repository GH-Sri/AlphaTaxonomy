library(readxl)
library(stringr)
# Company List From Nasdaq ----

setwd("~/MDAS - TECH")
if( !("companylist.xlsx" %in% list.files()) ){ 
  stop("companylist.xlsx is not in this directory")
} 
companies <- read_xlsx("companylist.xlsx")

# Scrape Yahoo Finance Company Profiles to get website from Ticker ----

the_searches_yahoo <- do.call(paste0,args = list("https://finance.yahoo.com/quote/",companies$Symbol))

APPLE <-  grep("AAPL",the_searches_yahoo)
APPLE <- the_searches_yahoo[APPLE]
source("Website_Functions/ticker_to_web.R") 
source("Website_Functions/yahoo_scrape.R") #loops ticker_to_web()

yahoo_scrape(APPLE)
#' unit test 
#' result: 
# [,1]                                   [,2]                  
# [1,] "https://finance.yahoo.com/quote/AAPL" "http://www.apple.com"

APPLE <- grep("AAPL",the_searches_yahoo)
APPLE <- the_searches_yahoo[APPLE]
GOOG <- grep("GOOG",the_searches_yahoo) # there are two sites here  
GOOG <- the_searches_yahoo[GOOG]

yahoo_scrape(c(APPLE,GOOG))

# Unit test for multiple sites, even under multiple CIKs 
# yahoo_scrape(c(APPLE,GOOG))
# [,1]                                    [,2]                  
# [1,] "https://finance.yahoo.com/quote/AAPL"  "http://www.apple.com"
# [2,] "https://finance.yahoo.com/quote/GOOG"  "http://www.abc.xyz"  
# [3,] "https://finance.yahoo.com/quote/GOOGL" "http://www.abc.xyz"  

#' Not all sites are so clean.  
#' consider the following sites: 

site_test5 <- yahoo_scrape(the_searches_yahoo[1:5])

#' 
source("Website_Functions/clean_site.R")
source("Website_Functions/site_decisions.R") #loops clean_site()



source("Website_Functions/pull_metadata.R")
source("Website_Functions/meta_aggregate.R") # loops pull_metadata() 
