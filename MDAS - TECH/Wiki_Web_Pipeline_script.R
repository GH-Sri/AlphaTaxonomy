# Wiki_Web_Pipeline as R Script 

# Download Data from 3 Exchanges 

companylist1 <- "https://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=nasdaq&render=download"
companylist2 <- "https://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=nyse&render=download"
companylist3 <-"https://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=amex&render=download"

download.file(companylist1,destfile = "NASDAQ.csv")
download.file(companylist2, destfile = "NYSE.csv")
download.file(companylist3, destfile = "AMEX.csv")

nasdaq <- read.csv("NASDAQ.csv",stringsAsFactors = FALSE)[,c("Symbol","Name")]
nyse <- read.csv("NYSE.csv",stringsAsFactors = FALSE)[,c("Symbol","Name")]
amex <- read.csv("AMEX.csv",stringsAsFactors = FALSE)[,c("Symbol","Name")]

#  Rbind them 
companies <- rbind.data.frame(nasdaq,nyse,amex,stringsAsFactors = FALSE)
rm(nasdaq,nyse,amex)

#' write to S3 
#' library(aws.s3)
#BUCKET <- Sys.getenv("BUCKET_NAME")

# export combined csvs 
write.csv(companies,file = "traded_companies.csv")
# read.csv("traded_companies.csv",stringsAsFactors = FALSE)

# Search Yahoo Ticker Sites for Company Website 
library(readxl)
library(stringr)

the_searches_yahoo <- do.call(paste0,
                              args = list("https://finance.yahoo.com/quote/",companies$Symbol))

source("Yahoo_Finance_Crawl/Website_Functions/ticker_to_web.R") 
source("Yahoo_Finance_Crawl/Website_Functions/yahoo_scrape.R") #loops ticker_to_web()
websites <- yahoo_scrape(the_searches_yahoo) # eta: 2hrs on local 

source("Yahoo_Finance_Crawl/Website_Functions/clean_site.R")
source("Yahoo_Finance_Crawl/Website_Functions/site_decisions.R") #loops clean_site()
websites <- site_decisions(websites) 
accepted_sites <- websites[[1]]
exceptions_sites <- websites[[2]]

# Write companies where website was successfully collected 
# Write companies where websit was NOT successfully collected
write.csv(accepted_sites,file = "succeeded_getting_website.csv")
write.csv(exceptions_sites, file = "failed_to_get_website.csv")


# Pull Website Metadata 

source("Yahoo_Finance_Crawl/Website_Functions/pull_metadata.R")
source("Yahoo_Finance_Crawl/Website_Functions/meta_aggregate.R") # loops pull_metadata() 
# Scrape the sites for metadata 1hr + ----  
scraped_sites <- meta_aggregate(accepted_sites) 
# may take awhile as well 

# write the metadata for the websites of companies where website was found 
write.csv(scraped_sites, file = "metadata_on_accepted_sites.csv")



# Separate Python Script was used to create the JSON File 

library(rjson)

source("Wikipedia_Read/Wiki Functions/wiki_db_creator.R")
source("Wikipedia_Read/Wiki Functions/name_clean.R")
source("Wikipedia_Read/Wiki Functions/match_names.R")
source("Wikipedia_Read/Wiki Functions/multi_match_fix.R")

wiki_df <- wiki_db_creator("Wikipedia_Read/Wikipedia_Data.json")
matched <- match_names(wiki_names = wiki_df$name, 
                       db_names = companies$Name)[,c("wiki_company","companylist_name")]

wiki_complete <- merge(wiki_df,matched,by.x = "name",by.y = "wiki_company")

write(matched, file = "wiki_company_names_crosswalk.csv")
write(wiki_complete, file = "wiki_with_companylist_name_data.csv")


# 
# The original companylist is connected to the website scrape via ticker and name.
# The original companylist is connected to the wikipedia data via (companylist) name. 
# Wikipedia name is preserved just in case it is needed for future use. 