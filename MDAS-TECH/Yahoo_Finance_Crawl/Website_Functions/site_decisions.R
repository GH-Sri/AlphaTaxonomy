site_decisions <- function(site_dataframe){ 
  #' accepts the output of yahoo_scrape 
  #' cleans each website using clean_site() 
  #' and chooses an appropriate site 
  #' outputs a list including a dataframe: 
  #' ticker_site | clean_website 
  #' and an exceptions dataframe: 
  #'  ticker_site | NA 
  #' for each ticker, split the sites on the collapse  | 
  #' if .com is followed by "/", "<" or " " truncate to .com 
  #' then if the site contains s.yimg (yahoo img) ignore that site entirely 
  #' 

  
  # the last column has the websites 
  
  acceptable_sites <- NULL
  exception_sites  <- NULL 
  a <- NULL 
  for(i in 1:nrow(site_dataframe)){ 
    temp. <- site_dataframe[i, ncol(site_dataframe)]
    temp. <- unlist(strsplit(temp., split = " | ", fixed = TRUE))
    temp. <- clean_site(temp.)
    temp. <- temp.[!(is.na(temp.))]
    temp. <- gsub(" .*", "", temp.)
    
    temp. <- gsub("Â","",temp.,ignore.case = TRUE)
    temp. <- temp.[nchar(temp.) > 3] 
    if(length(temp.) > 1){  # take the first one, now that NAs and blanks are taken out. 
      temp. <- temp.[1]
    } 
    if(length(temp.) == 0 ){ 
      temp. <- ""
      }
    site_dataframe[i, ncol(site_dataframe)] <- temp.
    a <- rbind.data.frame(a, site_dataframe[i,], stringsAsFactors = FALSE)
} 
  
  acceptable_sites <- a[a[,ncol(a)] != "",]
  exception_sites  <- a[a[,ncol(a)] == "",]
  
  return( list(acceptable_sites, exception_sites) )
}






