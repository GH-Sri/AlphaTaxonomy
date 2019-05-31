
match_names <- function(wiki_names, db_names){ 
  #' identifies the matches between (cleaned) wikipedia names 
  #' and (cleaned) database names - but retains their original names 
  #' for joining. 
  
  matched <- NULL 
  
  # for every wiki name (note: wiki names are typically shorter / cleaner) 
  # identify if the database contains (starts with) that company name  
  # and get the matches  
  for(i in wiki_names){ 
    temp. <- grepl(paste0("^",name_clean(i)), x = name_clean(db_names), ignore.case = TRUE)
    matches <- unique ( db_names[ (1:length(db_names))[temp.] ] ) # remove duplicates 
    num_matches2 <- length(matches) # counting both total matches and unique matches 
    matched <- rbind.data.frame( 
      matched,
      cbind.data.frame(wiki_company = i, num_matches =  I(mean(temp.)*length(temp.)),
                       companylist_name = paste0(matches,collapse = " | "),stringsAsFactors = FALSE, 
                       unique_matches = num_matches2)
      ,stringsAsFactors = FALSE)    
  }
  
  # if more than 1 unique match is found
  # selected the shortest one (using the cleaned names)
  
  matched$companylist_name <- multi_match_fix(matched$companylist_name)
  # requires the " | " delimiter 
  
  return(matched) 
}