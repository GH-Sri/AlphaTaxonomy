

list.files()
setwd("C:/Users/cmercado001/Documents/MDAS - TECH") 

library(readxl)
library(rvest)
library(htmltools)

# individual ----
companies <- read_xlsx("companylist.xlsx")
the_searches_yahoo <- do.call(paste0,args = list("https://finance.yahoo.com/quote/",companies$Symbol))
g <- url(the_searches_yahoo[30])
site <- readLines(g)

pattern1 <- "website"
pattern2 <- "http[^\"]*" 

lines_to_check <- grep(pattern1, site)
the_line <- site[lines_to_check]
website_start <- gregexpr(pattern1, the_line)[[1]]

extract <- substr(the_line,website_start,website_start+1000) #1000 chars to be safe 

library(stringr)
dirty_website <- str_extract(pattern = pattern2, string = extract)
dirty_website <- gsub("u002F","",dirty_website)
dirty_website <- gsub("\\","/",dirty_website,fixed = TRUE)
clean_website <- gsub("u002F","",dirty_website)

#'loop through 
#'
#' note some NAs are introduced 

# ---- 
# Run Loop ---- 
ticker_to_web <- function(ticker_site){ 
  require(stringr)
  #' takes the yahoo finance website 
  #' and pulls the website from the company profile section 
  
  # read the lines of the website
  g <- url(ticker_site)
  site <- readLines(g)
  
  # lowercase website is inside the Company Profile
  # it may make sense to use 'website:' if needed 
  pattern1 <- "website"
  pattern2 <- "http[^\"]*" 
  
  lines_to_check <- grep(pattern1, site)
  the_line <- site[lines_to_check]
  website_start <- gregexpr(pattern1, the_line)[[1]]
  
  if(website_start)
  extract <- substr(the_line,website_start,website_start+1000) #1000 chars to be safe 
  
  dirty_website <- str_extract(pattern = pattern2, string = extract)
  dirty_website <- gsub("u002F","",dirty_website)
  dirty_website <- gsub("\\","/",dirty_website,fixed = TRUE)
  clean_website <- gsub("u002F","",dirty_website)
  
  return(clean_website)
  }
companies <- read_xlsx("companylist.xlsx")
the_searches_yahoo <- do.call(paste0,args = list("https://finance.yahoo.com/quote/",companies$Symbol))



website <- NULL
for(i in the_searches_yahoo){ 
  ticker <- i 
  temp. <- "NA" #default value
  # try to get the website 
  # if there is an error, leave it as NA 
  temp. <- tryCatch(expr = ticker_to_web(i), error = function(e){})
  
  # if there is more than 1 website, collapse it with a | 
  # and continue 
  temp. <- paste0(temp.,collapse=" | ") 
  
  website <- rbind(website, 
                   do.call(cbind, args = list(ticker, temp.)))
}

write.csv(website, file = "websites_.csv")
# ----
# ----
