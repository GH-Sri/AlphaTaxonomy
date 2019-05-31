# Updates the Wikipedia Object Fully 

setwd("~/MDAS - TECH")
#' these files are ALL EXCHANGES website scrape  but ONLY NASDAQ WIKI 
files <- c("./Results_of_Wiki_Web_Pipeline_Scripts/public_data_for_doc2vec_1.csv",
"./Results_of_Wiki_Web_Pipeline_Scripts/public_data_for_doc2vec_2.csv",
"./Results_of_Wiki_Web_Pipeline_Scripts/public_data_for_doc2vec_3.csv",
"./Results_of_Wiki_Web_Pipeline_Scripts/public_data_for_doc2vec_4.csv",
"./Results_of_Wiki_Web_Pipeline_Scripts/public_data_for_doc2vec_5.csv",
"./Results_of_Wiki_Web_Pipeline_Scripts/public_data_for_doc2vec_6.csv",
"./Results_of_Wiki_Web_Pipeline_Scripts/public_data_for_doc2vec_7.csv")

source("./file_combine.R") #MDAS - TECH parent directory 
source("Wikipedia_Read/Wiki Functions/wiki_db_creator.R")
source("Wikipedia_Read/Wiki Functions/name_clean.R")
source("Wikipedia_Read/Wiki Functions/match_names.R")
source("Wikipedia_Read/Wiki Functions/multi_match_fix.R")
source("Wikipedia_Read/Wiki Functions/combine.R")


combined_files <- file_combine(files)


wiki_update <- function(final_data_to_update, new_wiki_JSON){ 
  #' Separates the data from the combined data 
  #' and replace the wikipedia portion with the new wikipedia data
  #' from the new wiki JSON file 
  #' 
  companies <- final_data_to_update[,c("Symbol","Name")]
  website_data <-  final_data_to_update[,c("Symbol","Name","finance_site", 
                                           "website","description", "keywords")]
  website_data$ticker <- website_data$Symbol # legacy col names 
  new_wiki_data <- wiki_db_creator(new_wiki_JSON)
  matched <- match_names(wiki_names = new_wiki_data$name, 
                         db_names = companies$Name)[,c("wiki_company","companylist_name")]
  wiki_complete <- merge(new_wiki_data,matched,by.x = "name",by.y = "wiki_company")
  wiki_relevant <- wiki_complete[wiki_complete$companylist_name != "",] 
 
  m1 <- merge(companies,wiki_relevant,by.x = "Name",by.y = "companylist_name",all.x = TRUE)
  m1 <- m1[m1$Name != "",] # ugly subset not sure why any name blanks would occur 
  
  r <- merge(m1, website_data, all.x = TRUE)
  
return(r)
 }

test <- wiki_update(combined_files, "./Wikipedia_Read/Wikipedia_Data.json")

