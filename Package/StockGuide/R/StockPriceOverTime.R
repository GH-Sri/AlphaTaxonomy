library(dplyr)
stockplot <- function(SYMBOL = "GOOG", pctChange = T){
  data <- subset(stockPrices, Symbol == SYMBOL)
  data$date <- as.Date(data$date, "%Y-%m-%d")
  data <- mutate(data, pct_change = (close/lag(close) - 1) * 100)
  if(pctChange==T){
    plot(x = data$date, y = data$pct_change, type = "l", main = paste("Percent Change Close for:", SYMBOL), xlab = "Date", ylab = "% Change Close")
    }else{
      plot(x = data$date, y = data$close, type = "l", main = paste("Close for:", SYMBOL), xlab = "Date", ylab = "Close")
  }
}
