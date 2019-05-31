
meta_aggregate <- function(acceptable_sites){ 
  #' loops through the acceptable sites 
  #' and aggregates them into a single dataframe 
  #' also extracts the key for an easy merge on the original data 
  #' returns a dataframe of: 
  #' ticker | yahoo finance site | website | description | keyword
  #'
  
  
meta_table <- NULL
for(i in 1:nrow(acceptable_sites)){ 
  finance_site <- acceptable_sites[i,I(ncol(acceptable_sites)-1)]
  ticker <- gsub("https://finance.yahoo.com/quote/","",finance_site,fixed=TRUE)
  temp. <- meta_scrape(acceptable_sites[i,ncol(acceptable_sites)])
  
  temp. <- data.frame(ticker, finance_site, temp., stringsAsFactors = FALSE)
  
  meta_table <- rbind.data.frame(meta_table, temp., stringsAsFactors = FALSE)
}

return(meta_table)
  }