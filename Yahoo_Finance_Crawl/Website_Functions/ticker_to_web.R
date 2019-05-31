ticker_to_web <- function(ticker_site){ 
  #' takes the yahoo finance website 
  #' and pulls the website from the company profile section
   
  #' example: 
  #'  yahoo_scrape("https://finance.yahoo.com/quote/AAPL")
  #'  returns: "http://www.apple.com"
  
  if(require(stringr) == FALSE){ 
    stop("load the stringr library")
  }
  
  # read the lines of the website
  g <- url(ticker_site)
  site <- readLines(g)
  closeAllConnections() # close connection after reading 
  
  # yahoo finance uses: 
  #'   '  "website":   '           
  #'   in their react code to identify the website.   
  pattern1 <- "\"website\":"
  pattern2 <- "http[^\"]*" 
  
  lines_to_check <- grep(pattern1, site)
  the_line <- site[lines_to_check]
  website_start <- gregexpr(pattern1, the_line)[[1]]
  
  if(length(website_start) > 1){ 
  website_start <- website_start[1]
  }
  extract <- substr(the_line,website_start,website_start+1000) #1000 chars to be safe 
  
  dirty_website <- str_extract(pattern = pattern2, string = extract)
  dirty_website <- gsub("u002F","",dirty_website)
  dirty_website <- gsub("\\","/",dirty_website,fixed = TRUE)
  clean_website <- gsub("u002F","",dirty_website)
  
  return(clean_website)
}