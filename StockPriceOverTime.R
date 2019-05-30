library(dplyr)
library(RPostgreSQL)
library(scales)
library(ggplot2)
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

WeightTable <- dbReadTable(conn = con, name = "company")
WeightTable$MC <- gsub(pattern = "\\$|,", replacement = "", x = WeightTable$marketcap)
WeightTable$MC <- as.numeric(WeightTable$MC)

MCSummary <- summarise(group_by(WeightTable, legacysector), TotMktCap = sum(MC))
#MCSummary$MC2 <- scales::dollar(MCSummary$TotMktCap)

# WeightTable$Exchange <- ifelse(WeightTable$ticker %in% AMEX$Symbol, "AMEX", ifelse(
#   WeightTable$ticker %in% NYSE$Symbol, "NYSE", ifelse(
#     WeightTable$ticker %in% NASDAQ$Symbol, "NASDAQ", "Unknown"
#   )
# ))


WeightTable <- left_join(WeightTable, MCSummary, by = "legacysector")
WeightTable$weight <- WeightTable$MC / WeightTable$TotMktCap

CheckSumsTable <- summarise(group_by(WeightTable, legacysector), totweight = sum(weight))



stockPrices <- read.csv(file = "C:/Users/hwalbert001/Documents/Company Stock Analysis/StockHistoryPctChange.csv", colClasses = "character")

stockplot <- function(SYMBOL = "GOOG", pctChange = T){
  StockData <- subset(stockPrices, Symbol == SYMBOL)
  StockData$date <- as.Date(StockData$date, "%Y-%m-%d")
  StockData <- mutate(StockData, pct_change = (close/lag(close) - 1) * 100)
  # if(pctChange==T){
  #   plot(x = StockData$date, y = StockData$pct_change, type = "l", main = paste("Percent Change Close for:", SYMBOL), xlab = "Date", ylab = "% Change Close")
  #   }else{
  #     plot(x = StockData$date, y = StockData$close, type = "l", main = paste("Close for:", SYMBOL), xlab = "Date", ylab = "Close")
  #   }
  StockData <<- StockData

  par(mfrow=c(2,1))
  plot(x = StockData$date, y = StockData$pct_change, type = "l", main = paste("Percent Change Close for:", SYMBOL), xlab = "Date", ylab = "% Change Close")
  plot(x = StockData$date, y = StockData$close, type = "l", main = paste("Close for:", SYMBOL), xlab = "Date", ylab = "Close")
}



finalData <- data.frame()
counter <- 0
for (i in unique(stockPrices$Symbol)) {
  df <- subset(stockPrices, Symbol == i)
  df$date <- as.Date(df$date, "%Y-%m-%d")
  df <- mutate(df, pct_change = (close/lag(close) - 1) * 100)
  df$variance <- var(df$pct_change, na.rm = T)
  finalData <- bind_rows(finalData, df)
  counter <- counter + 1
cat(counter, i, "\n")

}

finalData$YEAR <- substr(finalData$date, 1,4)







ggplot(WeightTable[1:500,], aes(fill=legacysector, y=MC, x=Exchange)) +
  geom_bar( stat="identity", position="fill")
