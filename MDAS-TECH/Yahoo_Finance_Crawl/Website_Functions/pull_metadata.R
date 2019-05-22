
#' Takes a website and identifies the meta and description tags 
meta_scrape <- function(website){ 
  #' read the website 
  # and gets the description and keywords 
  #'<meta name="description"...  />
  #'<meta name="keywords"...>
  
  if(require(stringr) == FALSE){ 
    stop("load the stringr library")
  }
  
  w = url(website)
  w = tryCatch(readLines(w),error = function(e){
    return( data.frame(website, description = "",
                       keywords = "" ,stringsAsFactors = FALSE) )
    
  }) # simple html read by line 
  # if there is an error (e.g. 403 Forbidden) just skip. 
  closeAllConnections() # close connection after reading 
  # find the line with the description, ignore uppercase 
  d =  w[grepl(pattern = "<meta name=\"description\"",  
               x = w,ignore.case = TRUE)] 
  if(length(d) > 0){ 
  description <- str_extract(pattern = 'content="[^"]*',string = d)
  description <- substr(description,start = nchar("content=")+2,stop = nchar(description))
  } else description = NA 
  
  # find the line with the keywords 
  k =  w[grepl(pattern = "<meta name=\"keywords\"",  
               x = w,ignore.case = TRUE)]  
  
  if(length(k) > 0){ 
  keywords <- str_extract(pattern = 'content="[^"]*',string = k)
  keywords <- substr(keywords,start = nchar("content=")+2,stop = nchar(keywords))
  } else keywords = NA 
  #' outputs: 
  #' website keywords description 
  
  return( data.frame(website, description, keywords,stringsAsFactors = FALSE) )
  
}
