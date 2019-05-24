library(dplyr)
library(RPostgreSQL)
library(scales)
library(ggplot2)
library(data.table)
library(aws.s3)
memory.limit(size = 10000000000000)

# #In the CMD prompt:
# C:\Users\hwalbert001>set AWS_ACCESS_KEY_ID=AKIAVO5KNXW5I53A6DXN
# C:\Users\hwalbert001>set AWS_SECRET_ACCESS_KEY=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
# C:\Users\hwalbert001>"C:\Program Files\RStudio\bin\rstudio.exe"

AWS_ACCESS_KEY_ID <- Sys.getenv("AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY <- Sys.getenv("AWS_SECRET_ACCESS_KEY")
AWS_DEFAULT_REGION <- "us-east-1"
MCData <- read.csv(text = rawToChar(get_object(object = "Lookup-Data/company_names_input.csv", bucket = "at-mdas-data")))
CIK <- read.csv(text = rawToChar(get_object(object = "Output-For-ETL/companylist.csv", bucket = "at-mdas-data")))
CIK$Name <- trimws(CIK$Name)
CIK <- data.frame(company = CIK$Name, cik = CIK$CIK)
CIK <- unique(CIK)
CIK <- subset(CIK, !is.na(cik))
# create a connection
# # save the password that we can "hide" it as best as we can by collapsing it
# pw <- {"mdaspassword"}
# # loads the PostgreSQL driver
# drv <- dbDriver("PostgreSQL")
# # creates a connection to the postgres database
# # note that "con" will be used later in each connection to the database
# con <- dbConnect(drv, dbname = "mdas",
#                  host = "mdas.c33zx3vjrof0.us-east-1.rds.amazonaws.com", port = 5432,
#                  user = "mdas", password = pw)
# rm(pw) # removes the password
# # check for the company table
# dbExistsTable(con, "company")
# dbListTables(conn = con)
# MCData <- dbReadTable(conn = con, name = "company")
# CIK <-  dbReadTable(conn = con, name = "cik")
# MCData$MC <- gsub(pattern = "\\$|,", replacement = "", x = MCData$marketcap)
# MCData$MC <- as.numeric(MCData$MC)

XWALK <- full_join(MCData, CIK, by = c("name"="company"))
XWALK <- XWALK[c("name", "ticker", "cik")]
XWALK <- unique(XWALK)
XWALK[] <- lapply(XWALK, as.character)



# #Make a list of all the files
# WikiAndWebFiles <- grep(pattern = "doc2vec", x = list.files(path = "C:/Users/hwalbert001/Documents/Company Stock Analysis/Wikipedia", full.names = T), value = T)
# #Import each file and stack on top of the previous file
# WikiAndWebData <- data.frame()
# for (i in WikiAndWebFiles) {
#   df <- read.csv(file = i, colClasses = "character")
#   WikiAndWebData <- rbind(WikiAndWebData, df)
# }
# rm(con, df, drv, i, WikiAndWebFiles)

df1 <- read.csv(text = rawToChar(get_object(object = "Web-Wiki-Raw-Data/public_data_for_doc2vec_1.csv", bucket = "at-mdas-data")))
df2 <- read.csv(text = rawToChar(get_object(object = "Web-Wiki-Raw-Data/public_data_for_doc2vec_2.csv", bucket = "at-mdas-data")))
df3 <- read.csv(text = rawToChar(get_object(object = "Web-Wiki-Raw-Data/public_data_for_doc2vec_3.csv", bucket = "at-mdas-data")))
df4 <- read.csv(text = rawToChar(get_object(object = "Web-Wiki-Raw-Data/public_data_for_doc2vec_4.csv", bucket = "at-mdas-data")))
df5 <- read.csv(text = rawToChar(get_object(object = "Web-Wiki-Raw-Data/public_data_for_doc2vec_5.csv", bucket = "at-mdas-data")))
df6 <- read.csv(text = rawToChar(get_object(object = "Web-Wiki-Raw-Data/public_data_for_doc2vec_6.csv", bucket = "at-mdas-data")))
df7 <- read.csv(text = rawToChar(get_object(object = "Web-Wiki-Raw-Data/public_data_for_doc2vec_7.csv", bucket = "at-mdas-data")))


WikiAndWebData <- bind_rows(df1,df2,df3,df4,df5,df6,df7)

rm(df1,df2,df3,df4,df5,df6,df7)

WikiAndWebData <- WikiAndWebData[,-1]
WikiAndWebData <- unique(WikiAndWebData)
WikiAndWebData[is.na(WikiAndWebData)] <- ""
WikiData <- subset(WikiAndWebData, short_descript != "" | sections_long_descript != "")
# length(unique(WikiData$Name))
WebData <- subset(WikiAndWebData, keywords != "" | description != "")
# length(unique(WebData$Name))

#Write the data 
#write.csv(x = WikiAndWebData, file = "C:/Users/hwalbert001/Documents/Company Stock Analysis/Wikipedia/AllWikiAndWebData.csv", row.names = F)



#The Wiki and Web data is missing alot of information concerning names and tickers...will try to xwalk
#The xwalk has duplicates so it adds a few lines
# WikiData2 <- left_join(WikiData, MCData[c("name", "ticker", "MC")], by = "name")
# WebData2 <- left_join(WebData, MCData[c("name", "ticker", "MC")], by = "name")
WikiData  <- left_join(WikiData, XWALK, by = c("Name"="name"))
WebData <- left_join(WebData, XWALK, by = c("Name"="name"))


# WikiData$FinalTicker <- ifelse(WikiData$Symbol=="", WikiData$ticker, WikiData$Symbol)
# WikiData <- subset(WikiData, !is.na(WikiData$FinalTicker))
WikiData$ConcatText <- paste(WikiData$short_descript, WikiData$sections_long_descript)
WikiData <- summarise(group_by(WikiData, Name), Text = paste(ConcatText, collapse = ""))
# WikiData <- subset(WikiData, TEXT != "NA NA NA NA" )


# WebData$FinalTicker <- ifelse(is.na(WebData$Symbol==""), WebData$ticker, WebData$Symbol)
# WebData <- subset(WebData, !is.na(WebData$FinalTicker))
WebData$ConcatText <- paste(WebData$description, WebData$keywords)
WebData <- summarise(group_by(WebData, Name), Text = paste(ConcatText, collapse = ""))
# WebData <- subset(WebData, TEXT != "NA NA NA NA" )

#BDData2 <- read.csv(text = rawToChar(get_object(object = "10K-Raw-Data/company_10k_per_year_out.csv", bucket = "at-mdas-data"), multiple = T))

save_object(object = "10K-Raw-Data/company_10k_per_year_out.csv", bucket = "at-mdas-data")
BDData <- read.csv(file = paste0(getwd(), "/company_10k_per_year_out.csv"), colClasses = "character")

#BDData <- fread(file = "C:/Users/hwalbert001/Documents/Company Stock Analysis/BDData.csv", colClasses = "character")
#The lookup causes more rows to be added
BDData <- left_join(BDData, XWALK, by = c("CIK"="cik"))
BD10K_Data_Combined <- BDData
BD10K_Data_Combined[c("name.x", "ticker.x")] <- NULL
names(BD10K_Data_Combined)[5] <- "name"

BDData <- summarise(group_by(BD10K_Data_Combined, name), Text = paste(text, collapse = ""))
names(BDData) <- c("Name", "Text")

WebData$Source <- "WEB"
WikiData$Source <- "WIKI"
BDData$Source <- "10K"

FINALData <- bind_rows(WebData, WikiData, BDData)

# #Export some data
# write.csv(MCData, "C:/Users/hwalbert001/Documents/Company Stock Analysis/FinalData/company_names_input.csv", row.names = F)
# #"company_names_input.csv"
# write.csv(WebData, "C:/Users/hwalbert001/Documents/Company Stock Analysis/FinalData/company_web_out.csv", row.names = F)
# #"company_web_out.csv"
# write.csv(WikiData, "C:/Users/hwalbert001/Documents/Company Stock Analysis/FinalData/company_wiki_out.csv", row.names = F)
# #"company_wiki_out.csv"
# write.csv(WikiAndWebData, "C:/Users/hwalbert001/Documents/Company Stock Analysis/FinalData/company_wiki_web_out.csv", row.names = F)
# #"company_wiki_web_out.csv"
# write.csv(BDData, "C:/Users/hwalbert001/Documents/Company Stock Analysis/FinalData/company_10k_combined_out.csv", row.names = F)
# #"company_10k_combined_out.csv"
# write.csv(BD10K_Data_Combined, "C:/Users/hwalbert001/Documents/Company Stock Analysis/FinalData/company_10k_per_year_out.csv", row.names = F)
# #"company_10k_per_year_out.csv"
# write.csv(FINALData, "C:/Users/hwalbert001/Documents/Company Stock Analysis/FinalData/company_10k_web_wiki_out.csv", row.names = F)
# #"company_10k_web_wiki_out.csv"

#Make Archive of objects
copy_object(from_object = "AI-ML/company_web_out.csv", to_object = paste0("AI-ML/Archive/company_web_out",make.names(Sys.time()),".csv"), from_bucket = "at-mdas-data", to_bucket = "at-mdas-data")
copy_object(from_object = "AI-ML/company_10k_combined_out.csv", to_object = paste0("AI-ML/Archive/company_10k_combined_out",make.names(Sys.time()),".csv"), from_bucket = "at-mdas-data", to_bucket = "at-mdas-data")
copy_object(from_object = "AI-ML/company_10k_web_wiki_out.csv", to_object = paste0("AI-ML/Archive/company_10k_web_wiki_out",make.names(Sys.time()),".csv"), from_bucket = "at-mdas-data", to_bucket = "at-mdas-data")
copy_object(from_object = "AI-ML/company_wiki_out.csv", to_object = paste0("AI-ML/Archive/company_wiki_out",make.names(Sys.time()),".csv"), from_bucket = "at-mdas-data", to_bucket = "at-mdas-data")
copy_object(from_object = "AI-ML/company_wiki_web_out.csv", to_object = paste0("AI-ML/Archive/company_wiki_web_out",make.names(Sys.time()),".csv"), from_bucket = "at-mdas-data", to_bucket = "at-mdas-data")

#s3save(MCData, object = "10K-Raw-Data/company_names_input.csv", bucket = "at-mdas-data")
s3save(WebData, object = "AI-ML/company_web_out.csv", bucket = "at-mdas-data")
s3save(WikiData, object = "AI-ML/company_wiki_out.csv", bucket = "at-mdas-data")
s3save(WikiAndWebData, object = "AI-ML/company_wiki_web_out.csv", bucket = "at-mdas-data")
s3save(BDData, object = "AI-ML/company_10k_combined_out.csv", bucket = "at-mdas-data")
#s3save(BD10K_Data_Combined, object = "10K-Raw-Data/company_10k_per_year_out.csv", bucket = "at-mdas-data")
s3save(FINALData, object = "AI-ML/company_10k_web_wiki_out.csv", bucket = "at-mdas-data")



