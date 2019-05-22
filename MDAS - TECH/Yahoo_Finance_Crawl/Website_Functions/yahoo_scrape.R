yahoo_scrape <- function(the_searches_yahoo){ 
  #' accepts a vector of yahoo websites of the form: 
  #' https://finance.yahoo.com/quote/STOCKTICKER
  #' Where STOCKTICKER is the stock item, e.g. Apple is AAPL 
  
  #' requires: ticker_to_web()
  #'
  #' returns a dataframe of each website and the scraped webpages 
  #' exceptions are given blanks or NAs 
  #' Note: multiple sites are collapsed with " | ", singular sites are as is. 

  #' example: 
  #'  yahoo_scrape("https://finance.yahoo.com/quote/AAPL")
  #'  returns:
  #      [,1]                                   [,2]                  
  # [1,] "https://finance.yahoo.com/quote/AAPL" "http://www.apple.com"

  if(require(stringr) == FALSE){ 
    stop("load the stringr library")
  }
  
  
website <- NULL
for(i in 1:length(the_searches_yahoo)){ 
  
  ticker <- the_searches_yahoo[i] 
  temp. <- "NA" #default value
  # try to get the website 
  # if there is an error, leave it as NA 
  temp. <- tryCatch(expr = ticker_to_web(ticker), error = function(e){})
  
  # if there is more than 1 website, collapse it with a | 
  # and continue 
  temp. <- paste0(temp.,collapse=" | ") 
  
  website <- rbind(website, 
                   do.call(cbind, args = list(ticker, temp.)))
 if( (i %% 10) == 0 ){ 
   # get progress on every 10th one, as a percent complete. 
   print( paste0("progress: ",I(100*i/length(the_searches_yahoo)),"%") )
   }
  }

return(website)
  }
