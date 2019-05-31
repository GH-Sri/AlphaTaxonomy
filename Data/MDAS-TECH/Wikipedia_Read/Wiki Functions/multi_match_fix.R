multi_match_fix <- function(matches){ 
  # split wiki matches by delimiter 
  # selected the shortest item
  # use "" as a default 
  
  m <- NULL 
  for(i in matches){ 
  
      if(nchar(i) > 0){ 
  x <- unlist(strsplit(i,split = " | ",fixed = TRUE))
  
  #' use the cleaned names for identifying the shortest match. 
  x <- x[nchar( name_clean(x) ) == min( nchar(name_clean(x)) )]
  
  # select the first item if nchar is the same 
  if(length(x) > 1){ 
    x <- x[1]
                }
  
      } else x <- "" # use "" as default 
  
  # return the entire cleaned column     
  m <- c(m,x)
    }
  
  return(m)
  }