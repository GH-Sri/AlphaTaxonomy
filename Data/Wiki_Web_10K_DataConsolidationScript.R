library(dplyr)
library(RPostgreSQL)
library(scales)
library(ggplot2)
library(data.table)
memory.limit(size = 10000000000000)
# create a connection
# save the password that we can "hide" it as best as we can by collapsing it
pw <- {"mdaspassword"}
# loads the PostgreSQL driver
drv <- dbDriver("PostgreSQL")
# creates a connection to the postgres database
# note that "con" will be used later in each connection to the database
con <- dbConnect(drv, dbname = "mdas",
                 host = "mdas.c33zx3vjrof0.us-east-1.rds.amazonaws.com", port = 5432,
                 user = "mdas", password = pw)
rm(pw) # removes the password
# check for the company table
dbExistsTable(con, "company")
dbListTables(conn = con)
MCData <- dbReadTable(conn = con, name = "company")
CIK <-  dbReadTable(conn = con, name = "cik")
MCData$MC <- gsub(pattern = "\\$|,", replacement = "", x = MCData$marketcap)
MCData$MC <- as.numeric(MCData$MC)

XWALK <- full_join(MCData, CIK, by = c("name"="company"))
XWALK <- XWALK[c("name", "ticker", "cik")]
XWALK <- unique(XWALK)
XWALK[] <- lapply(XWALK, as.character)



#Make a list of all the files
WikiAndWebFiles <- grep(pattern = "doc2vec", x = list.files(path = "C:/Users/hwalbert001/Documents/Company Stock Analysis/Wikipedia", full.names = T), value = T)
#Import each file and stack on top of the previous file
WikiAndWebData <- data.frame()
for (i in WikiAndWebFiles) {
  df <- read.csv(file = i, colClasses = "character")
  WikiAndWebData <- rbind(WikiAndWebData, df)
}
rm(con, df, drv, i, WikiAndWebFiles)

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

BDData <- fread(file = "C:/Users/hwalbert001/Documents/Company Stock Analysis/BDData.csv", colClasses = "character")
#The lookup causes more rows to be added
BDData <- left_join(BDData, XWALK, by = c("CIK"="cik"))
BD10K_Data_Combined <- BDData
BD10K_Data_Combined[c("Name.x", "Symbol")] <- NULL

BDData <- summarise(group_by(BDData, name), Text = paste(text, collapse = ""))
names(BDData) <- c("Name", "Text")

WebData$Source <- "WEB"
WikiData$Source <- "WIKI"
BDData$Source <- "10K"

FINALData <- bind_rows(WebData, WikiData, BDData)

#Export some data
write.csv(MCData, "C:/Users/hwalbert001/Documents/Company Stock Analysis/FinalData/company_names_input.csv", row.names = F)
#"company_names_input.csv"
write.csv(WebData, "C:/Users/hwalbert001/Documents/Company Stock Analysis/FinalData/company_web_out.csv", row.names = F)
#"company_web_out.csv"
write.csv(WikiData, "C:/Users/hwalbert001/Documents/Company Stock Analysis/FinalData/company_wiki_out.csv", row.names = F)
#"company_wiki_out.csv"
write.csv(WikiAndWebData, "C:/Users/hwalbert001/Documents/Company Stock Analysis/FinalData/company_wiki_web_out.csv", row.names = F)
#"company_wiki_web_out.csv"
write.csv(BDData, "C:/Users/hwalbert001/Documents/Company Stock Analysis/FinalData/company_10k_combined_out.csv", row.names = F)
#"company_10k_combined_out.csv"
write.csv(BD10K_Data_Combined, "C:/Users/hwalbert001/Documents/Company Stock Analysis/FinalData/company_10k_per_year_out.csv", row.names = F)
#"company_10k_per_year_out.csv"
write.csv(FINALData, "C:/Users/hwalbert001/Documents/Company Stock Analysis/FinalData/company_10k_web_wiki_out.csv", row.names = F)
#"company_10k_web_wiki_out.csv"
