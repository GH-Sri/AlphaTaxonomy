# Wiki_Web_Pipeline as R Script 
# BATCH 7 

library(rjson)
library(readxl)
library(stringr)

source("Yahoo_Finance_Crawl/Website_Functions/ticker_to_web.R") 
source("Yahoo_Finance_Crawl/Website_Functions/yahoo_scrape.R") #loops ticker_to_web()

source("Yahoo_Finance_Crawl/Website_Functions/clean_site.R")
source("Yahoo_Finance_Crawl/Website_Functions/site_decisions.R") #loops clean_site()

source("Yahoo_Finance_Crawl/Website_Functions/pull_metadata.R")
source("Yahoo_Finance_Crawl/Website_Functions/meta_aggregate.R") # loops pull_metadata() 

source("Wikipedia_Read/Wiki Functions/wiki_db_creator.R")
source("Wikipedia_Read/Wiki Functions/name_clean.R")
source("Wikipedia_Read/Wiki Functions/match_names.R")
source("Wikipedia_Read/Wiki Functions/multi_match_fix.R")
source("Wikipedia_Read/Wiki Functions/combine.R")

wiki_df <- wiki_db_creator("Wikipedia_Read/Wikipedia_Data.json")

# SET A BATCH NUMBER FOR ALL WRITES 
batch_number = 7 

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
write.csv(companies,file = paste0("traded_companies_",batch_number,".csv"))
# read.csv("traded_companies.csv",stringsAsFactors = FALSE)

# Search Yahoo Ticker Sites for Company Website 

rng = list()
for(i in 1:floor(nrow(companies)/1000)){ 
  rng[[i]] <- ((i-1)*1000+1):(i*1000) 
}
rng[[i+1]] <- (i*1000 + 1):nrow(companies)

companies <- companies[rng[[batch_number]],]

the_searches_yahoo <- do.call(paste0,
                              args = list("https://finance.yahoo.com/quote/",companies$Symbol))


websites <- yahoo_scrape(the_searches_yahoo) # eta: 2hrs on local 

websites <- site_decisions(websites) 
accepted_sites <- websites[[1]]
exceptions_sites <- websites[[2]]
# Write companies where website was successfully collected 
# Write companies where websit was NOT successfully collected
write.csv(accepted_sites,file = paste0("succeeded_getting_website_",batch_number,".csv"))
write.csv(exceptions_sites, file = paste0("failed_to_get_website_",batch_number,".csv"))


# Pull Website Metadata 

# Scrape the sites for metadata 1hr + ----  
scraped_sites <- meta_aggregate(accepted_sites) 
# may take awhile as well 

# write the metadata for the websites of companies where website was found 
write.csv(scraped_sites, file = paste0("metadata_on_accepted_sites",batch_number,".csv"))


# Separate Python Script was used to create the JSON File 


matched <- match_names(wiki_names = wiki_df$name, 
                       db_names = companies$Name)[,c("wiki_company","companylist_name")]

wiki_complete <- merge(wiki_df,matched,by.x = "name",by.y = "wiki_company")

write.csv(matched, file = paste0("wiki_company_names_crosswalk_",batch_number,".csv"))
write.csv(wiki_complete, file = paste0("wiki_with_companylist_name_data_",batch_number,".csv"))


# The original companylist is connected to the website scrape via ticker and name.
# The original companylist is connected to the wikipedia data via (companylist) name. 
# Wikipedia name is preserved just in case it is needed for future use. 


final_data <- combine(companylist = companies,
                      website_metadata = scraped_sites,
                      wiki_data = wiki_complete)

write.csv(final_data,file = paste0("public_data_for_doc2vec_",batch_number,".csv"))