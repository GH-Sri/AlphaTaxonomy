name_clean <- function(x){ 
  #' cleanup parentheses (from wikipedia)
  #' and some unneeded suffixes (Inc., Corp., Ltd) 
  #' and loose spaces (begin or end in space) 
  #' for name-matching between companies - webscrapes - wikipedia 
  x <- gsub(pattern = ",|Inc\\.|Inc|, Inc\\.|Corp\\.|Ltd\\.|\\([^\\)]*)|Corporation",
            replacement = "",x,ignore.case = TRUE)
  x <- gsub("^ | $",replacement = "",x,ignore.case = TRUE)
  return(x)
}