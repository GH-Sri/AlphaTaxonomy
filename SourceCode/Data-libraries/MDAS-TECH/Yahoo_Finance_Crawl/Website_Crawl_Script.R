library(readxl)
library(stringr)


# Read the local copy of the companylist OR get it from Nasdaq  ----

if(("companylist.xlsx" %in% list.files())){ 
  companies <- read_xlsx("companylist.xlsx")
  
  # if not available read from the Nasdaq site 
} else if( !("companylist.xlsx" %in% list.files()) ) { 
  
  message("companylist.xlsx is not in this directory, downloading from Nasdaq site")
  download.file( 
    url = "https://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=NASDAQ&render=download", 
    destfile =  "companylist.csv")
  
  companies <- read.csv("companylist.csv ",stringsAsFactors = FALSE)[,c("Symbol","Name")]
  
  }


#----

# Scrape Yahoo Finance Company Profiles to get website from Ticker ----

the_searches_yahoo <- do.call(paste0,
                              args = list("https://finance.yahoo.com/quote/",companies$Symbol))

source("Website_Functions/ticker_to_web.R") 
source("Website_Functions/yahoo_scrape.R") #loops ticker_to_web()

# 57 minutes to scrape the sites on Local  ----
#
# time1 <- Sys.time()
websites <- yahoo_scrape(the_searches_yahoo)
# time2 <- Sys.time()
#
# time_dif <- time2 - time1
# time_dif # 57 mins
#
# write.csv(websites, file = "websites_full_test.csv")
# ---- 

# Read the previous run site  ---- 
# websites <- read.csv("websites_full_test.csv", stringsAsFactors = FALSE)
# ----

#' for sites that have attached sentences or use sub-sites. 
source("Website_Functions/clean_site.R")
source("Website_Functions/site_decisions.R") #loops clean_site()

# ----

# Identify sites that did and did not get websites from the scrape ---- 
websites <- site_decisions(websites) 
accepted_sites <- websites[[1]]
exceptions_sites <- websites[[2]]

write.csv(exceptions_sites, file = "failed_to_get_website.csv")

# ----
source("Website_Functions/pull_metadata.R")
source("Website_Functions/meta_aggregate.R") # loops pull_metadata() 

# Unit Test 
# Scrape first N websites, assign them to aN object, where N is number of values. 
# n = 25
# system.time(
#   {
#     assign(paste0("a",n), meta_aggregate(accepted_sites[1:n,]))
#   }
# )

# Scrape the sites for metadata 1hr + ----  
 scraped_sites <- meta_aggregate(accepted_sites) 
# may take awhile as well 

write.csv(scraped_sites, file = "metadata_on_accepted_sites.csv")


# websites_with_metadata <- read.csv("metadata_on_accepted_sites.csv",stringsAsFactors = FALSE)

