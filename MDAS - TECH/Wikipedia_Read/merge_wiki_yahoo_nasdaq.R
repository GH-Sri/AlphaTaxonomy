
# Comments here load the original data ----
yh_data <- "metadata_on_accepted_sites.csv"
yh_data <- read.csv(yh_data, stringsAsFactors = FALSE)

companylist <- "traded_companies.csv"
companylist <- read.csv(companylist,stringsAsFactors = FALSE)

full_data <- merge(companylist,yh_data, by.x = "Symbol",
                   by.y = "ticker",
                   all.x = TRUE, 
                   all.y = TRUE)

write.csv(full_data,"website_exchanges_merge.csv")
# ----

# Read from below ----
setwd("./Wikipedia_Read")
full_data <- read.csv("website_exchanges_merge.csv",
                      stringsAsFactors = FALSE)
wiki_df <- read.csv("wiki_scrape.csv",stringsAsFactors = FALSE)


x <- full_data$Name
w <- wiki_df$name

source("Wiki Functions/wiki_db_creator.R")
source("Wiki Functions/name_clean.R")
source("Wiki Functions/match_names.R")
source("Wiki Functions/multi_match_fix.R")

matched <- match_names(wiki_names = w, db_names = x)[,c("wiki_company","companylist_name")]


setwd("..")


# Function Core Below ----
# 
# matched <- NULL
# for(i in name_clean(w)){
#   temp. <- grepl(paste0("^",i), x = name_clean(x), ignore.case = TRUE)
#   matches <- unique ( x[ (1:length(x))[temp.]   ] )
#   num_matches2 <- length(matches)
#   matched <- rbind.data.frame(
#     matched,
#     cbind.data.frame(wiki_company = i, num_matches =  I(mean(temp.)*length(temp.)),
#                      matches = paste0(matches,collapse = " | "),stringsAsFactors = FALSE,
#                      unique_matches = num_matches2)
#     ,stringsAsFactors = FALSE)
# }
# 




#---- 

#---- 
